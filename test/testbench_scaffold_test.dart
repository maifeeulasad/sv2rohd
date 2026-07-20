// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';

import 'package:sv2rohd/sv2rohd.dart';

void main() {
  group('testbench scaffold', () {
    test('sequential module: clock, reset, and output prints', () {
      final source = File('fixtures/sv_samples/adder.sv').readAsStringSync();
      final tb =
          SV2ROHD().generateTestbenchSource(source, dutImport: 'adder.dart')!;

      expect(tb, contains("import 'package:rohd/rohd.dart';"));
      expect(tb, contains("import 'adder.dart';"));
      expect(tb, contains('SimpleClockGenerator(10).clk'));
      expect(tb, contains('final dut = Adder(clk, rstN, a, b, valid);'));
      expect(tb, contains('await dut.build();'));
      expect(tb, contains("WaveDumper(dut, outputPath: 'adder.vcd')"));
      expect(tb, contains('unawaited(Simulator.run())'));
      // Active-low reset is asserted with 0 and released with 1.
      expect(tb, contains('rstN.inject(0)'));
      expect(tb, contains('rstN.inject(1)'));
      expect(tb, contains(r"print('sum = ${dut.sum.value.toInt()}')"));
      expect(tb, contains('await Simulator.endSimulation()'));
    });

    test('combinational module: no clock, settles via a short run', () {
      final source =
          File('fixtures/sv_samples/functions.sv').readAsStringSync();
      final tb = SV2ROHD()
          .generateTestbenchSource(source, dutImport: 'functions.dart')!;

      expect(tb, isNot(contains('SimpleClockGenerator')));
      expect(tb, contains('final dut = AluFn(a, b, sel);'));
      expect(tb, contains('Simulator.setMaxSimTime(10)'));
      expect(tb, contains('await Simulator.run()'));
      expect(tb, contains(r"print('max_val = ${dut.maxVal.value.toInt()}')"));
    });

    // Generate a DUT + its scaffold and actually build/run it under ROHD.
    for (final fixture in const ['adder', 'functions']) {
      test('$fixture scaffold builds and runs', () async {
        final runDir = Directory(p.join(
          Directory.current.path,
          '.dart_tool',
          'sv2rohd_tb',
          '${fixture}_${DateTime.now().microsecondsSinceEpoch}',
        ))
          ..createSync(recursive: true);
        addTearDown(() {
          if (runDir.existsSync()) runDir.deleteSync(recursive: true);
          // WaveDumper writes the VCD into the current directory.
          for (final name in const ['adder.vcd', 'alu_fn.vcd']) {
            final vcd = File(name);
            if (vcd.existsSync()) vcd.deleteSync();
          }
        });

        final dutPath = p.join(runDir.path, '$fixture.dart');
        SV2ROHD().convert(
          'fixtures/sv_samples/$fixture.sv',
          outputPath: dutPath,
          generateTestbench: true,
        );
        final tbPath = p.join(runDir.path, '${fixture}_test.dart');
        expect(File(tbPath).existsSync(), isTrue);

        final result = await Process.run(
          'dart',
          ['run', p.relative(tbPath, from: Directory.current.path)],
          workingDirectory: Directory.current.path,
        );
        expect(result.exitCode, 0, reason: result.stderr.toString());
        // The scaffold prints each output; with all-zero stimulus they read 0.
        expect(result.stdout.toString(), contains('= 0'));
      });
    }
  });
}
