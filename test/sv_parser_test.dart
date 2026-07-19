// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

import 'package:test/test.dart';
import 'package:sv2rohd/sv2rohd.dart';

List<ModuleDeclaration> parse(String source) {
  final diagnostics = DiagnosticCollector();
  final parser =
      SvParser(source, diagnostics: diagnostics, sourceName: 'test.sv');
  final modules = parser.parseCompilationUnit();
  expect(diagnostics.hasErrors, isFalse,
      reason: diagnostics.diagnostics.map((d) => d.message).join('\n'));
  return modules;
}

void main() {
  group('SvParser modules', () {
    test('parses module header with parameters and ANSI ports', () {
      final modules = parse('''
module counter #(
  parameter WIDTH = 8,
  parameter int DEPTH = 4
) (
  input  logic             clk,
  input  logic             rst_n,
  input  logic [WIDTH-1:0] d,
  output logic [WIDTH-1:0] q
);
endmodule
''');

      expect(modules, hasLength(1));
      final module = modules.single;
      expect(module.name, 'counter');
      expect(module.parameters.map((p) => p.name), ['WIDTH', 'DEPTH']);
      expect(
        (module.parameters[0].defaultValue as LiteralExpression).value,
        8,
      );
      expect(module.ports.map((p) => p.name), ['clk', 'rst_n', 'd', 'q']);
      expect(module.ports[0].direction, PortDirection.input);
      expect(module.ports[3].direction, PortDirection.output);
      expect(module.ports[0].width, isNull);
      expect(module.ports[2].width, isNotNull);
    });

    test('parses multiple modules in one file', () {
      final modules = parse('''
module a(input logic x, output logic y);
  assign y = x;
endmodule

module b(input logic p, output logic q);
  assign q = ~p;
endmodule
''');
      expect(modules.map((m) => m.name), ['a', 'b']);
    });

    test('parses signal declarations including unpacked arrays', () {
      final module = parse('''
module m;
  logic [7:0] bus;
  logic flag, other;
  logic [3:0] mem [0:15];
endmodule
''').single;

      final signals = module.items.whereType<SignalDeclaration>().toList();
      expect(signals.map((s) => s.name), ['bus', 'flag', 'other', 'mem']);
      expect(signals[0].width, isNotNull);
      expect(signals[1].width, isNull);
      expect(signals[3].unpackedDims, hasLength(1));
    });

    test('parses multi-dimensional unpacked arrays', () {
      final module = parse('''
module m;
  logic [7:0] cells [0:3][0:1];
endmodule
''').single;

      final signal = module.items.whereType<SignalDeclaration>().single;
      expect(signal.unpackedDims, hasLength(2));
    });

    test('parses localparam as a local parameter', () {
      final module = parse('''
module m;
  localparam IDLE = 0;
endmodule
''').single;
      expect(module.parameters.single.name, 'IDLE');
      expect(module.parameters.single.isLocal, isTrue);
    });
  });

  group('SvParser always blocks', () {
    test('extracts clock from always_ff sensitivity list', () {
      final module = parse('''
module m(input logic clk, input logic rst_n, output logic q);
  always_ff @(posedge clk or negedge rst_n) begin
    q <= 1'b1;
  end
endmodule
''').single;

      final block = module.items.whereType<AlwaysBlock>().single;
      expect(block.kind, BlockKind.alwaysFf);
      expect(block.clock, 'clk');
      expect(block.negedgeClock, isFalse);
    });

    test('captures a second edge signal as an async reset trigger', () {
      final module = parse('''
module m(input logic clk, input logic rst_n, output logic q);
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) q <= 1'b0;
    else q <= 1'b1;
  end
endmodule
''').single;

      final block = module.items.whereType<AlwaysBlock>().single;
      expect(block.clock, 'clk');
      expect(block.negedgeClock, isFalse);
      expect(block.asyncResetSignal, 'rst_n');
      expect(block.asyncResetActiveLow, isTrue);
    });

    test(
        'picks the signal literally named clk as the clock regardless of '
        'sensitivity-list order', () {
      final module = parse('''
module m(input logic clk, input logic rst_n, output logic q);
  always_ff @(negedge rst_n or posedge clk) begin
    if (!rst_n) q <= 1'b0;
    else q <= 1'b1;
  end
endmodule
''').single;

      final block = module.items.whereType<AlwaysBlock>().single;
      expect(block.clock, 'clk');
      expect(block.asyncResetSignal, 'rst_n');
    });

    test('classifies always @(posedge clk) as sequential', () {
      final module = parse('''
module m(input logic clk, output logic q);
  always @(posedge clk) q <= 1;
endmodule
''').single;
      final block = module.items.whereType<AlwaysBlock>().single;
      expect(block.kind, BlockKind.alwaysFf);
    });

    test('classifies always_comb and always @* as combinational', () {
      final module = parse('''
module m(input logic a, output logic x, output logic y);
  always_comb x = a;
  always @* y = ~a;
endmodule
''').single;
      final blocks = module.items.whereType<AlwaysBlock>().toList();
      expect(blocks, hasLength(2));
      expect(blocks.every((b) => b.kind == BlockKind.alwaysComb), isTrue);
    });
  });

  group('SvParser statements', () {
    ModuleDeclaration parseBody(String body) => parse('''
module m(input logic clk, input logic a, input logic b, output logic q);
  logic [7:0] x;
  always_ff @(posedge clk) begin
$body
  end
endmodule
''').single;

    test('distinguishes blocking and non-blocking assignments', () {
      final module = parseBody('''
    x = a;
    q <= b;
''');
      final block = module.items.whereType<AlwaysBlock>().single;
      final stmts = (block.body as SequentialBlock).statements;
      expect((stmts[0] as AssignmentStatement).type, AssignmentType.blocking);
      expect(
          (stmts[1] as AssignmentStatement).type, AssignmentType.nonBlocking);
    });

    test('parses if/else-if chains', () {
      final module = parseBody('''
    if (a) q <= 1'b0;
    else if (b) q <= 1'b1;
    else q <= a;
''');
      final block = module.items.whereType<AlwaysBlock>().single;
      final ifStmt =
          (block.body as SequentialBlock).statements.single as IfStatement;
      expect(ifStmt.elseBranch, isA<IfStatement>());
      expect((ifStmt.elseBranch as IfStatement).elseBranch, isNotNull);
    });

    test('parses case statements with multiple values and default', () {
      final module = parseBody('''
    case (x)
      8'd0, 8'd1: q <= a;
      8'd2: q <= b;
      default: q <= 1'b0;
    endcase
''');
      final block = module.items.whereType<AlwaysBlock>().single;
      final caseStmt =
          (block.body as SequentialBlock).statements.single as CaseStatement;
      expect(caseStmt.items, hasLength(2));
      expect(caseStmt.items[0].values, hasLength(2));
      expect(caseStmt.defaultCase, isNotNull);
    });
  });

  group('SvParser expressions', () {
    IrExpression parseAssignValue(String expr) {
      final module = parse('''
module m(input logic [7:0] a, input logic [7:0] b, output logic [7:0] y);
  assign y = $expr;
endmodule
''').single;
      return module.items.whereType<ContinuousAssignment>().single.value;
    }

    test('respects operator precedence', () {
      final value = parseAssignValue('a + b * a') as BinaryExpression;
      expect(value.operator, BinaryOperator.add);
      expect(
          (value.right as BinaryExpression).operator, BinaryOperator.multiply);
    });

    test('parses based literals with width', () {
      final value = parseAssignValue("8'hFF") as LiteralExpression;
      expect(value.value, 255);
      expect(value.width, 8);
    });

    test('preserves x/z wildcard bits on sized binary literals', () {
      final value = parseAssignValue("4'b1z0z") as LiteralExpression;
      expect(value.wildcardBits, '1z0z');
    });

    test('expands a single wildcard hex digit to 4 bits', () {
      final value = parseAssignValue("8'hAz") as LiteralExpression;
      expect(value.wildcardBits, '1010zzzz');
    });

    test('expands ? wildcards the same as z', () {
      final value = parseAssignValue("4'b1???") as LiteralExpression;
      expect(value.wildcardBits, '1zzz');
    });

    test('does not set wildcardBits when there are no x/z digits', () {
      final value = parseAssignValue("4'b0001") as LiteralExpression;
      expect(value.wildcardBits, isNull);
    });

    test('parses unbased zero literal', () {
      final value = parseAssignValue("'0") as LiteralExpression;
      expect(value.value, 0);
      expect(value.width, isNull);
    });

    test('parses concatenation and replication', () {
      final concat = parseAssignValue('{a, b}') as ConcatenationExpression;
      expect(concat.expressions, hasLength(2));

      final repl =
          parseAssignValue('{{4{a[7]}}, a[3:0]}') as ConcatenationExpression;
      expect(repl.expressions.first, isA<ReplicationExpression>());
      expect(repl.expressions.last, isA<PartSelectExpression>());
    });

    test('parses conditional expressions', () {
      final value = parseAssignValue('a[0] ? a : b');
      expect(value, isA<ConditionalExpression>());
    });

    test('unwraps size casts', () {
      final value = parseAssignValue("8'(a + 1)");
      expect(value, isA<BinaryExpression>());
    });

    test('parses reduction operators', () {
      final value = parseAssignValue('|a') as UnaryExpression;
      expect(value.operator, UnaryOperator.reductionOr);
    });
  });

  group('SvParser hierarchy', () {
    test('parses module instantiation with named connections', () {
      final module = parse('''
module top(input logic clk, output logic [7:0] out);
  logic [7:0] tmp;
  adder #(.WIDTH(8)) u_adder (
    .clk(clk),
    .a(tmp),
    .sum(out)
  );
endmodule
''').single;

      final inst = module.items.whereType<ModuleInstantiation>().single;
      expect(inst.moduleName, 'adder');
      expect(inst.instanceName, 'u_adder');
      expect(inst.parameterConnections.single.portName, 'WIDTH');
      expect(inst.portConnections.map((c) => c.portName), ['clk', 'a', 'sum']);
    });

    test('parses generate for and if blocks', () {
      final module = parse('''
module m #(parameter N = 4) (input logic clk, input logic d);
  logic [7:0] q [0:N-1];
  generate
    for (genvar i = 0; i < N; i++) begin : gen_loop
      if (i == 0) begin
        always_ff @(posedge clk) q[i] <= {8{d}};
      end else begin
        always_ff @(posedge clk) q[i] <= q[i-1];
      end
    end
  endgenerate
endmodule
''').single;

      final forGen = module.items.whereType<ForGenerateBlock>().single;
      expect(forGen.condition, isA<BinaryExpression>());
      final ifGen = forGen.body.items.whereType<IfGenerateBlock>().single;
      expect(ifGen.elseBranch, isNotNull);
    });

    test('parses a case-generate with multi-value items and a default', () {
      final module = parse('''
module m #(parameter MODE = 0) (input logic [7:0] a, output logic [7:0] y);
  generate
    case (MODE)
      0: begin
        assign y = a;
      end
      1, 2: begin
        assign y = ~a;
      end
      default: begin
        assign y = 8'h00;
      end
    endcase
  endgenerate
endmodule
''').single;

      final caseGen = module.items.whereType<CaseGenerateBlock>().single;
      expect(caseGen.items, hasLength(3));
      expect(caseGen.items[0].values, hasLength(1));
      expect(caseGen.items[1].values, hasLength(2));
      // The default branch is represented by an item with empty values.
      expect(caseGen.items[2].values, isEmpty);
    });
  });
}
