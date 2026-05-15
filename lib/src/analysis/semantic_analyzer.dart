// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

import '../common/common.dart';
import 'symbol.dart';
import 'scope.dart';
import 'type_analyzer.dart';
import '../ir/ir.dart';

/// Semantic analyzer for SystemVerilog.
class SemanticAnalyzer {
  final DiagnosticCollector diagnostics;
  final SymbolTable symbolTable;
  final List<AnalysisError> errors = [];
  final List<AnalysisWarning> warnings = [];

  SemanticAnalyzer({
    required this.diagnostics,
    SymbolTable? symbolTable,
  }) : symbolTable = symbolTable ?? SymbolTable();

  /// Analyzes a module declaration.
  AnalysisResult analyzeModule(ModuleDeclaration module) {
    // Enter module scope
    symbolTable.pushScope(module.name, ScopeKind.module);

    // Define module symbol
    final moduleSymbol = Symbol(
      name: module.name,
      kind: SymbolKind.module,
      definitionLocation: SourceRange.point(module.location),
      definedInScope: symbolTable.currentScope!,
    );
    symbolTable.define(module.name, moduleSymbol);

    // Analyze ports
    for (final port in module.ports) {
      _analyzePort(port);
    }

    // Analyze parameters
    for (final param in module.parameters) {
      _analyzeParameter(param);
    }

    // Analyze items
    for (final item in module.items) {
      _analyzeItem(item);
    }

    // Exit module scope
    symbolTable.popScope();

    return AnalysisResult(
      allSymbols: symbolTable.getAllSymbols(),
      errors: errors,
      warnings: warnings,
    );
  }

  void _analyzePort(PortDeclaration port) {
    _reportDuplicateDefinition(port.name, port.location, 'port');
    final portSymbol = Symbol(
      name: port.name,
      kind: SymbolKind.port,
      definitionLocation: SourceRange.point(port.location),
      definedInScope: symbolTable.currentScope!,
      portDirection: _convertPortDirection(port.direction),
      width: _getWidth(port.width),
    );
    symbolTable.define(port.name, portSymbol);
  }

  void _analyzeParameter(ParameterDeclaration param) {
    _reportDuplicateDefinition(param.name, param.location, 'parameter');
    final paramSymbol = Symbol(
      name: param.name,
      kind: SymbolKind.parameter,
      definitionLocation: SourceRange.point(param.location),
      definedInScope: symbolTable.currentScope!,
      defaultValue: param.defaultValue,
    );
    symbolTable.define(param.name, paramSymbol);
  }

  void _analyzeItem(IrNode item) {
    if (item is SignalDeclaration) {
      _analyzeSignal(item);
    } else if (item is AlwaysBlock) {
      _analyzeAlwaysBlock(item);
    } else if (item is ContinuousAssignment) {
      _analyzeContinuousAssignment(item);
    } else if (item is ModuleInstantiation) {
      _analyzeModuleInstantiation(item);
    } else if (item is FunctionDeclaration) {
      _analyzeFunction(item);
    } else if (item is TaskDeclaration) {
      _analyzeTask(item);
    }
  }

  void _analyzeSignal(SignalDeclaration signal) {
    _reportDuplicateDefinition(signal.name, signal.location, 'signal');
    final signalSymbol = Symbol(
      name: signal.name,
      kind: SymbolKind.signal,
      definitionLocation: SourceRange.point(signal.location),
      definedInScope: symbolTable.currentScope!,
      width: _getWidth(signal.width),
    );
    symbolTable.define(signal.name, signalSymbol);
  }

  void _analyzeAlwaysBlock(AlwaysBlock block) {
    // Enter procedural scope
    symbolTable.pushScope('always', ScopeKind.procedural);

    // Analyze statements
    _analyzeStatement(block.body);

    // Exit scope
    symbolTable.popScope();
  }

  void _analyzeStatement(IrStatement stmt) {
    if (stmt is AssignmentStatement) {
      _analyzeAssignment(stmt);
    } else if (stmt is IfStatement) {
      _analyzeIfStatement(stmt);
    } else if (stmt is CaseStatement) {
      _analyzeCaseStatement(stmt);
    } else if (stmt is ForLoopStatement) {
      _analyzeForLoop(stmt);
    } else if (stmt is WhileLoopStatement) {
      _analyzeWhileLoop(stmt);
    } else if (stmt is SequentialBlock) {
      _analyzeSequentialBlock(stmt);
    }
  }

