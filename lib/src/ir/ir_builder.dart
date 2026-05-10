// Copyright (C) 2026
// SPDX-License-Identifier: BSD-3-Clause

import 'package:antlr4/antlr4.dart';
import '../common/common.dart';
import '../frontend/frontend.dart';
import 'ir_node.dart';
import 'expression_ir.dart';
import 'statement_ir.dart';
import 'module_ir.dart';
import 'ir_visitor.dart';
import 'ir_printer.dart';

/// Builds IR from the parse tree.
class IrBuilder {
  final DiagnosticCollector diagnostics;
  final NamingStrategy namingStrategy;

  IrBuilder({
    required this.diagnostics,
    NamingStrategy? namingStrategy,
  }) : namingStrategy = namingStrategy ?? NamingStrategy();

  /// Converts a parsed module to IR.
  ModuleDeclaration buildModule(ParsedModule parsed) {
    final context = parsed.compilationUnit;
    return _convertModuleDeclaration(context);
  }

  /// Converts a parse tree module to IR.
  ModuleDeclaration _convertModuleDeclaration(dynamic ctx) {
    // Implementation would traverse the parse tree
    // For now, create a placeholder
    return ModuleDeclaration(
      location: SourceLocation('unknown', 0, 0, 0),
      name: 'unnamed_module',
    );
  }

  /// Converts expressions.
  IrExpression convertExpression(dynamic ctx) {
    // Placeholder - actual implementation would traverse parse tree
    return LiteralExpression(
      location: SourceLocation('unknown', 0, 0, 0),
      kind: LiteralKind.integer,
      value: 0,
    );
  }

  /// Converts statements.
  IrStatement convertStatement(dynamic ctx) {
    // Placeholder - actual implementation would traverse parse tree
    return EmptyStatement(location: SourceLocation('unknown', 0, 0, 0));
  }
}

/// Context for building IR with symbol table.
class IrBuilderContext {
  final Map<String, IrDeclaration> symbols = {};
  final Map<String, ModuleDeclaration> modules = {};
  final List<String> scope = [];

  /// Adds a symbol to the current scope.
  void addSymbol(String name, IrDeclaration declaration) {
    final dartName = name; // Would use naming strategy here
    symbols[dartName] = declaration;
  }

  /// Looks up a symbol.
  IrDeclaration? lookupSymbol(String name) {
    return symbols[name];
  }

  /// Pushes a new scope.
  void pushScope() {
    scope.add('');
  }

  /// Pops the current scope.
  void popScope() {
    if (scope.isNotEmpty) {
      scope.removeLast();
    }
  }

  /// Returns the current scope path.
  String get currentScope {
    return scope.join('.');
  }
}

/// Translates IR to ROHD module.
class RohdTranslator extends DefaultIrVisitor<String> {
  final NamingStrategy namingStrategy;

  RohdTranslator({NamingStrategy? namingStrategy})
      : namingStrategy = namingStrategy ?? NamingStrategy();

  final StringBuffer _buffer = StringBuffer();
  int _indentLevel = 0;

  String get output => _buffer.toString();

  void _write(String text) {
    _buffer.write(text);
  }

  void _writeLine(String text) {
    _buffer.writeln(text);
  }

  void _indent() {
    _indentLevel++;
  }

  void _dedent() {
    _indentLevel--;
  }

  String _indentStr() {
    return '  ' * _indentLevel;
  }

  @override
  String visitModule(ModuleDeclaration node) {
    final className = namingStrategy.toClassName(node.name);

    _writeLine('class $className extends Module {');
    _indent();

    // Constructor with ports
    _write('  $className(');
    final portParams = <String>[];
    for (final port in node.ports) {
      final portName = namingStrategy.toCamelCase(port.name);
      portParams.add('Logic $portName');
    }
    _write(portParams.join(', '));
    _writeLine(') : super(() {');

    _indent();
    _writeLine('// Port assignments');
    for (final port in node.ports) {
      final portName = namingStrategy.toCamelCase(port.name);
      _writeLine("  definePort('$portName', $portName);");
    }
    _dedent();
    _writeLine('  });');
    _writeLine();

    // Body
    _indent();
    for (final item in node.items) {
      item.accept(this);
    }
    _dedent();

    _dedent();
    _writeLine('}');

    return '';
  }

  @override
  String visitSignal(SignalDeclaration node) {
    final signalName = namingStrategy.toCamelCase(node.name);
    final rohdType = _signalTypeToRohdType(node.signalType);

    _writeLine('Logic $signalName;');
    return '';
  }

  String _signalTypeToRohdType(SignalType type) {
    return 'Logic';
  }

  @override
  String visitAssignment(AssignmentStatement node) {
    _write('  ');
    node.target.accept(this);
    _write(' = ');
    node.value.accept(this);
    _writeLine(';');
    return '';
  }

  @override
  String visitIdentifier(IdentifierExpression node) {
    _write(namingStrategy.toCamelCase(node.identifier));
    return '';
  }

  @override
  String visitLiteral(LiteralExpression node) {
    _write(node.value.toString());
    return '';
  }

  @override
  String visitBinaryOp(BinaryExpression node) {
    _write('(');
    node.left.accept(this);
    _write(' ${_binaryOperatorToString(node.operator)} ');
    node.right.accept(this);
    _write(')');
    return '';
  }

  String _binaryOperatorToString(BinaryOperator op) {
    switch (op) {
      case BinaryOperator.add:
        return '+';
      case BinaryOperator.subtract:
        return '-';
      case BinaryOperator.multiply:
        return '*';
      case BinaryOperator.divide:
        return '/';
      case BinaryOperator.equal:
        return '==';
      case BinaryOperator.notEqual:
        return '!=';
      case BinaryOperator.lessThan:
        return '<';
      case BinaryOperator.greaterThan:
        return '>';
      case BinaryOperator.logicalAnd:
        return '&&';
      case BinaryOperator.logicalOr:
        return '||';
      default:
        return 'UNKNOWN';
    }
  }

  @override
  String visitIfStatement(IfStatement node) {
    _write('if (');
    node.condition.accept(this);
    _writeLine(') {');
    _indent();
    node.thenBranch.accept(this);
    _dedent();
    _write('}');
    if (node.elseBranch != null) {
      _writeLine(' else {');
      _indent();
      node.elseBranch!.accept(this);
      _dedent();
      _write('}');
    }
    _writeLine();
    return '';
  }

  @override
  String visitModuleInstantiation(ModuleInstantiation node) {
    final instanceName = namingStrategy.toCamelCase(node.instanceName);
    final className = namingStrategy.toClassName(node.moduleName);

    _write('  final $className $instanceName = $className(');
    final args = <String>[];
    for (final conn in node.portConnections) {
      final portName = namingStrategy.toCamelCase(conn.portName);
      if (conn.value != null) {
        args.add(portName);
      }
    }
    _write(args.join(', '));
    _writeLine(');');

    return '';
  }

  /// Resets the translator state.
  void reset() {
    _buffer.clear();
    _indentLevel = 0;
  }
}