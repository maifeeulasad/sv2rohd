// Copyright (C) 2026
// SPDX-License-Identifier: BSD-3-Clause

import '../common/common.dart';
import '../ir/ir.dart';
import 'expression_generator.dart';
import 'signal_generator.dart';
import 'module_generator.dart';

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
  final ExpressionGenerator exprGen;
  final SignalGenerator signalGen;
  final ModuleGenerator moduleGen;
  final StringBuffer _buffer = StringBuffer();
  int _indentLevel = 0;

  RohdGenerator({
    GeneratorOptions? options,
  })  : options = options ?? const GeneratorOptions(),
        exprGen = ExpressionGenerator(
          namingStrategy: options?.namingStrategy ?? const NamingStrategy(),
        ),
        signalGen = SignalGenerator(
          namingStrategy: options?.namingStrategy ?? const NamingStrategy(),
        ),
        moduleGen = ModuleGenerator(
          exprGen: exprGen,
          signalGen: signalGen,
          namingStrategy: options?.namingStrategy ?? const NamingStrategy(),
        );

  /// Generate ROHD code from a module.
  String generate(ModuleDeclaration module) {
    _buffer.clear();
    _indentLevel = 0;

    // Generate imports
    _generateImports();

    // Generate module class
    _generateModule(module);

    return _buffer.toString();
  }

  void _generateImports() {
    _writeLine("import 'package:rohd/rohd.dart';");
    _writeLine();
  }

  void _generateModule(ModuleDeclaration module) {
    final className = options.namingStrategy.toClassName(module.name);

    _writeLine('class $className extends Module {');

    // Generate constructor
    _indent();
    _generateConstructor(module);

    // Generate ports
    _generatePorts(module.ports);

    // Generate build method
    _writeLine();
    _generateBuildMethod(module);

    _dedent();
    _writeLine('}');
  }

  void _generateConstructor(ModuleDeclaration module) {
    final className = options.namingStrategy.toClassName(module.name);
    final params = <String>[];

    // Generate parameter declarations
    for (final param in module.parameters) {
      final paramName = options.namingStrategy.toCamelCase(param.name);
      final defaultValue = param.defaultValue != null
          ? exprGen.generate(param.defaultValue!)
          : '0';
      params.add('int $paramName = $defaultValue');
    }

    final paramStr = params.isEmpty ? '' : ', {${params.join(', ')}}';

    _writeLine('$className($paramStr) : super(name: \'${module.name}\') {');
    _writeLine('  build();');
    _writeLine('}');
    _writeLine();
  }

  void _generatePorts(List<PortDeclaration> ports) {
    for (final port in ports) {
      final portName = options.namingStrategy.toCamelCase(port.name);
      final width = _getWidth(port.width);

      switch (port.direction) {
        case PortDirection.input:
          _writeLine("final $portName = addInput('${port.name}', width: $width);");
          break;
        case PortDirection.output:
          _writeLine("final $portName = addOutput('${port.name}', width: $width);");
          break;
        case PortDirection.inout:
          _writeLine("final $portName = addInOut('${port.name}', width: $width);");
          break;
      }
    }
  }

  void _generateBuildMethod(ModuleDeclaration module) {
    _writeLine('@override');
    _writeLine('void build() {');

    _indent();

    // Generate signals and items
    for (final item in module.items) {
      _generateItem(item);
    }

    _dedent();
    _writeLine('}');
  }

  void _generateItem(IrNode item) {
    if (item is SignalDeclaration) {
      signalGen.generateSignal(_buffer, item);
    } else if (item is ContinuousAssignment) {
      _generateContinuousAssignment(item);
    } else if (item is AlwaysBlock) {
      _generateAlwaysBlock(item);
    } else if (item is InitialBlock) {
      _generateInitialBlock(item);
    } else if (item is ModuleInstantiation) {
      _generateModuleInstantiation(item);
    } else if (item is GenerateBlock) {
      _generateGenerateBlock(item);
    }
  }

  void _generateContinuousAssignment(ContinuousAssignment assign) {
    final target = exprGen.generate(assign.target);
    final value = exprGen.generate(assign.value);
    _writeLine('$target <= $value;');
  }

  void _generateAlwaysBlock(AlwaysBlock block) {
    switch (block.kind) {
      case BlockKind.alwaysComb:
        _writeLine('Combinational([');
        _indent();
        _generateStatement(block.body);
        _dedent();
        _writeLine(']);');
        break;
      case BlockKind.alwaysFf:
        _writeLine('// TODO: Sequential logic');
        _generateStatement(block.body);
        break;
      case BlockKind.alwaysLatch:
        _writeLine('// TODO: Latch logic');
        _generateStatement(block.body);
        break;
      case BlockKind.initial:
      case BlockKind.finalBlock:
        _writeLine('// Initial/final blocks not supported in ROHD');
        break;
    }
  }

  void _generateInitialBlock(InitialBlock block) {
    _writeLine('// Initial block - use Simulator for testbenches');
    // Could generate Simulator.registerFunction() here
  }

  void _generateModuleInstantiation(ModuleInstantiation inst) {
    final instanceName = options.namingStrategy.toCamelCase(inst.instanceName);
    final className = options.namingStrategy.toClassName(inst.moduleName);

    // Generate port connections
    final conns = <String>[];
    for (final conn in inst.portConnections) {
      final portName = options.namingStrategy.toCamelCase(conn.portName);
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
    // Generate blocks are handled at parse time in ROHD
    // For now, just generate the contents
    for (final item in block.items) {
      _generateItem(item);
    }
  }

  void _generateStatement(IrStatement stmt) {
    if (stmt is AssignmentStatement) {
      _generateAssignment(stmt);
    } else if (stmt is IfStatement) {
      _generateIfStatement(stmt);
    } else if (stmt is CaseStatement) {
      _generateCaseStatement(stmt);
    } else if (stmt is ForLoopStatement) {
      _generateForLoop(stmt);
    } else if (stmt is WhileLoopStatement) {
      _generateWhileLoop(stmt);
    } else if (stmt is SequentialBlock) {
      _generateSequentialBlock(stmt);
    } else if (stmt is ReturnStatement) {
      _generateReturnStatement(stmt);
    } else if (stmt is EmptyStatement) {
      // Skip empty statements
    }
  }

  void _generateAssignment(AssignmentStatement assign) {
    final target = exprGen.generate(assign.target);
    final value = exprGen.generate(assign.value);

    switch (assign.type) {
      case AssignmentType.blocking:
        _writeLine('$target < $value;');
        break;
      case AssignmentType.nonBlocking:
        _writeLine('$target <= $value;');
        break;
      case AssignmentType.continuous:
        _writeLine('$target <= $value;');
        break;
      case AssignmentType.procedural:
        _writeLine('$target < $value;');
        break;
    }
  }

  void _generateIfStatement(IfStatement stmt) {
    final condition = exprGen.generate(stmt.condition);

    _write('If($condition, then: [');
    _indent();

    for (final s in _flattenBlock(stmt.thenBranch)) {
      _generateStatement(s);
    }

    _dedent();
    _write(']');

    if (stmt.elseBranch != null) {
      _write(', else: [');
      _indent();

      for (final s in _flattenBlock(stmt.elseBranch!)) {
        _generateStatement(s);
      }

      _dedent();
      _write(']');
    }

    _writeLine('),');
  }

  void _generateCaseStatement(CaseStatement stmt) {
    final selector = exprGen.generate(stmt.expression);

    _writeLine('Case($selector, [');

    _indent();

    for (final item in stmt.items) {
      _generateCaseItem(item);
    }

    if (stmt.items.isEmpty ||
        stmt.items.last is! CaseItem ||
        (stmt.items.last as CaseItem).values.isNotEmpty) {
      // No default case
    }

    _dedent();
    _writeLine(']),');
  }

  void _generateCaseItem(CaseItem item) {
    for (final value in item.values) {
      final val = exprGen.generate(value);
      _writeLine('CaseItem($val, [');
      _indent();

      if (item.statement != null) {
        for (final s in _flattenBlock(item.statement!)) {
          _generateStatement(s);
        }
      }

      _dedent();
      _writeLine(']),');
    }
  }

  void _generateForLoop(ForLoopStatement stmt) {
    // ROHD doesn't have for loops in Combinational/Sequential
    // For now, just generate the body
    _writeLine('// for loop');
    _generateStatement(stmt.body);
  }

  void _generateWhileLoop(WhileLoopStatement stmt) {
    _writeLine('// while loop');
    _generateStatement(stmt.body);
  }

  void _generateSequentialBlock(SequentialBlock stmt) {
    for (final s in stmt.statements) {
      _generateStatement(s);
    }
  }

  void _generateReturnStatement(ReturnStatement stmt) {
    if (stmt.value != null) {
      final value = exprGen.generate(stmt.value!);
      _writeLine('return $value;');
    } else {
      _writeLine('return;');
    }
  }

  List<IrStatement> _flattenBlock(IrStatement stmt) {
    if (stmt is SequentialBlock) {
      return stmt.statements.expand(_flattenBlock).toList();
    }
    return [stmt];
  }

  String _getWidth(VectorWidth? width) {
    if (width == null) return '1';
    if (width.msb is LiteralExpression && width.lsb is LiteralExpression) {
      final msb = (width.msb as LiteralExpression).value as int;
      final lsb = (width.lsb as LiteralExpression).value as int;
      return ((msb - lsb).abs() + 1).toString();
    }
    return '1';
  }

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
    if (_indentLevel > 0) {
      _indentLevel--;
    }
  }
}

/// Simple naming strategy for code generation.
class NamingStrategy {
  const NamingStrategy();

  String toClassName(String name) {
    // Convert snake_case to PascalCase
    final parts = name.split('_');
    return parts.map((p) => p.isEmpty ? '' : '${p[0].toUpperCase()}${p.substring(1).toLowerCase()}').join();
  }

  String toCamelCase(String name) {
    final className = toClassName(name);
    if (className.isEmpty) return className;
    return '${className[0].toLowerCase()}${className.substring(1)}';
  }

  String toDart(String name) {
    return name;
  }
}
