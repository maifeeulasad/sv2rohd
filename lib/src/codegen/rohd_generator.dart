// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

import '../analysis/symbol.dart';
import '../ir/ir.dart';
import 'expression_generator.dart';
import 'statement_generator.dart';
import 'naming_strategy.dart';

/// Options for code generation.
class GeneratorOptions {
  final bool preserveComments;
  final bool generateSourceMap;
  final NamingStrategy namingStrategy;
  final bool strictMode;

  const GeneratorOptions({
    this.preserveComments = true,
    this.generateSourceMap = false,
    NamingStrategy? namingStrategy,
    this.strictMode = false,
  }) : namingStrategy = namingStrategy ?? const NamingStrategy();
}

/// Main ROHD code generator.
class RohdGenerator {
  final GeneratorOptions options;
  final NamingStrategy namingStrategy;
  final ExpressionGenerator exprGen;
  final StatementGenerator stmtGen;
  final StringBuffer _buffer = StringBuffer();
  int _indentLevel = 0;

  RohdGenerator({
    GeneratorOptions? options,
  })  : options = options ?? const GeneratorOptions(),
        namingStrategy = options?.namingStrategy ?? const NamingStrategy(),
        exprGen = ExpressionGenerator(
          namingStrategy: options?.namingStrategy ?? const NamingStrategy(),
        ),
        stmtGen = StatementGenerator(
          exprGen: ExpressionGenerator(
            namingStrategy: options?.namingStrategy ?? const NamingStrategy(),
          ),
          namingStrategy: options?.namingStrategy ?? const NamingStrategy(),
        );

  /// Generate ROHD code from a module.
  String generate(ModuleDeclaration module) {
    _buffer.clear();
    _indentLevel = 0;

    _generateImports();
    _generateModule(module);

    return _buffer.toString();
  }

  void _generateImports() {
    _writeLine("import 'package:rohd/rohd.dart';");
    _writeLine();
  }

  void _generateModule(ModuleDeclaration module) {
    final className = namingStrategy.toClassName(module.name);
    final signalDecls = _collectSignals(module.items);

    _writeLine('class $className extends Module {');
    _indent();

    _generatePortFields(module.ports);
    _generateSignalFields(signalDecls, module.ports);

    if (module.ports.isNotEmpty || signalDecls.isNotEmpty) {
      _writeLine();
    }

    _generateConstructor(module, signalDecls);

    _dedent();
    _writeLine('}');
  }

  List<SignalDeclaration> _collectSignals(List<IrNode> items) {
    final signals = <SignalDeclaration>[];
    for (final item in items) {
      if (item is SignalDeclaration) {
        signals.add(item);
      }
    }
    return signals;
  }

  void _generatePortFields(List<PortDeclaration> ports) {
    for (final port in ports) {
      final portName = namingStrategy.toCamelCase(port.name);
      _writeLine('late final Logic $portName;');
    }
  }

  void _generateSignalFields(
    List<SignalDeclaration> signals,
    List<PortDeclaration> ports,
  ) {
    final reserved =
        ports.map((p) => namingStrategy.toCamelCase(p.name)).toSet();
    for (final signal in signals) {
      final name = namingStrategy.toCamelCase(signal.name);
      if (reserved.contains(name)) {
        continue;
      }
      _writeLine('late final Logic $name;');
    }
  }

  void _generateConstructor(
    ModuleDeclaration module,
    List<SignalDeclaration> signals,
  ) {
    final className = namingStrategy.toClassName(module.name);
    final paramStr = _constructorParams(module);

    _writeLine('$className($paramStr) : super(name: \'${module.name}\') {');
    _indent();

    if (module.ports.isNotEmpty) {
      _writeLine('// Ports');
      for (final port in module.ports) {
        _generatePortAssignment(port);
      }
    }

    if (signals.isNotEmpty) {
      if (module.ports.isNotEmpty) {
        _writeLine();
      }
      _writeLine('// Internal signals');
      _generateSignalAssignments(signals, module.ports);
    }

    _generateLogic(module);

    _dedent();
    _writeLine('}');
  }

