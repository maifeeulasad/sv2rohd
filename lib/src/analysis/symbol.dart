// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

import '../common/common.dart';
import '../ir/ir.dart';
import 'scope.dart';

/// Represents a symbol in the symbol table.
class Symbol {
  final String name;
  final SymbolKind kind;
  final IrType? type;
  final SourceRange definitionLocation;
  final List<SourceRange> referenceLocations = [];
  final Scope definedInScope;
  final Map<String, dynamic> attributes = {};

  // For different symbol kinds:
  int? width; // for signals and ports
  IrExpression? defaultValue; // for parameters
  String? moduleType; // for modules
  PortDirection? portDirection; // for ports

  Symbol({
    required this.name,
    required this.kind,
    this.type,
    required this.definitionLocation,
    required this.definedInScope,
    this.width,
    this.defaultValue,
    this.moduleType,
    this.portDirection,
  });

  @override
  String toString() => 'Symbol($kind: $name)';
}

/// Kinds of symbols.
enum SymbolKind {
  module,
  port,
  signal,
  parameter,
  localparam,
  function,
  task,
  generateBlock,
  label,
  type,
  genvar,
}

/// Port direction for port symbols.
enum PortDirection {
  input,
  output,
  inout,
}

/// Error result from symbol resolution.
class SymbolResolutionError {
  final String name;
  final SourceRange location;
  final String message;

  const SymbolResolutionError({
    required this.name,
    required this.location,
    required this.message,
  });
}

/// Warning from semantic analysis.
class AnalysisWarning {
  final String message;
  final SourceRange location;
  final String code;

  const AnalysisWarning({
    required this.message,
    required this.location,
    required this.code,
  });
}

/// Error from semantic analysis.
class AnalysisError {
  final String message;
  final SourceRange location;
  final String code;

  const AnalysisError({
    required this.message,
    required this.location,
    required this.code,
  });
}

/// Result of analysis.
class AnalysisResult {
  final List<Symbol> allSymbols;
  final List<AnalysisError> errors;
  final List<AnalysisWarning> warnings;
  final Map<String, IrExpression> evaluatedParameters;

  AnalysisResult({
    List<Symbol>? allSymbols,
    List<AnalysisError>? errors,
    List<AnalysisWarning>? warnings,
    Map<String, IrExpression>? evaluatedParameters,
  })  : allSymbols = allSymbols ?? [],
        errors = errors ?? [],
        warnings = warnings ?? [],
        evaluatedParameters = evaluatedParameters ?? {};

  bool get hasErrors => errors.isNotEmpty;
  bool get hasWarnings => warnings.isNotEmpty;
}
