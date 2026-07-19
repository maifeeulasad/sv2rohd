// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

// Parts of this implementation were generated with LLM assistance and
// reviewed by the maintainer.

import '../common/common.dart';
import '../frontend/frontend.dart';
import '../codegen/naming_strategy.dart';
import '../codegen/expression_generator.dart';
import '../codegen/statement_generator.dart';
import '../codegen/generate_block_generator.dart';
import '../codegen/signal_generator.dart';
import 'ir_node.dart';
import 'expression_ir.dart';
import 'statement_ir.dart';
import 'module_ir.dart';
import 'ir_visitor.dart';

/// Builds IR from parsed SystemVerilog source.
///
/// Parsing is performed by [SvParser], a hand-written recursive-descent
/// parser over the preprocessed source text.
class IrBuilder {
  final DiagnosticCollector diagnostics;
  final NamingStrategy namingStrategy;

  IrBuilder({
    required this.diagnostics,
    NamingStrategy? namingStrategy,
  }) : namingStrategy = namingStrategy ?? NamingStrategy();

  /// Converts parsed source to IR, returning the first module found.
  ModuleDeclaration buildModule(ParsedModule parsed) {
    final modules = buildModules(parsed);
    if (modules.isEmpty) {
      diagnostics.error('no module declaration found', code: 'IR0001');
      return ModuleDeclaration(
        location: parsed.sourceText.getLocation(0),
        name: 'unnamed_module',
      );
    }
    return modules.first;
  }

  /// Converts parsed source to IR, returning every module in the file.
  List<ModuleDeclaration> buildModules(ParsedModule parsed) {
    final parser = SvParser(
      parsed.sourceText.text,
      diagnostics: diagnostics,
      sourceName: parsed.sourceText.sourceName,
    );
    return parser.parseCompilationUnit();
  }
}

/// Context for building IR with symbol table.
class IrBuilderContext {
  final Map<String, IrDeclaration> symbols = {};
  final Map<String, ModuleDeclaration> modules = {};
  final List<String> scope = [];

  /// Adds a symbol to the current scope.
  void addSymbol(String name, IrDeclaration declaration) {
    symbols[name] = declaration;
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

/// Translates IR to ROHD module source using the visitor interface.
///
/// Prefer [RohdGenerator] for full-fidelity output; this visitor remains for
/// programmatic traversal use cases.
class RohdTranslator extends DefaultIrVisitor<String> {
  final NamingStrategy namingStrategy;
  final ExpressionGenerator _expressionGenerator;
  final StatementGenerator _statementGenerator;
  final GenerateBlockGenerator _generateBlockGenerator;

  RohdTranslator({NamingStrategy? namingStrategy})
      : namingStrategy = namingStrategy ?? NamingStrategy(),
        _expressionGenerator = ExpressionGenerator(
            namingStrategy: namingStrategy ?? NamingStrategy()),
        _statementGenerator = StatementGenerator(
          exprGen: ExpressionGenerator(
              namingStrategy: namingStrategy ?? NamingStrategy()),
          namingStrategy: namingStrategy ?? NamingStrategy(),
        ),
        _generateBlockGenerator = GenerateBlockGenerator(
          exprGen: ExpressionGenerator(
              namingStrategy: namingStrategy ?? NamingStrategy()),
          signalGen: SignalGenerator(
              namingStrategy: namingStrategy ?? NamingStrategy()),
          namingStrategy: namingStrategy ?? NamingStrategy(),
        );

  final StringBuffer _buffer = StringBuffer();
  int _indentLevel = 0;

  String get output => _buffer.toString();

  void _write(String text) {
    _buffer.write(text);
  }

  void _writeLine([String text = '']) {
    _buffer.writeln('${'  ' * _indentLevel}$text');
  }

  void _indent() {
    _indentLevel++;
  }

  void _dedent() {
    _indentLevel--;
  }

  @override
  String visitModule(ModuleDeclaration node) {
    final className = namingStrategy.toClassName(node.name);

    _writeLine('class $className extends Module {');
    _indent();

    _write('  $className(');
    final portParams = <String>[];
    for (final port in node.ports) {
      final portName = namingStrategy.toCamelCase(port.name);
      portParams.add('Logic $portName');
    }
    _write(portParams.join(', '));
    _writeLine(') : super();');
    _writeLine();

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
    final width = _signalWidth(node.width);
    if (width == null || width == 1) {
      _writeLine('Logic $signalName;');
    } else {
      _writeLine(
          'Logic $signalName = Logic(name: \'${node.name}\', width: $width);');
    }
    return '';
  }

  int? _signalWidth(VectorWidth? width) {
    if (width == null) return null;
    if (width.msb is LiteralExpression && width.lsb is LiteralExpression) {
      final msb = (width.msb as LiteralExpression).value as int;
      final lsb = (width.lsb as LiteralExpression).value as int;
      return (msb - lsb).abs() + 1;
    }
    return null;
  }

  @override
  String visitAssignment(AssignmentStatement node) {
    final target = _expressionGenerator.generate(node.target);
    final value = _expressionGenerator.generate(node.value);
    _writeLine('  $target = $value;');
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
    _statementGenerator.generate(_buffer, node);
    return '';
  }

  @override
  String visitCaseStatement(CaseStatement node) {
    _statementGenerator.generate(_buffer, node);
    return '';
  }

  @override
  String visitForLoop(ForLoopStatement node) {
    _statementGenerator.generate(_buffer, node);
    return '';
  }

  @override
  String visitWhileLoop(WhileLoopStatement node) {
    _statementGenerator.generate(_buffer, node);
    return '';
  }

  @override
  String visitStatement(IrStatement node) {
    _statementGenerator.generate(_buffer, node);
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
        args.add('$portName: ${_expressionGenerator.generate(conn.value!)}');
      }
    }
    _write(args.join(', '));
    _writeLine(');');

    return '';
  }

  @override
  String visitGenerateBlock(GenerateBlock node) {
    _generateBlockGenerator.generate(_buffer, node);
    return '';
  }

  @override
  String visitRawCode(RawCodeItem node) {
    for (final line in node.code.split('\n')) {
      if (line.trim().isEmpty) continue;
      _writeLine(line);
    }
    return '';
  }

  /// Resets the translator state.
  void reset() {
    _buffer.clear();
    _indentLevel = 0;
  }
}