  void _analyzeAssignment(AssignmentStatement assign) {
    // Validate target is assignable
    final targetName = _getIdentifierName(assign.target);
    if (targetName != null) {
      final symbols = symbolTable.lookupRecursive(targetName);
      if (symbols.isEmpty) {
        errors.add(AnalysisError(
          message: 'Undefined symbol: $targetName',
          location: assign.location.toRange(),
          code: 'SEM001',
        ));
      } else {
        _validateAssignmentCompatibility(
            assign.target, assign.value, assign.location);
      }
    }

    // Analyze value expression
    _analyzeExpression(assign.value);
  }

  void _analyzeIfStatement(IfStatement stmt) {
    _analyzeExpression(stmt.condition);
    _analyzeStatement(stmt.thenBranch);
    if (stmt.elseBranch != null) {
      _analyzeStatement(stmt.elseBranch!);
    }
  }

  void _analyzeCaseStatement(CaseStatement stmt) {
    _analyzeExpression(stmt.expression);
    for (final item in stmt.items) {
      if (item.statement != null) {
        _analyzeStatement(item.statement!);
      }
    }
  }

  void _analyzeForLoop(ForLoopStatement stmt) {
    if (stmt.initialization != null) {
      _analyzeStatement(stmt.initialization!);
    }
    if (stmt.condition != null) {
      _analyzeExpression(stmt.condition!);
    }
    if (stmt.step != null) {
      _analyzeStatement(stmt.step!);
    }
    _analyzeStatement(stmt.body);
  }

  void _analyzeWhileLoop(WhileLoopStatement stmt) {
    _analyzeExpression(stmt.condition);
    _analyzeStatement(stmt.body);
  }

  void _analyzeSequentialBlock(SequentialBlock stmt) {
    symbolTable.pushScope(stmt.label ?? 'block', ScopeKind.procedural);
    for (final s in stmt.statements) {
      _analyzeStatement(s);
    }
    symbolTable.popScope();
  }

  void _analyzeContinuousAssignment(ContinuousAssignment assign) {
    final targetName = _getIdentifierName(assign.target);
    if (targetName != null) {
      final symbols = symbolTable.lookupRecursive(targetName);
      if (symbols.isEmpty) {
        warnings.add(AnalysisWarning(
          message: 'Assigning to undefined symbol: $targetName',
          location: assign.location.toRange(),
          code: 'SEM002',
        ));
      } else {
        _validateAssignmentCompatibility(
            assign.target, assign.value, assign.location,
            warningCode: 'SEM004');
      }
    }
    _analyzeExpression(assign.value);
  }

  void _analyzeModuleInstantiation(ModuleInstantiation inst) {
    // Verify module exists
    final moduleSymbols = symbolTable.lookupRecursive(inst.moduleName);
    if (moduleSymbols.isEmpty) {
      errors.add(AnalysisError(
        message: 'Undefined module: ${inst.moduleName}',
        location: inst.location.toRange(),
        code: 'SEM003',
      ));
    }

    // Analyze port connections
    for (final conn in inst.portConnections) {
      if (conn.value != null) {
        _analyzeExpression(conn.value!);
      }
    }
  }

  void _analyzeFunction(FunctionDeclaration func) {
    _reportDuplicateDefinition(func.name, func.location, 'function');
    symbolTable.pushScope(func.name, ScopeKind.function);

    for (final port in func.ports) {
      final portSymbol = Symbol(
        name: port.name,
        kind: SymbolKind.port,
        definitionLocation: SourceRange.point(port.location),
        definedInScope: symbolTable.currentScope!,
        portDirection: port.direction,
      );
      symbolTable.define(port.name, portSymbol);
    }

    for (final item in func.items) {
      if (item is SignalDeclaration) {
        _analyzeSignal(item);
      } else if (item is IrStatement) {
        _analyzeStatement(item);
      }
    }

    symbolTable.popScope();
  }

  void _analyzeTask(TaskDeclaration task) {
    _reportDuplicateDefinition(task.name, task.location, 'task');
    symbolTable.pushScope(task.name, ScopeKind.task);

    for (final port in task.ports) {
      final portSymbol = Symbol(
        name: port.name,
        kind: SymbolKind.port,
        definitionLocation: SourceRange.point(port.location),
        definedInScope: symbolTable.currentScope!,
        portDirection: port.direction,
      );
      symbolTable.define(port.name, portSymbol);
    }

    for (final item in task.items) {
      if (item is SignalDeclaration) {
        _analyzeSignal(item);
      } else if (item is IrStatement) {
        _analyzeStatement(item);
      }
    }

    symbolTable.popScope();
  }

