// Copyright (C) 2026
// SPDX-License-Identifier: BSD-3-Clause

/// Severity levels for diagnostic messages.
enum DiagnosticSeverity {
  /// Information message, does not affect conversion.
  info,

  /// Warning message, may indicate potential issues.
  warning,

  /// Error message, indicates conversion problems.
  error,
}

/// Represents a diagnostic message (error, warning, or info) with location and details.
class Diagnostic {
  final DiagnosticSeverity severity;
  final String message;
  final String? code;
  final String? hint;
  final String? documentationUrl;
  final List<String> seeAlso;

  const Diagnostic({
    required this.severity,
    required this.message,
    this.code,
    this.hint,
    this.documentationUrl,
    this.seeAlso = const [],
  });

  /// Creates a diagnostic from a source range.
  factory Diagnostic.fromRange({
    required String message,
    required DiagnosticSeverity severity,
    String? code,
    String? hint,
  }) {
    return Diagnostic(
      message: message,
      severity: severity,
      code: code,
      hint: hint,
    );
  }

  /// Creates an info diagnostic.
  factory Diagnostic.info(String message, {String? code, String? hint}) {
    return Diagnostic(
      message: message,
      severity: DiagnosticSeverity.info,
      code: code,
      hint: hint,
    );
  }

  /// Creates a warning diagnostic.
  factory Diagnostic.warning(String message, {String? code, String? hint}) {
    return Diagnostic(
      message: message,
      severity: DiagnosticSeverity.warning,
      code: code,
      hint: hint,
    );
  }

  /// Creates an error diagnostic.
  factory Diagnostic.error(String message, {String? code, String? hint}) {
    return Diagnostic(
      message: message,
      severity: DiagnosticSeverity.error,
      code: code,
      hint: hint,
    );
  }

  /// Returns a formatted string representation.
  String get formatted {
    final buffer = StringBuffer();

    if (code != null) {
      buffer.write('[$code] ');
    }

    buffer.write(message);

    if (hint != null) {
      buffer.write('\nSuggestion: $hint');
    }

    if (documentationUrl != null) {
      buffer.write('\nSee: $documentationUrl');
    }

    return buffer.toString();
  }

  /// Returns true if this is an error.
  bool get isError => severity == DiagnosticSeverity.error;

  /// Returns true if this is a warning.
  bool get isWarning => severity == DiagnosticSeverity.warning;

  /// Returns true if this is an info message.
  bool get isInfo => severity == DiagnosticSeverity.info;

  @override
  String toString() => '[${severity.name}] ${formatted}';
}