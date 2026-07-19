// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

import 'package:test/test.dart';

import 'package:sv2rohd/sv2rohd.dart';

void main() {
  test('runtime-indexed array access is a hard error, not a silent warning',
      () {
    final converter = SV2ROHD();
    converter.convert('fixtures/sv_samples/dynamic_index.sv');

    expect(converter.hasErrors, isTrue);
    expect(
      converter.diagnostics.errors
          .map((d) => d.message)
          .any((m) => m.contains("array 'mem'") && m.contains('runtime')),
      isTrue,
    );
  });

  test('a clean fixture produces no diagnostics at all', () {
    // Regression test: Frontend.parseSource() used to also run the unused,
    // broken ANTLR-based lexer/parser purely for its side effect of adding
    // dozens of spurious PARS0001 warnings to the diagnostics collector.
    final converter = SV2ROHD();
    converter.convert('fixtures/sv_samples/adder.sv');

    expect(converter.diagnostics.diagnostics, isEmpty);
  });
}
