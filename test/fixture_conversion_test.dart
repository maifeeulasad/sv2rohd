import 'dart:io';

import 'package:test/test.dart';
import 'package:sv2rohd/sv2rohd.dart';

void main() {
  group('fixture conversion', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('sv2rohd-fixtures-');
    });

    tearDown(() {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    test('adder emits module header and sequential body', () {
      final converter = SV2ROHD();
      final outputFile = File('${tempDir.path}/adder.dart');

      final output = converter.convert(
        'fixtures/sv_samples/adder.sv',
        outputPath: outputFile.path,
      );

      expect(outputFile.existsSync(), isTrue);
      expect(output, contains('class Adder extends Module'));
      expect(output, contains("addInput('clk', clkSource"));
      expect(output, contains("addOutput('sum'"));
      expect(output, contains('{int width = 8}'));
      expect(output, contains("addInput('a', aSource, width: width)"));
      expect(output, contains("addOutput('sum', width: width + 1)"));
      expect(output, contains('Sequential(clk'));
      expect(output, contains('If(~rstN'));
      // SystemVerilog context rules extend a and b to the width of sum so
      // the carry bit is preserved.
      expect(
        output,
        contains('sum < (a.zeroExtend(sum.width) + b.zeroExtend(sum.width))'),
      );
      expect(output, contains('ready < 1'));
    });

    test('alu emits combinational case logic and elaborated generates', () {
      final converter = SV2ROHD();
      final outputFile = File('${tempDir.path}/alu.dart');

      final output = converter.convert(
        'fixtures/sv_samples/alu.sv',
        outputPath: outputFile.path,
      );

      expect(outputFile.existsSync(), isTrue);
      expect(output, contains('class Alu extends Module'));
      expect(output, contains('late final List<Logic> stage'));
      expect(output, contains('late final Logic validPipe'));
      expect(output, contains('{int width = 8, int depth = 4}'));
      expect(output, contains('Combinational(['));
      expect(output, contains('Case(op'));
      // All seven operations of the case statement are converted.
      expect(output, contains('result < (a + b)'));
      expect(output, contains('result < (a - b)'));
      expect(output, contains('result < (a & b)'));
      expect(output, contains('result < (a | b)'));
      expect(output, contains('result < (a ^ b)'));
      expect(output, contains('result < (a << 1)'));
      expect(output, contains('result < (a >>> 1)'));
      // The for-generate is elaborated into a Dart loop over the parameter.
      expect(output, contains('for (var i = 0; i < depth; i++)'));
      expect(output, contains('stage[i] < stage[i - 1]'));
      // The if-generate becomes a Dart if on the parameter.
      expect(output, contains('if (width > 16)'));
      expect(output, contains('overflow <= Const(0'));
    });

    test('multiplier emits sequential logic and product assignment', () {
      final converter = SV2ROHD();
      final outputFile = File('${tempDir.path}/multiplier.dart');

      final output = converter.convert(
        'fixtures/sv_samples/multiplier.sv',
        outputPath: outputFile.path,
      );

      expect(outputFile.existsSync(), isTrue);
      expect(output, contains('class Multiplier extends Module'));
      expect(output, contains('late final Logic counter'));
      expect(output, contains('late final Logic partial'));
      expect(output, contains('late final Logic resultReg'));
      expect(output, contains('Sequential(clk'));
      expect(output, contains('If(~rstN'));
      expect(output, contains('product <= resultReg;'));
    });

    test(
        'async_reset uses Sequential reset/resetValues sugar and warns '
        'about the async-reset limitation', () {
      final converter = SV2ROHD();
      final outputFile = File('${tempDir.path}/async_reset.dart');

      final output = converter.convert(
        'fixtures/sv_samples/async_reset.sv',
        outputPath: outputFile.path,
      );

      expect(outputFile.existsSync(), isTrue);
      expect(output, contains('class AsyncResetReg extends Module'));
      expect(output, contains('Sequential(clk, ['));
      expect(output, contains('q < d'));
      expect(output, contains('], reset: ~rstN, resetValues: {'));
      expect(output, contains('q: 0,'));

      // The installed ROHD version has no async-trigger primitive, so this
      // must always be flagged rather than silently modeled as synchronous.
      expect(
        converter.diagnostics.warnings.map((d) => d.code),
        contains('GEN0026'),
      );
      expect(
        converter.diagnostics.warnings
            .map((d) => d.message)
            .any((m) => m.contains('synchronous-equivalent')),
        isTrue,
      );
    });

    test(
        'casez_wildcard preserves wildcard bits instead of collapsing them '
        'to 0', () {
      final converter = SV2ROHD();
      final outputFile = File('${tempDir.path}/casez_wildcard.dart');

      final output = converter.convert(
        'fixtures/sv_samples/casez_wildcard.sv',
        outputPath: outputFile.path,
      );

      expect(outputFile.existsSync(), isTrue);
      expect(output, contains('CaseZ(bits, ['));
      expect(output, contains("Const(LogicValue.ofString('1zzz'))"));
      expect(output, contains("Const(LogicValue.ofString('01zz'))"));
      expect(output, contains("Const(LogicValue.ofString('001z'))"));
      // The one case item with no wildcard digits keeps the plain form.
      expect(output, contains('Const(1, width: bits.width)'));
    });

    test('keyword_names escapes Dart-reserved identifiers but keeps SV names',
        () {
      final converter = SV2ROHD();
      final outputFile = File('${tempDir.path}/keyword_names.dart');

      final output = converter.convert(
        'fixtures/sv_samples/keyword_names.sv',
        outputPath: outputFile.path,
      );

      expect(outputFile.existsSync(), isTrue);
      // Dart identifiers are escaped...
      expect(output, contains('late final Logic in_;'));
      expect(output, contains('late final Logic is_;'));
      expect(output, contains('late final Logic switch_;'));
      expect(
          output, contains('KeywordNames(Logic in_Source, Logic is_Source)'));
      // ...but the ROHD-level SV port/signal names are preserved verbatim.
      expect(output, contains("addInput('in', in_Source"));
      expect(output, contains("addInput('is', is_Source"));
      expect(output, contains("Logic(name: 'switch'"));
      expect(converter.hasErrors, isFalse);
    });

    test('matrix_regs emits nested lists for a 2D unpacked array', () {
      final converter = SV2ROHD();
      final outputFile = File('${tempDir.path}/matrix_regs.dart');

      final output = converter.convert(
        'fixtures/sv_samples/matrix_regs.sv',
        outputPath: outputFile.path,
      );

      expect(outputFile.existsSync(), isTrue);
      expect(output, contains('late final List<List<Logic>> cells;'));
      // One List.generate per dimension, with a per-element flattened name.
      expect(
        output,
        contains('cells = List.generate(rows, (i0) => '
            'List.generate(cols, (i1) => '
            "Logic(name: 'cells_\${i0}_\${i1}', width: width)));"),
      );
      // Two-level constant indexing in the generated logic.
      expect(output, contains('cells[r][c] < d'));
      expect(output, contains('q <= cells[0][0]'));
      expect(converter.hasErrors, isFalse);
    });

    test('case_generate lowers to an if/else chain over the parameter', () {
      final converter = SV2ROHD();
      final outputFile = File('${tempDir.path}/case_generate.dart');

      final output = converter.convert(
        'fixtures/sv_samples/case_generate.sv',
        outputPath: outputFile.path,
      );

      expect(outputFile.existsSync(), isTrue);
      expect(output, contains('if (mode == 0) {'));
      expect(output, contains('} else if (mode == 1) {'));
      // A multi-value item becomes an OR of equality checks.
      expect(output, contains('} else if (mode == 2 || mode == 3) {'));
      // The default branch becomes the trailing else.
      expect(output, contains('} else {'));
      expect(output, contains('y <= (a + b)'));
      expect(output, contains('y <= a;'));
      expect(converter.hasErrors, isFalse);
    });

    test('fsm converts a typedef-enum state machine', () {
      final converter = SV2ROHD();
      final outputFile = File('${tempDir.path}/fsm.dart');

      final output = converter.convert(
        'fixtures/sv_samples/fsm.sv',
        outputPath: outputFile.path,
      );

      expect(outputFile.existsSync(), isTrue);
      // Enum members become local int constants...
      expect(output, contains('final idle = 0;'));
      expect(output, contains('final run = 1;'));
      expect(output, contains('final done = 2;'));
      // ...and the enum-typed signals become 2-bit logic.
      expect(output, contains("state = Logic(name: 'state', width: 2)"));
      expect(
          output, contains("nextState = Logic(name: 'next_state', width: 2)"));
      // Case items and comparisons reference the member constants.
      expect(output, contains('Case(state, ['));
      expect(output, contains('CaseItem(Const(idle, width: state.width)'));
      expect(output, contains('active <= state.eq(run)'));
      // The ternary branches are sized to the assignment target.
      expect(
        output,
        contains('mux(go, Const(run, width: nextState.width), '
            'Const(idle, width: nextState.width))'),
      );
      expect(converter.hasErrors, isFalse);
    });

    test('hierarchy emits both modules and resolved instantiations', () {
      final converter = SV2ROHD();
      final outputFile = File('${tempDir.path}/hierarchy.dart');

      final output = converter.convert(
        'fixtures/sv_samples/hierarchy.sv',
        outputPath: outputFile.path,
      );

      expect(outputFile.existsSync(), isTrue);
      expect(output, contains('class FullAdder extends Module'));
      expect(output, contains('class HalfAdder extends Module'));
      // Named connections are resolved to positional constructor arguments.
      expect(output, contains('final ha1 = HalfAdder(a, b);'));
      expect(output, contains('final ha2 = HalfAdder(s1, cin);'));
      // Instance outputs are wired back to the connected signals.
      expect(output, contains('s1 <= ha1.s;'));
      expect(output, contains('sum <= ha2.s;'));
      expect(output, contains('cout <= (c1 | c2);'));
    });
  });
}
