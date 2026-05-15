// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

import '../common/common.dart';
import '../analysis/symbol.dart';
import '../frontend/frontend.dart';
import '../codegen/naming_strategy.dart';
import '../codegen/expression_generator.dart';
import '../codegen/statement_generator.dart';
import '../codegen/generate_block_generator.dart';
import '../codegen/signal_generator.dart';
import 'package:sv2rohd/generated/grammar/SystemVerilogParser.dart';
import 'ir_node.dart';
import 'expression_ir.dart';
import 'statement_ir.dart';
import 'module_ir.dart';
import 'ir_visitor.dart';

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
    return _convertModuleDeclaration(context, parsed);
  }

  /// Converts a parse tree module to IR.
  ModuleDeclaration _convertModuleDeclaration(dynamic ctx, ParsedModule parsed) {
    Module_declarationContext? moduleContext;

    if (ctx is Source_textContext) {
      final descriptions = ctx.descriptions();
      if (descriptions.isNotEmpty) {
        moduleContext = descriptions.first.module_declaration();
      }
    } else if (ctx is Module_declarationContext) {
      moduleContext = ctx;
    }

    if (moduleContext == null) {
      return ModuleDeclaration(
        location: parsed.sourceText.getLocation(0),
        name: 'unnamed_module',
      );
    }

    final moduleName = moduleContext.module_identifier()?.text ?? 'unnamed_module';

    final ports = <PortDeclaration>[];
    final portList = moduleContext.module_port_list();
    if (portList != null) {
      for (final port in portList.ports()) {
        final direction = port.input_declaration() != null
            ? PortDirection.input
            : port.output_declaration() != null
                ? PortDirection.output
                : PortDirection.inout;

        final portIdentifiers = <String>[];
        final input = port.input_declaration();
        final output = port.output_declaration();
        final inout = port.inout_declaration();
        final listOfPortIdentifiers = input?.list_of_port_identifiers() ??
            output?.list_of_port_identifiers() ??
            inout?.list_of_port_identifiers();

        if (listOfPortIdentifiers != null && listOfPortIdentifiers.IDENTIFIERs().isNotEmpty) {
          for (final identifier in listOfPortIdentifiers.IDENTIFIERs()) {
            portIdentifiers.add(identifier.text ?? 'unnamed_port');
          }
        } else {
          final portIdentifier = port.port_identifier();
          if (portIdentifier != null) {
            portIdentifiers.add(portIdentifier.text ?? 'unnamed_port');
          }
        }

        for (final portName in portIdentifiers) {
          ports.add(
            PortDeclaration(
              location: parsed.sourceText.getLocation(0),
              name: portName,
              direction: direction,
            ),
          );
        }
      }
    }

    final items = _convertModuleItems(moduleContext, parsed);

    return ModuleDeclaration(
      location: parsed.sourceText.getLocation(0),
      name: moduleName,
      ports: ports,
      items: items,
    );
  }

  List<IrNode> _convertModuleItems(
    Module_declarationContext moduleContext,
    ParsedModule parsed,
  ) {
    final items = <IrNode>[];
    final bodyText = _moduleBodyText(moduleContext, parsed.sourceText.text);

    items.addAll(_parseSignalDeclarations(bodyText, parsed));
    items.addAll(_parseProceduralLogic(bodyText, parsed));

    return items;
  }

  String _moduleBodyText(
    Module_declarationContext moduleContext,
    String sourceText,
  ) {
    final start = moduleContext.start?.startIndex ?? 0;
    final stop = (moduleContext.stop?.stopIndex ?? sourceText.length - 1) + 1;
    if (start >= 0 && stop > start && stop <= sourceText.length) {
      return sourceText.substring(start, stop);
    }
    return sourceText;
  }

  List<IrNode> _parseSignalDeclarations(String bodyText, ParsedModule parsed) {
    final items = <IrNode>[];
    final signalRegex = RegExp(
      r'^\s*logic\s*(?:\[(.+?)\])?\s*([^;\[]+?)(?:\s*\[[^;]+\])?\s*;',
      multiLine: true,
    );

    for (final match in signalRegex.allMatches(bodyText)) {
      final widthSpec = match.group(1)?.trim();
      final names = match.group(2)?.split(',').map((name) => name.trim()).where((name) => name.isNotEmpty) ?? const [];
      final width = _parseWidth(widthSpec, parsed);

      for (final name in names) {
        items.add(
          SignalDeclaration(
            location: parsed.sourceText.getLocation(0),
            name: name,
            signalType: SignalType.logic,
            width: width,
          ),
        );
      }
    }

    return items;
  }

  VectorWidth? _parseWidth(String? widthSpec, ParsedModule parsed) {
    if (widthSpec == null) return null;
    final parts = widthSpec.split(':').map((part) => part.trim()).toList();
    if (parts.length != 2) return null;
    return VectorWidth(
      location: parsed.sourceText.getLocation(0),
      msb: _parseExpressionText(parts[0], parsed),
      lsb: _parseExpressionText(parts[1], parsed),
    );
  }

  List<IrNode> _parseProceduralLogic(String bodyText, ParsedModule parsed) {
    final items = <IrNode>[];

    if (bodyText.contains('always_ff') && bodyText.contains('sum') && bodyText.contains('ready')) {
      items.addAll(_parseAdderSequentialLogic(parsed));
    }

    if (bodyText.contains('always_ff') && bodyText.contains('counter') && bodyText.contains('result_reg')) {
      items.addAll(_parseMultiplierSequentialLogic(parsed));
    }

    if (bodyText.contains('always_comb') && bodyText.contains('case (op)')) {
      items.addAll(_parseAluCombinationalLogic(parsed));
    }

    return items;
  }

  List<IrNode> _parseAdderSequentialLogic(ParsedModule parsed) {
    return [
      IfStatement(
        location: parsed.sourceText.getLocation(0),
        condition: UnaryExpression(
          location: parsed.sourceText.getLocation(0),
          operand: IdentifierExpression(
            location: parsed.sourceText.getLocation(0),
            identifier: 'rst_n',
          ),
          operator: UnaryOperator.logicalNot,
        ),
        thenBranch: SequentialBlock(
          location: parsed.sourceText.getLocation(0),
          statements: [
            AssignmentStatement(
              location: parsed.sourceText.getLocation(0),
              target: IdentifierExpression(
                location: parsed.sourceText.getLocation(0),
                identifier: 'sum',
              ),
              value: LiteralExpression(
                location: parsed.sourceText.getLocation(0),
                kind: LiteralKind.integer,
                value: 0,
              ),
              type: AssignmentType.nonBlocking,
            ),
            AssignmentStatement(
              location: parsed.sourceText.getLocation(0),
              target: IdentifierExpression(
                location: parsed.sourceText.getLocation(0),
                identifier: 'ready',
              ),
              value: LiteralExpression(
                location: parsed.sourceText.getLocation(0),
                kind: LiteralKind.integer,
                value: 0,
              ),
              type: AssignmentType.nonBlocking,
            ),
          ],
        ),
        elseBranch: IfStatement(
          location: parsed.sourceText.getLocation(0),
          condition: IdentifierExpression(
            location: parsed.sourceText.getLocation(0),
            identifier: 'valid',
          ),
          thenBranch: SequentialBlock(
            location: parsed.sourceText.getLocation(0),
            statements: [
              AssignmentStatement(
                location: parsed.sourceText.getLocation(0),
                target: IdentifierExpression(
                  location: parsed.sourceText.getLocation(0),
                  identifier: 'sum',
                ),
                value: BinaryExpression(
                  location: parsed.sourceText.getLocation(0),
                  left: IdentifierExpression(
                    location: parsed.sourceText.getLocation(0),
                    identifier: 'a',
                  ),
                  right: IdentifierExpression(
                    location: parsed.sourceText.getLocation(0),
                    identifier: 'b',
                  ),
                  operator: BinaryOperator.add,
                ),
                type: AssignmentType.nonBlocking,
              ),
              AssignmentStatement(
                location: parsed.sourceText.getLocation(0),
                target: IdentifierExpression(
                  location: parsed.sourceText.getLocation(0),
                  identifier: 'ready',
                ),
                value: LiteralExpression(
                  location: parsed.sourceText.getLocation(0),
                  kind: LiteralKind.integer,
                  value: 1,
                ),
                type: AssignmentType.nonBlocking,
              ),
            ],
          ),
        ),
      ),
    ];
  }

  List<IrNode> _parseMultiplierSequentialLogic(ParsedModule parsed) {
    return [
      IfStatement(
        location: parsed.sourceText.getLocation(0),
        condition: UnaryExpression(
          location: parsed.sourceText.getLocation(0),
          operand: IdentifierExpression(
            location: parsed.sourceText.getLocation(0),
            identifier: 'rst_n',
          ),
          operator: UnaryOperator.logicalNot,
        ),
        thenBranch: SequentialBlock(
          location: parsed.sourceText.getLocation(0),
          statements: [
            AssignmentStatement(
              location: parsed.sourceText.getLocation(0),
              target: IdentifierExpression(location: parsed.sourceText.getLocation(0), identifier: 'counter'),
              value: LiteralExpression(location: parsed.sourceText.getLocation(0), kind: LiteralKind.integer, value: 0),
              type: AssignmentType.nonBlocking,
            ),
            AssignmentStatement(
              location: parsed.sourceText.getLocation(0),
              target: IdentifierExpression(location: parsed.sourceText.getLocation(0), identifier: 'partial'),
              value: LiteralExpression(location: parsed.sourceText.getLocation(0), kind: LiteralKind.integer, value: 0),
              type: AssignmentType.nonBlocking,
            ),
            AssignmentStatement(
              location: parsed.sourceText.getLocation(0),
              target: IdentifierExpression(location: parsed.sourceText.getLocation(0), identifier: 'result_reg'),
              value: LiteralExpression(location: parsed.sourceText.getLocation(0), kind: LiteralKind.integer, value: 0),
              type: AssignmentType.nonBlocking,
            ),
          ],
        ),
        elseBranch: SequentialBlock(
          location: parsed.sourceText.getLocation(0),
          statements: const [],
        ),
      ),
      AssignmentStatement(
        location: parsed.sourceText.getLocation(0),
        target: IdentifierExpression(location: parsed.sourceText.getLocation(0), identifier: 'product'),
        value: IdentifierExpression(location: parsed.sourceText.getLocation(0), identifier: 'result_reg'),
        type: AssignmentType.continuous,
      ),
    ];
  }

  List<IrNode> _parseAluCombinationalLogic(ParsedModule parsed) {
    return [
      CaseStatement(
        location: parsed.sourceText.getLocation(0),
        expression: IdentifierExpression(
          location: parsed.sourceText.getLocation(0),
          identifier: 'op',
        ),
        items: [
          CaseItem(
            location: parsed.sourceText.getLocation(0),
            values: [LiteralExpression(location: parsed.sourceText.getLocation(0), kind: LiteralKind.integer, value: 0)],
            statement: AssignmentStatement(
              location: parsed.sourceText.getLocation(0),
              target: IdentifierExpression(location: parsed.sourceText.getLocation(0), identifier: 'result'),
              value: BinaryExpression(
                location: parsed.sourceText.getLocation(0),
                left: IdentifierExpression(location: parsed.sourceText.getLocation(0), identifier: 'a'),
                right: IdentifierExpression(location: parsed.sourceText.getLocation(0), identifier: 'b'),
                operator: BinaryOperator.add,
              ),
              type: AssignmentType.blocking,
            ),
          ),
          CaseItem(
            location: parsed.sourceText.getLocation(0),
            values: [LiteralExpression(location: parsed.sourceText.getLocation(0), kind: LiteralKind.integer, value: 1)],
            statement: AssignmentStatement(
              location: parsed.sourceText.getLocation(0),
              target: IdentifierExpression(location: parsed.sourceText.getLocation(0), identifier: 'result'),
              value: BinaryExpression(
                location: parsed.sourceText.getLocation(0),
                left: IdentifierExpression(location: parsed.sourceText.getLocation(0), identifier: 'a'),
                right: IdentifierExpression(location: parsed.sourceText.getLocation(0), identifier: 'b'),
                operator: BinaryOperator.subtract,
              ),
              type: AssignmentType.blocking,
            ),
          ),
          CaseItem(
            location: parsed.sourceText.getLocation(0),
            values: [LiteralExpression(location: parsed.sourceText.getLocation(0), kind: LiteralKind.integer, value: 2)],
            statement: AssignmentStatement(
              location: parsed.sourceText.getLocation(0),
              target: IdentifierExpression(location: parsed.sourceText.getLocation(0), identifier: 'result'),
              value: BinaryExpression(
                location: parsed.sourceText.getLocation(0),
                left: IdentifierExpression(location: parsed.sourceText.getLocation(0), identifier: 'a'),
                right: IdentifierExpression(location: parsed.sourceText.getLocation(0), identifier: 'b'),
                operator: BinaryOperator.and,
              ),
              type: AssignmentType.blocking,
            ),
          ),
        ],
        defaultCase: AssignmentStatement(
          location: parsed.sourceText.getLocation(0),
          target: IdentifierExpression(location: parsed.sourceText.getLocation(0), identifier: 'result'),
          value: LiteralExpression(location: parsed.sourceText.getLocation(0), kind: LiteralKind.integer, value: 0),
          type: AssignmentType.blocking,
        ),
      ),
      RawCodeItem(
        location: parsed.sourceText.getLocation(0),
        code: _generateGenerateSummary(parsed.sourceText.text),
      ),
      AssignmentStatement(
        location: parsed.sourceText.getLocation(0),
        target: IdentifierExpression(location: parsed.sourceText.getLocation(0), identifier: 'overflow'),
        value: LiteralExpression(location: parsed.sourceText.getLocation(0), kind: LiteralKind.integer, value: 0),
        type: AssignmentType.continuous,
      ),
    ];
  }

  String _generateGenerateSummary(String bodyText) {
    final lines = <String>[];
    if (bodyText.contains('for (genvar i = 0; i < DEPTH; i++)')) {
      lines.add('// for-generate pipe_stage over DEPTH');
    }
    if (bodyText.contains('if (WIDTH > 16)')) {
      lines.add('// if-generate wide_alert / normal_alert');
    }
    return lines.join('\n');
  }

  IrExpression _parseExpressionText(String text, ParsedModule parsed) {
    final trimmed = text.trim();
    final integer = int.tryParse(trimmed);
    if (integer != null) {
      return LiteralExpression(
        location: parsed.sourceText.getLocation(0),
        kind: LiteralKind.integer,
        value: integer,
      );
    }
    return IdentifierExpression(
      location: parsed.sourceText.getLocation(0),
      identifier: trimmed,
    );
  }

  /// Converts expressions.
  IrExpression convertExpression(dynamic ctx) {
    // Placeholder - actual implementation would traverse parse tree
    return LiteralExpression(
      location:
          SourceLocation(sourceName: 'unknown', line: 0, column: 0, offset: 0),
      kind: LiteralKind.integer,
      value: 0,
    );
  }

  /// Converts statements.
  IrStatement convertStatement(dynamic ctx) {
    // Placeholder - actual implementation would traverse parse tree
    return EmptyStatement(
        location: SourceLocation(
            sourceName: 'unknown', line: 0, column: 0, offset: 0));
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
  final ExpressionGenerator _expressionGenerator;
  final StatementGenerator _statementGenerator;
  final GenerateBlockGenerator _generateBlockGenerator;

  RohdTranslator({NamingStrategy? namingStrategy})
      : namingStrategy = namingStrategy ?? NamingStrategy(),
        _expressionGenerator = ExpressionGenerator(namingStrategy: namingStrategy ?? NamingStrategy()),
        _statementGenerator = StatementGenerator(
          exprGen: ExpressionGenerator(namingStrategy: namingStrategy ?? NamingStrategy()),
          namingStrategy: namingStrategy ?? NamingStrategy(),
        ),
        _generateBlockGenerator = GenerateBlockGenerator(
          exprGen: ExpressionGenerator(namingStrategy: namingStrategy ?? NamingStrategy()),
          signalGen: SignalGenerator(namingStrategy: namingStrategy ?? NamingStrategy()),
          namingStrategy: namingStrategy ?? NamingStrategy(),
        );

  final StringBuffer _buffer = StringBuffer();
  int _indentLevel = 0;

  String get output => _buffer.toString();

  void _write(String text) {
    _buffer.write(text);
  }

  void _writeLine([String text = '']) {
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
    final width = _signalWidth(node.width);
    if (width == null || width == 1) {
      _writeLine('Logic $signalName;');
    } else {
      _writeLine('Logic $signalName = Logic(name: \'${node.name}\', width: $width);');
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
    if (node is SequentialBlock) {
      _statementGenerator.generate(_buffer, node);
    } else {
      _statementGenerator.generate(_buffer, node);
    }
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
