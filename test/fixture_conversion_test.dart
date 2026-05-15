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
      expect(output, contains("definePort('clk', clk)"));
      expect(output, contains('If(~rstN'));
      expect(output, contains('sum <= (a + b);'));
      expect(output, contains('ready <= 1;'));
    });

    test('alu emits combinational case logic and generate summary', () {
      final converter = SV2ROHD();
      final outputFile = File('${tempDir.path}/alu.dart');

      final output = converter.convert(
        'fixtures/sv_samples/alu.sv',
        outputPath: outputFile.path,
      );

      expect(outputFile.existsSync(), isTrue);
      expect(output, contains('class Alu extends Module'));
      expect(output, contains('Logic stage'));
      expect(output, contains('Logic validPipe'));
      expect(output, contains('Case(op'));
      expect(output, contains('// for-generate pipe_stage over DEPTH'));
      expect(output, contains('overflow = 0;'));
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
      expect(output, contains('Logic counter'));
      expect(output, contains('Logic partial'));
      expect(output, contains('Logic resultReg'));
      expect(output, contains('If(~rstN'));
      expect(output, contains('product = resultReg;'));
    });
  });
}
