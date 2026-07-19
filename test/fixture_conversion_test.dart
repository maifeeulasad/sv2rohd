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
