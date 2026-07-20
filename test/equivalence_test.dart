// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

// Proves SV<->ROHD functional equivalence: for each fixture, the original
// SystemVerilog and the ROHD that sv2rohd generates from it are simulated
// together in one Icarus Verilog "miter" testbench and their outputs are
// compared cycle by cycle (a VCD is dumped for inspection on failure).
//
// Requires Icarus Verilog. Run `tool/setup_iverilog.sh` (vendors it into
// .dart_tool/iverilog without root) or set IVERILOG_ROOT. When neither is
// available these tests are skipped, so the suite stays green everywhere.

import 'dart:io';

import 'package:test/test.dart';

import 'support/equivalence_checker.dart';

void main() {
  final tools = IverilogTools.find(projectRoot: Directory.current.path);

  group('SV<->ROHD functional equivalence', () {
    // Fixtures whose original SV and generated ROHD must simulate identically.
    // dynamic_index.sv is intentionally un-inlinable (a GEN0025 error), and
    // unconnected_port.sv deliberately floats an input, so both are excluded.
    const fixtures = <String>[
      'adder',
      'alu',
      'async_reset',
      'case_generate',
      'casez_wildcard',
      'fsm',
      'functions',
      'hierarchy',
      'keyword_names',
      'matrix_regs',
      'multiplier',
    ];

    tearDownAll(() {
      final dir = Directory('.dart_tool/sv2rohd_equiv');
      if (dir.existsSync()) dir.deleteSync(recursive: true);
    });

    for (final name in fixtures) {
      test('$name: original SV == generated ROHD', () {
        final checker = EquivalenceChecker(tools!);
        final result = checker.check('fixtures/sv_samples/$name.sv');
        expect(
          result.passed,
          isTrue,
          reason: 'equivalence failed with ${result.mismatches} mismatch(es); '
              'VCD at ${result.vcdPath}\n${result.log}',
        );
      });
    }
  },
      skip: tools == null
          ? 'Icarus Verilog not found; run tool/setup_iverilog.sh or set '
              'IVERILOG_ROOT'
          : false);
}
