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
}