  String _constructorParams(ModuleDeclaration module) {
    final params = <String>[];
    for (final port in module.ports) {
      if (port.direction == PortDirection.output) continue;
      final portName = namingStrategy.toCamelCase(port.name);
      params.add('Logic ${_portSourceParamName(portName)}');
    }

    if (module.parameters.isNotEmpty) {
      final namedParams = <String>[];
      for (final param in module.parameters) {
        final paramName = namingStrategy.toCamelCase(param.name);
        final defaultValue = param.defaultValue != null
            ? exprGen.generate(param.defaultValue!)
            : '0';
        namedParams.add('int $paramName = $defaultValue');
      }
      params.add('{${namedParams.join(', ')}}');
    }

    return params.join(', ');
  }

  void _generatePortAssignment(PortDeclaration port) {
    final portName = namingStrategy.toCamelCase(port.name);
    final width = _getWidth(port.width);
    final sourceName = _portSourceParamName(portName);

    switch (port.direction) {
      case PortDirection.input:
        _writeLine(
            "this.$portName = addInput('${port.name}', $sourceName, width: $width);");
        break;
      case PortDirection.output:
        _writeLine(
            "this.$portName = addOutput('${port.name}', width: $width);");
        break;
      case PortDirection.inout:
        _writeLine(
            "this.$portName = addInOut('${port.name}', $sourceName, width: $width);");
        break;
    }
  }

  String _portSourceParamName(String portName) => '${portName}Source';

  void _generateSignalAssignments(
    List<SignalDeclaration> signals,
    List<PortDeclaration> ports,
  ) {
    final reserved =
        ports.map((p) => namingStrategy.toCamelCase(p.name)).toSet();
    for (final signal in signals) {
      final name = namingStrategy.toCamelCase(signal.name);
      if (reserved.contains(name)) {
        continue;
      }
      final width = _getWidth(signal.width);
      _writeLine("$name = Logic(name: '${signal.name}', width: $width);");
      if (signal.initialValue != null) {
        _writeLine('// TODO: initial value');
      }
    }
  }

  void _generateLogic(ModuleDeclaration module) {
    final combinational = <IrStatement>[];
    final sequential = <IrStatement>[];
    final directItems = <IrNode>[];

    for (final item in module.items) {
      if (item is SignalDeclaration) {
        continue;
      }
      if (item is ContinuousAssignment ||
          item is ModuleInstantiation ||
          item is GenerateBlock ||
          item is RawCodeItem ||
          item is InitialBlock) {
        directItems.add(item);
        continue;
      }
      if (item is AlwaysBlock) {
        if (item.kind == BlockKind.alwaysFf) {
          sequential.add(item.body);
        } else if (item.kind == BlockKind.alwaysComb) {
          combinational.add(item.body);
        } else {
          combinational.add(item.body);
        }
        continue;
      }
      if (item is IrStatement) {
        if (item is AssignmentStatement &&
            item.type == AssignmentType.continuous) {
          directItems.add(item);
        } else if (_isSequentialStatement(item)) {
          sequential.add(item);
        } else {
          combinational.add(item);
        }
      }
    }

    for (final item in directItems) {
      if (item is ContinuousAssignment) {
        _generateContinuousAssignment(item);
      } else if (item is AssignmentStatement &&
          item.type == AssignmentType.continuous) {
        _generateAssignmentStatement(item);
      } else if (item is ModuleInstantiation) {
        _generateModuleInstantiation(item);
      } else if (item is GenerateBlock) {
        _generateGenerateBlock(item);
      } else if (item is RawCodeItem) {
        _generateRawCode(item);
      } else if (item is InitialBlock) {
        _generateInitialBlock(item);
      }
    }

    if (combinational.isNotEmpty) {
      _writeLine();
      _writeLine('Combinational([');
      _indent();
      for (final stmt in combinational) {
        _emitStatement(stmt, asListItem: true);
      }
      _dedent();
      _writeLine(']);');
    }

    if (sequential.isNotEmpty) {
      final clockName = _clockSignalName(module);
      _writeLine();
      if (clockName == null) {
        _writeLine('// TODO: missing clock for sequential logic');
        _writeLine('Combinational([');
      } else {
        _writeLine('Sequential($clockName, [');
      }
      _indent();
      for (final stmt in sequential) {
        _emitStatement(stmt, asListItem: true);
      }
      _dedent();
      _writeLine(']);');
    }
  }

  void _emitStatement(IrStatement stmt, {required bool asListItem}) {
    final temp = StringBuffer();
    stmtGen.generate(temp, stmt, asListItem: asListItem);
    final lines = temp.toString().split('\n');
    for (final line in lines) {
      if (line.isEmpty) continue;
      _writeLine(line);
    }
  }

