// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

import 'package:test/test.dart';
import 'package:sv2rohd/sv2rohd.dart';

/// Converts an inline SV module and returns its generated ROHD source.
String convert(String sv, {DiagnosticCollector? diagnostics}) {
  final converter = SV2ROHD(diagnostics: diagnostics);
  // Write to a temp-free path by returning the string form directly.
  return converter.convertSource(sv);
}

void main() {
  group('function inlining', () {
    test('inlines a single-return function', () {
      final out = convert('''
module m(input logic [7:0] a, input logic [7:0] b, output logic [7:0] y);
  function automatic logic [7:0] add(logic [7:0] x, logic [7:0] z);
    return x + z;
  endfunction
  assign y = add(a, b);
endmodule
''');
      expect(out, contains('y <= (a + b);'));
      expect(out, isNot(contains('add(')));
    });

    test('lowers an if/else function to a ternary mux', () {
      final out = convert('''
module m(input logic [7:0] a, input logic [7:0] b, output logic [7:0] y);
  function automatic logic [7:0] max2(logic [7:0] x, logic [7:0] z);
    if (x > z) return x;
    else return z;
  endfunction
  assign y = max2(a, b);
endmodule
''');
      expect(out, contains('y <= (mux(a.gt(b), a, b));'));
    });

    test('inlines local temporaries and nested calls', () {
      final out = convert('''
module m(input logic [7:0] a, input logic [7:0] b, output logic [7:0] y);
  function automatic logic [7:0] add(logic [7:0] x, logic [7:0] z);
    return x + z;
  endfunction
  function automatic logic [7:0] twice_sum(logic [7:0] x, logic [7:0] z);
    logic [7:0] t;
    t = add(x, z);
    return t + t;
  endfunction
  assign y = twice_sum(a, b);
endmodule
''');
      // t = (a + b), then t + t.
      expect(out, contains('y <= ((a + b) + (a + b));'));
    });

    test('lowers a case function to a nested ternary', () {
      final out = convert('''
module m(input logic [1:0] op, input logic [7:0] a, input logic [7:0] b,
         output logic [7:0] y);
  function automatic logic [7:0] alu(logic [1:0] o, logic [7:0] x, logic [7:0] z);
    case (o)
      2'd0: return x + z;
      2'd1: return x - z;
      default: return x & z;
    endcase
  endfunction
  assign y = alu(op, a, b);
endmodule
''');
      // Nested ternary: op==0 ? a+b : (op==1 ? a-b : a&b).
      expect(out, contains('mux('));
      expect(out, contains('(a + b)'));
      expect(out, contains('(a - b)'));
      expect(out, contains('(a & b)'));
    });

    test('reports an error for an un-inlinable function body', () {
      final diagnostics = DiagnosticCollector();
      convert('''
module m(input logic [7:0] a, output logic [7:0] y);
  function automatic logic [7:0] loopy(logic [7:0] x);
    logic [7:0] acc;
    acc = 0;
    for (int i = 0; i < 8; i++) acc = acc + x;
    return acc;
  endfunction
  assign y = loopy(a);
endmodule
''', diagnostics: diagnostics);

      // The body has a loop, so it can't be inlined: a warning on the
      // function plus an error at the call site.
      expect(
        diagnostics.warnings.map((d) => d.code),
        contains('GEN0030'),
      );
      expect(
        diagnostics.errors.map((d) => d.code),
        contains('GEN0032'),
      );
    });
  });
}
