// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';

import 'package:sv2rohd/sv2rohd.dart';

void main() {
  group('diagnostic visibility', () {
    test('library surfaces the unconnected-port warning with its message', () {
      final converter = SV2ROHD();
      converter.convert('fixtures/sv_samples/unconnected_port.sv');

      expect(converter.diagnostics.hasWarnings, isTrue);
      expect(
        converter.diagnostics.warnings
            .map((d) => d.message)
            .any((m) => m.contains("input 'b'") && m.contains('unconnected')),
        isTrue,
      );
    });

    test('CLI prints the warning message, not just a bare count', () async {
      final result = await Process.run(
        'dart',
        [
          'run',
          p.join('bin', 'sv2rohd.dart'),
          '-i',
          'fixtures/sv_samples/unconnected_port.sv',
        ],
        workingDirectory: Directory.current.path,
      );

      expect(result.exitCode, 0);
      final stdout = result.stdout.toString();
      expect(stdout, contains("input 'b'"));
      expect(stdout, contains('unconnected'));
      expect(stdout, contains('Conversion finished with'));
    });
  });

  group('config wiring', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('sv2rohd-config-');
    });

    tearDown(() {
      if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
    });

    Future<ProcessResult> run(List<String> args) => Process.run(
          'dart',
          ['run', p.join('bin', 'sv2rohd.dart'), ...args],
          workingDirectory: Directory.current.path,
        );

    test('analysis.warnings_as_errors makes a warning fail the run', () async {
      final configFile = File(p.join(tempDir.path, 'werror.yaml'))
        ..writeAsStringSync('analysis:\n  warnings_as_errors: true\n');

      // async_reset.sv emits the GEN0026 async-reset warning.
      final result = await run([
        '-c',
        configFile.path,
        '-i',
        'fixtures/sv_samples/async_reset.sv',
      ]);

      expect(result.exitCode, 1);
      expect(result.stdout.toString(), contains('Treating warnings as errors'));
    });

    test('a warning does not fail the run without the config flag', () async {
      final result = await run(['-i', 'fixtures/sv_samples/async_reset.sv']);
      expect(result.exitCode, 0);
    });

    test('config output_dir is used as the output directory when -o is omitted',
        () async {
      final outDir = p.join(tempDir.path, 'gen');
      final configFile = File(p.join(tempDir.path, 'out.yaml'))
        ..writeAsStringSync('output:\n  output_dir: $outDir\n');

      final result = await run([
        '-c',
        configFile.path,
        '-i',
        'fixtures/sv_samples/adder.sv',
      ]);

      expect(result.exitCode, 0);
      expect(File(p.join(outDir, 'adder.dart')).existsSync(), isTrue);
    });
  });
}