  void _analyzeExpression(IrExpression expr) {
    if (expr is LiteralExpression) {
      return;
    } else if (expr is IdentifierExpression) {
      final symbols = symbolTable.lookupRecursive(expr.identifier);
      if (symbols.isEmpty) {
        errors.add(AnalysisError(
          message: 'Undefined symbol: ${expr.identifier}',
          location: expr.location.toRange(),
          code: 'SEM001',
        ));
      }
    } else if (expr is BinaryExpression) {
      _analyzeExpression(expr.left);
      _analyzeExpression(expr.right);
    } else if (expr is UnaryExpression) {
      _analyzeExpression(expr.operand);
    } else if (expr is ConditionalExpression) {
      _analyzeExpression(expr.condition);
      _analyzeExpression(expr.trueExpr);
      _analyzeExpression(expr.falseExpr);
    } else if (expr is FunctionCallExpression) {
      for (final arg in expr.arguments) {
        _analyzeExpression(arg);
      }
      final symbols = symbolTable.lookupRecursive(expr.functionName);
      if (symbols.isEmpty && !expr.functionName.startsWith(r'$')) {
        warnings.add(AnalysisWarning(
          message: 'Undefined function: ${expr.functionName}',
          location: expr.location.toRange(),
          code: 'SEM005',
        ));
      }
    } else if (expr is ConcatenationExpression) {
      for (final subExpr in expr.expressions) {
        _analyzeExpression(subExpr);
      }
    } else if (expr is PartSelectExpression) {
      _analyzeExpression(expr.base);
      _analyzeExpression(expr.msb);
      _analyzeExpression(expr.lsb);
    } else {
      warnings.add(AnalysisWarning(
        message: 'Unhandled expression type: ${expr.runtimeType}',
        location: expr.location.toRange(),
        code: 'SEM099',
      ));
    }
  }

  void _validateAssignmentCompatibility(
    IrExpression target,
    IrExpression value,
    SourceLocation location, {
    String warningCode = 'SEM006',
  }) {
    final typeAnalyzer = TypeAnalyzer(
      diagnostics: diagnostics,
      symbolTypes: _buildTypeMap(),
    );
    if (!typeAnalyzer.checkAssignment(target, value)) {
      warnings.add(AnalysisWarning(
        message: 'Potential assignment width mismatch',
        location: location.toRange(),
        code: warningCode,
      ));
    }
  }

  Map<String, TypeInfo> _buildTypeMap() {
    final types = <String, TypeInfo>{};
    for (final symbol in symbolTable.getAllSymbols()) {
      if (symbol.width != null) {
        final type = symbol.kind == SymbolKind.port &&
                symbol.portDirection == PortDirection.inout
            ? TypeInfo.logic(symbol.width!)
            : TypeInfo.logic(symbol.width!);
        types[symbol.name] = type;
      } else if (symbol.kind == SymbolKind.parameter &&
          symbol.defaultValue is LiteralExpression) {
        final literal = symbol.defaultValue as LiteralExpression;
        if (literal.value is int) {
          types[symbol.name] = TypeInfo.logic(
              (literal.value as int).abs().bitLength == 0
                  ? 1
                  : (literal.value as int).abs().bitLength);
        }
      }
    }
    return types;
  }

  void _reportDuplicateDefinition(
      String name, SourceLocation location, String kind) {
    final existing = symbolTable.currentScope?.lookup(name);
    if (existing != null && existing.isNotEmpty) {
      errors.add(AnalysisError(
        message: 'Duplicate $kind declaration: $name',
        location: location.toRange(),
        code: 'SEM004',
      ));
    }
  }

  String? _getIdentifierName(IrExpression expr) {
    if (expr is IdentifierExpression) {
      return expr.identifier;
    }
    return null;
  }

  int? _getWidth(VectorWidth? width) {
    if (width == null || width.msb == null || width.lsb == null) {
      return null;
    }
    if (width.msb is LiteralExpression && width.lsb is LiteralExpression) {
      final msb = (width.msb as LiteralExpression).value as int;
      final lsb = (width.lsb as LiteralExpression).value as int;
      return (msb - lsb + 1).abs();
    }
    return null;
  }

  PortDirection _convertPortDirection(PortDirection dir) {
    return dir;
  }
}

extension on SourceLocation {
  SourceRange toRange() => SourceRange(start: this, end: this);
}
