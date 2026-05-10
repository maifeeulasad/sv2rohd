// Copyright (C) 2026
// SPDX-License-Identifier: BSD-3-Clause

import 'diagnostic.dart';

/// Collects and manages diagnostic messages during processing.
class DiagnosticCollector {
  final List<Diagnostic> _diagnostics = [];

  /// All collected diagnostics.
  List<Diagnostic> get diagnostics => List.unmodifiable(_diagnostics);

  /// Adds a diagnostic to the collector.
  void add(Diagnostic diagnostic) {
    _diagnostics.add(diagnostic);
  }

  /// Adds an info diagnostic.
  void info(String message, {String? code, String? hint}) {
    _diagnostics.add(Diagnostic.info(message, code: code, hint: hint));
  }

  /// Adds a warning diagnostic.
  void warning(String message, {String? code, String? hint}) {
    _diagnostics.add(Diagnostic.warning(message, code: code, hint: hint));
  }

  /// Adds an error diagnostic.
  void error(String message, {String? code, String? hint}) {
    _diagnostics.add(Diagnostic.error(message, code: code, hint: hint));
  }

  /// Returns true if there are any errors.
  bool get hasErrors => _diagnostics.any((d) => d.isError);

  /// Returns true if there are any warnings.
  bool get hasWarnings => _diagnostics.any((d) => d.isWarning);

  /// Returns all error diagnostics.
  List<Diagnostic> get errors =>
      _diagnostics.where((d) => d.isError).toList();

  /// Returns all warning diagnostics.
  List<Diagnostic> get warnings =>
      _diagnostics.where((d) => d.isWarning).toList();

  /// Returns all info diagnostics.
  List<Diagnostic> get infos =>
      _diagnostics.where((d) => d.isInfo).toList();

  /// Clears all diagnostics.
  void clear() {
    _diagnostics.clear();
  }

  /// Returns a summary of diagnostic counts.
  DiagnosticSummary get summary => DiagnosticSummary(
        errors: errors.length,
        warnings: warnings.length,
        infos: infos.length,
      );
}

/// Summary of diagnostic counts.
class DiagnosticSummary {
  final int errors;
  final int warnings;
  final int infos;

  const DiagnosticSummary({
    required this.errors,
    required this.warnings,
    required this.infos,
  });

  int get total => errors + warnings + infos;

  bool get hasIssues => errors > 0 || warnings > 0;

  bool get hasErrors => errors > 0;

  @override
  String toString() =>
      '$errors error${errors == 1 ? '' : 's'}, '
      '$warnings warning${warnings == 1 ? '' : 's'}, '
      '$infos info message${infos == 1 ? '' : 's'}';
}