  void _generateContinuousAssignment(ContinuousAssignment assign) {
    final target = exprGen.generate(assign.target);
    final value = _valueForContinuous(assign.value, target);
    _writeLine('$target <= $value;');
  }

  void _generateAssignmentStatement(AssignmentStatement assign) {
    final target = exprGen.generate(assign.target);
    final value = _valueForContinuous(assign.value, target);
    _writeLine('$target <= $value;');
  }

  String _valueForContinuous(IrExpression value, String target) {
    if (value is LiteralExpression) {
      final literal = exprGen.generate(value);
      return 'Const($literal, width: $target.width)';
    }
    return exprGen.generate(value);
  }

  void _generateInitialBlock(InitialBlock block) {
    _writeLine('// Initial block - use Simulator for testbenches');
  }

  void _generateModuleInstantiation(ModuleInstantiation inst) {
    final instanceName = namingStrategy.toCamelCase(inst.instanceName);
    final className = namingStrategy.toClassName(inst.moduleName);

    final conns = <String>[];
    for (final conn in inst.portConnections) {
      final portName = namingStrategy.toCamelCase(conn.portName);
      if (conn.value != null) {
        final value = exprGen.generate(conn.value!);
        conns.add('$portName: $value');
      } else {
        conns.add(portName);
      }
    }

    _writeLine('final $instanceName = $className(${conns.join(', ')});');
  }

  void _generateGenerateBlock(GenerateBlock block) {
    for (final item in block.items) {
      if (item is RawCodeItem) {
        _generateRawCode(item);
      }
    }
  }

  void _generateRawCode(RawCodeItem item) {
    for (final line in item.code.split('\n')) {
      if (line.trim().isEmpty) continue;
      _writeLine(line);
    }
  }

  bool _isSequentialStatement(IrStatement stmt) {
    return _containsNonBlocking(stmt);
  }

  bool _containsNonBlocking(IrStatement stmt) {
    if (stmt is AssignmentStatement) {
      return stmt.type == AssignmentType.nonBlocking;
    }
    if (stmt is NonBlockingAssignmentStatement) {
      return true;
    }
    if (stmt is IfStatement) {
      return _containsNonBlocking(stmt.thenBranch) ||
          (stmt.elseBranch != null && _containsNonBlocking(stmt.elseBranch!));
    }
    if (stmt is CaseStatement) {
      for (final item in stmt.items) {
        if (item.statement != null && _containsNonBlocking(item.statement!)) {
          return true;
        }
      }
      if (stmt.defaultCase != null) {
        return _containsNonBlocking(stmt.defaultCase!);
      }
    }
    if (stmt is SequentialBlock) {
      for (final s in stmt.statements) {
        if (_containsNonBlocking(s)) {
          return true;
        }
      }
    }
    if (stmt is ForLoopStatement) {
      return _containsNonBlocking(stmt.body) ||
          (stmt.initialization != null &&
              _containsNonBlocking(stmt.initialization!)) ||
          (stmt.step != null && _containsNonBlocking(stmt.step!));
    }
    if (stmt is WhileLoopStatement) {
      return _containsNonBlocking(stmt.body);
    }
    return false;
  }

  String? _clockSignalName(ModuleDeclaration module) {
    for (final port in module.ports) {
      final lower = port.name.toLowerCase();
      if (lower == 'clk' || lower == 'clock') {
        return namingStrategy.toCamelCase(port.name);
      }
    }
    for (final port in module.ports) {
      if (port.direction == PortDirection.input) {
        return namingStrategy.toCamelCase(port.name);
      }
    }
    return null;
  }

  String _getWidth(VectorWidth? width) {
    if (width == null) return '1';
    final msb = width.msb;
    final lsb = width.lsb;

    // Try to parse as integer expressions
    if (msb is LiteralExpression && lsb is LiteralExpression) {
      final widthInt = msb.value as int;
      final lsbInt = lsb.value as int;
      return ((widthInt - lsbInt).abs() + 1).toString();
    }

    // todo: validate and harden the ir tree to ensure msb and lsb are always present and valid for width declarations
    // For parameterized widths, default to an impossible value
    return '-1'; // Default width for parameterized signals
  }

  void _writeLine([String text = '']) {
    _buffer.writeln('${'  ' * _indentLevel}$text');
  }

  void _indent() {
    _indentLevel++;
  }

  void _dedent() {
    if (_indentLevel > 0) {
      _indentLevel--;
    }
  }
}
