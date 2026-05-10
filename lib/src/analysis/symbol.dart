// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

import '../common/common.dart';
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

/// Interface for types.
abstract class IrType {
  String get name;
  int? get width;
  bool get isSigned;
}

/// Basic logic type.
class LogicType implements IrType {
  final int? width;
  final bool isSigned;

  const LogicType({this.width, this.isSigned = false});

  @override
  String get name => width != null ? 'logic[$width]' : 'logic';

  @override
  int? get width => width;

  @override
  bool get isSigned => isSigned;
}

/// Integer type.
class IntegerType implements IrType {
  final int bits;

  const IntegerType({this.bits = 32});

  @override
  String get name => 'integer';

  @override
  int? get width => bits;
}

/// Real type.
class RealType implements IrType {
  const RealType();

  @override
  String get name => 'real';

  @override
  int? get width => null;
}

/// Placeholder for IR expressions.
abstract class IrExpression {
  IrExpression? resolve();
}
