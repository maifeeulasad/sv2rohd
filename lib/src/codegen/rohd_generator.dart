// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

// Parts of this implementation were generated with LLM assistance and
// reviewed by the maintainer.

import '../common/common.dart';
import '../analysis/symbol.dart';
import '../ir/ir.dart';
import 'expression_generator.dart';
import 'function_inliner.dart';
import 'statement_generator.dart';
import 'naming_strategy.dart';
import 'width_analyzer.dart';

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
///
/// Translates IR modules into ROHD `Module` subclasses:
/// - parameters become named `int` constructor arguments,
/// - parameterized widths become Dart integer expressions,
/// - unpacked arrays become `List<Logic>`,
/// - generate blocks are elaborated into Dart `for`/`if` constructs,
/// - each `always_ff`/`always_comb` becomes its own `Sequential`/
///   `Combinational` block.
class RohdGenerator {
  final GeneratorOptions options;
  final NamingStrategy namingStrategy;
  final DiagnosticCollector? diagnostics;

  final Map<String, ModuleDeclaration> _knownModules = {};
  final StringBuffer _buffer = StringBuffer();
  int _indentLevel = 0;

  late WidthAnalyzer _wa;
  late ExpressionGenerator _exprGen;
  late StatementGenerator _stmtGen;

  RohdGenerator({
    GeneratorOptions? options,
    this.diagnostics,
  })  : options = options ?? const GeneratorOptions(),
        namingStrategy = options?.namingStrategy ?? const NamingStrategy();

  /// Generate ROHD code for a single module.
  String generate(ModuleDeclaration module) => generateAll([module]);

  /// Generate ROHD code for all [modules] into a single source file.
  String generateAll(List<ModuleDeclaration> modules) {
    _buffer.clear();
    _indentLevel = 0;
    for (final module in modules) {
      _knownModules[module.name] = module;
    }

    for (var i = 0; i < modules.length; i++) {
      if (i > 0) _writeLine();
      _generateModule(modules[i]);
    }
    final body = _buffer.toString();

    // Assemble the file: import, an optional self-contained `log2Ceil` helper
    // (ROHD has no top-level equivalent — only `LogicValue.clog2()` — so
    // `$clog2` in an elaboration-time/width context needs one supplied here),
    // then the module bodies.
    final header = StringBuffer()
      ..writeln("import 'package:rohd/rohd.dart';")
      ..writeln();
    if (_usesLog2Ceil(body)) {
      header
        ..writeln('/// Ceil of log base 2 — the number of bits needed to index')
        ..writeln('/// [x] values (the elaboration-time form of `\$clog2`).')
        ..writeln('int log2Ceil(int x) => x <= 1 ? 0 : (x - 1).bitLength;')
        ..writeln();
    }
    if (_usesResize(body)) {
      header
        ..writeln('/// Resizes [v] to [width] bits: truncates the high bits when')
        ..writeln('/// wider, zero-extends when narrower. Used for SystemVerilog')
        ..writeln('/// context-determined widths that are parameterized (so the')
        ..writeln('/// direction is only known at construction time).')
        ..writeln('Logic _resize(Logic v, int width) => v.width == width')
        ..writeln('    ? v')
        ..writeln('    : v.width > width')
        ..writeln('        ? v.getRange(0, width)')
        ..writeln('        : v.zeroExtend(width);')
        ..writeln();
    }
    return header.toString() + body;
  }

  /// True when the generated [body] calls the `log2Ceil` helper (emitted for
  /// `$clog2` used in an int/width context).
  bool _usesLog2Ceil(String body) => RegExp(r'\blog2Ceil\(').hasMatch(body);

  /// True when the generated [body] calls the `_resize` helper (emitted for
  /// symbolic context-determined width normalization).
  bool _usesResize(String body) => RegExp(r'\b_resize\(').hasMatch(body);

  // ── Module ───────────────────────────────────────────────────────

  void _generateModule(ModuleDeclaration module) {
    _setupContext(module);

    final className = namingStrategy.toClassName(module.name);
    final topSignals = _topLevelSignals(module.items);

    _writeLine('class $className extends Module {');
    _indent();

    for (final port in module.ports) {
      final name = namingStrategy.toCamelCase(port.name);
      final type = port.direction == PortDirection.inout ? 'LogicNet' : 'Logic';
      _writeLine('late final $type $name;');
    }
    final portNames =
        module.ports.map((p) => namingStrategy.toCamelCase(p.name)).toSet();
    for (final signal in topSignals) {
      final name = namingStrategy.toCamelCase(signal.name);
      if (portNames.contains(name)) continue;
      _writeLine('late final ${_arrayFieldType(signal.unpackedDims.length)} '
          '$name;');
    }

    _writeLine();
    _generateConstructor(module, topSignals, portNames);

    _dedent();
    _writeLine('}');
  }

  void _setupContext(ModuleDeclaration module) {
    _wa = WidthAnalyzer(namingStrategy: namingStrategy);

    for (final param in module.parameters) {
      _wa.intDomain.add(namingStrategy.toCamelCase(param.name));
    }
    _collectContext(module.items);
    for (final port in module.ports) {
      _wa.signalWidths[port.name] = port.width;
      if (port.isSigned) _wa.signedSignals.add(port.name);
    }

    final functions = [
      for (final item in module.items)
        if (item is FunctionDeclaration) item,
    ];
    final inliner = functions.isEmpty
        ? null
        : FunctionInliner(functions, diagnostics: diagnostics);
    _wa.functionInliner = inliner;

    _exprGen = ExpressionGenerator(
      namingStrategy: namingStrategy,
      widthAnalyzer: _wa,
      arraySignals: _wa.arraySignals,
      functionInliner: inliner,
      diagnostics: diagnostics,
    );
    _stmtGen = StatementGenerator(
      exprGen: _exprGen,
      namingStrategy: namingStrategy,
      widthAnalyzer: _wa,
      diagnostics: diagnostics,
    );
  }

  void _collectContext(List<IrNode> items) {
    for (final item in items) {
      if (item is SignalDeclaration) {
        _wa.signalWidths[item.name] = item.width;
        if (item.isSigned) _wa.signedSignals.add(item.name);
        if (item.unpackedDims.isNotEmpty) {
          _wa.arraySignals.add(item.name);
          _wa.arrayDimensions[item.name] = item.unpackedDims.length;
        }
      } else if (item is GenvarDeclaration) {
        _wa.intDomain.add(namingStrategy.toCamelCase(item.name));
      } else if (item is ParameterDeclaration) {
        _wa.intDomain.add(namingStrategy.toCamelCase(item.name));
      } else if (item is GenerateBlock) {
        _collectContext(item.items);
      } else if (item is ForGenerateBlock) {
        final init = item.initialization;
        if (init is AssignmentStatement &&
            init.target is IdentifierExpression) {
          _wa.intDomain.add(namingStrategy
              .toCamelCase((init.target as IdentifierExpression).identifier));
        }
        _collectContext(item.body.items);
      } else if (item is IfGenerateBlock) {
        _collectContext(item.thenBranch.items);
        if (item.elseBranch != null) {
          _collectContext(item.elseBranch!.items);
        }
      } else if (item is CaseGenerateBlock) {
        for (final caseItem in item.items) {
          _collectContext(caseItem.body.items);
        }
      } else if (item is AlwaysBlock) {
        _collectProceduralLoopVars(item.body);
      }
    }
  }

  /// Registers procedural `for`-loop index variables (inside `always` blocks)
  /// in the int-domain. Such loops are elaborated to Dart `for (var i = …)`
  /// loops, so the index is a compile-time `int`, not a hardware signal — the
  /// same treatment genvars and generate-for loops already receive.
  void _collectProceduralLoopVars(IrNode node) {
    if (node is ForLoopStatement) {
      final init = node.initialization;
      if (init is AssignmentStatement && init.target is IdentifierExpression) {
        _wa.intDomain.add(namingStrategy
            .toCamelCase((init.target as IdentifierExpression).identifier));
      }
    }
    for (final child in node.children) {
      _collectProceduralLoopVars(child);
    }
  }

  List<SignalDeclaration> _topLevelSignals(List<IrNode> items) => [
        for (final item in items)
          if (item is SignalDeclaration) item
      ];

  /// True when [expr] is a compile-time constant usable as a Dart named-
  /// parameter default — i.e. it references no other parameter/identifier.
  bool _isConstDefault(IrExpression expr) =>
      !_containsIdentifier(expr);

  bool _containsIdentifier(IrNode node) {
    if (node is IdentifierExpression) return true;
    for (final child in node.children) {
      if (_containsIdentifier(child)) return true;
    }
    return false;
  }

  void _generateConstructor(
    ModuleDeclaration module,
    List<SignalDeclaration> topSignals,
    Set<String> portNames,
  ) {
    final className = namingStrategy.toClassName(module.name);
    final params = <String>[];
    for (final port in module.ports) {
      if (port.direction == PortDirection.output) continue;
      final name = namingStrategy.toCamelCase(port.name);
      final type = port.direction == PortDirection.inout ? 'LogicNet' : 'Logic';
      params.add('$type ${name}Source');
    }
    // A Dart named-parameter default must be a compile-time constant and
    // cannot reference another parameter, so a parameter whose default depends
    // on other parameters (e.g. `OW = 2 * DW`) is emitted as nullable and
    // resolved at the top of the constructor body (in declaration order).
    final namedParams = <String>[];
    final paramDefaults = <String>[]; // `name ??= expr;` for dependent defaults
    for (final param in module.parameters) {
      if (param.isLocal) continue;
      final name = namingStrategy.toCamelCase(param.name);
      final def = param.defaultValue;
      if (def == null) {
        namedParams.add('int $name = 0');
      } else if (_isConstDefault(def)) {
        namedParams.add('int $name = ${_exprGen.generateInt(def)}');
      } else {
        namedParams.add('int? $name');
        paramDefaults.add('$name ??= ${_exprGen.generateInt(def)};');
      }
    }
    if (namedParams.isNotEmpty) {
      params.add('{${namedParams.join(', ')}}');
    }

    _writeLine(
        "$className(${params.join(', ')}) : super(name: '${module.name}') {");
    _indent();

    if (paramDefaults.isNotEmpty) {
      _writeLine('// Parameter defaults that depend on other parameters');
      for (final line in paramDefaults) {
        _writeLine(line);
      }
      _writeLine();
    }

    if (module.ports.isNotEmpty) {
      _writeLine('// Ports');
      for (final port in module.ports) {
        _generatePortBinding(port);
      }
    }

    // Local parameters come from `localparam` declarations and from enum
    // members (emitted by the parser as local ParameterDeclaration items).
    final localParams = [
      for (final param in module.parameters)
        if (param.isLocal) param,
      for (final item in module.items)
        if (item is ParameterDeclaration && item.isLocal) item,
    ];
    if (localParams.isNotEmpty) {
      _writeLine();
      _writeLine('// Local parameters');
      for (final param in localParams) {
        final name = namingStrategy.toCamelCase(param.name);
        final value = param.defaultValue != null
            ? _exprGen.generateInt(param.defaultValue!)
            : '0';
        _writeLine('final $name = $value;');
      }
    }

    final ownSignals = [
      for (final signal in topSignals)
        if (!portNames.contains(namingStrategy.toCamelCase(signal.name)))
          signal,
    ];
    if (ownSignals.isNotEmpty) {
      _writeLine();
      _writeLine('// Internal signals');
      for (final signal in ownSignals) {
        _generateSignalBinding(signal, asLocal: false);
      }
    }

    _generateItems(module.items, topLevel: true);

    _dedent();
    _writeLine('}');
  }

  void _generatePortBinding(PortDeclaration port) {
    final name = namingStrategy.toCamelCase(port.name);
    final width = _widthString(port.width);
    switch (port.direction) {
      case PortDirection.input:
        _writeLine(
            "$name = addInput('${port.name}', ${name}Source, width: $width);");
      case PortDirection.output:
        _writeLine("$name = addOutput('${port.name}', width: $width);");
      case PortDirection.inout:
        _writeLine(
            "$name = addInOut('${port.name}', ${name}Source, width: $width);");
    }
  }

  void _generateSignalBinding(SignalDeclaration signal,
      {required bool asLocal}) {
    final name = namingStrategy.toCamelCase(signal.name);
    final width = _widthString(signal.width);
    final prefix = asLocal ? 'final ' : '';

    if (signal.unpackedDims.isNotEmpty) {
      _writeLine('$prefix$name = '
          '${_nestedListGenerate(signal, width, 0, const [])};');
      return;
    }

    _writeLine("$prefix$name = Logic(name: '${signal.name}', width: $width);");
    if (signal.initialValue != null) {
      if (signal.signalType == SignalType.wire) {
        // `wire x = expr;` is a continuous assignment, not a variable init.
        final value = _exprGen.generateLogic(signal.initialValue!,
            widthContext: name);
        _writeLine('$name <= $value;');
      } else {
        diagnostics?.warning(
          "initial value on '${signal.name}' is ignored (use a reset instead)",
          code: 'GEN0021',
        );
      }
    }
  }

  // ── Items ────────────────────────────────────────────────────────

  void _generateItems(List<IrNode> items, {required bool topLevel}) {
    for (final item in items) {
      if (item is SignalDeclaration) {
        if (!topLevel) {
          _generateSignalBinding(item, asLocal: true);
        }
        continue;
      }
      if (item is GenvarDeclaration ||
          item is ParameterDeclaration ||
          item is FunctionDeclaration) {
        // Functions are inlined at call sites, not emitted.
        continue;
      }
      if (item is AlwaysBlock) {
        _generateAlways(item);
        continue;
      }
      if (item is ContinuousAssignment) {
        _generateContinuous(item.target, item.value);
        continue;
      }
      if (item is InitialBlock) {
        _writeLine('// initial block skipped: use Simulator for testbenches');
        continue;
      }
      if (item is ModuleInstantiation) {
        _generateInstantiation(item);
        continue;
      }
      if (item is ForGenerateBlock) {
        _generateForGenerate(item);
        continue;
      }
      if (item is IfGenerateBlock) {
        _generateIfGenerate(item);
        continue;
      }
      if (item is CaseGenerateBlock) {
        _generateCaseGenerate(item);
        continue;
      }
      if (item is GenerateBlock) {
        _generateItems(item.items, topLevel: false);
        continue;
      }
      if (item is RawCodeItem) {
        for (final line in item.code.split('\n')) {
          if (line.trim().isEmpty) continue;
          _writeLine(line);
        }
        continue;
      }
      if (item is IrStatement) {
        _generateLooseStatement(item);
        continue;
      }
      diagnostics?.warning(
        'unsupported module item ${item.nodeType} skipped',
        code: 'GEN0022',
      );
    }
  }

  void _generateAlways(AlwaysBlock block) {
    _writeLine();

    if (block.kind != BlockKind.alwaysFf) {
      if (block.kind == BlockKind.alwaysLatch) {
        _writeLine('// always_latch approximated with Combinational');
      }
      _writeLine('Combinational([');
      _indent();
      for (final line in _stmtGen.lines(block.body, asListItem: true)) {
        _writeLine(line);
      }
      _dedent();
      _writeLine(']);');
      return;
    }

    var clock = block.clock != null
        ? namingStrategy.toCamelCase(block.clock!)
        : _clockHeuristic();
    if (clock == null) {
      _writeLine('// TODO: no clock found for sequential block');
      clock = 'Logic()';
    }
    final clockExpr = block.negedgeClock ? '~$clock' : clock;

    if (block.asyncResetSignal != null) {
      // ROHD's `Sequential` only re-evaluates on clock-edge glitches (see
      // rohd/lib/src/modules/conditional.dart): its `reset`/`resetValues`
      // parameters are pure syntax sugar for an `If(reset, ...)` wrapped
      // around the clocked body, evaluated *at the clock edge* like
      // everything else in the block. There is no primitive in this ROHD
      // version for a trigger that fires independently of the clock, so a
      // second edge-triggered signal in the sensitivity list (e.g.
      // `negedge rst_n`) cannot be modeled as genuinely asynchronous no
      // matter how it's generated here — only synchronous-equivalent
      // behavior is possible. Always warn so this limitation is visible
      // rather than silently downgrading the design's timing behavior.
      diagnostics?.warning(
        "always_ff clocked by '$clock' has a second edge-triggered signal "
        "('${block.asyncResetSignal}') in its sensitivity list, which reads "
        'as an asynchronous reset in SystemVerilog. The installed ROHD '
        'version has no primitive for a non-clock trigger, so only '
        'synchronous-equivalent reset behavior is generated (the reset is '
        'only applied at clock edges). Verify this matches your timing '
        'requirements.',
        code: 'GEN0026',
      );

      final extracted = _extractAsyncReset(block);
      if (extracted != null) {
        final resetName = namingStrategy.toCamelCase(block.asyncResetSignal!);
        final resetExpr = block.asyncResetActiveLow ? '~$resetName' : resetName;
        _writeLine('Sequential($clockExpr, [');
        _indent();
        for (final stmt in extracted.body) {
          for (final line in _stmtGen.lines(stmt, asListItem: true)) {
            _writeLine(line);
          }
        }
        _dedent();
        if (extracted.resetValues.isEmpty) {
          _writeLine('], reset: $resetExpr);');
        } else {
          _writeLine('], reset: $resetExpr, resetValues: {');
          _indent();
          for (final entry in extracted.resetValues.entries) {
            _writeLine('${entry.key}: ${entry.value},');
          }
          _dedent();
          _writeLine('});');
        }
        return;
      }
    }

    _writeLine('Sequential($clockExpr, [');
    _indent();
    for (final line in _stmtGen.lines(block.body, asListItem: true)) {
      _writeLine(line);
    }
    _dedent();
    _writeLine(']);');
  }

  /// Attempts to recognize the canonical
  /// `if (<reset active>) <literal resets> else <clocked body>` pattern and
  /// extract it into ROHD's `reset`/`resetValues` constructor sugar (still
  /// synchronous — see [_generateAlways] — but cleaner generated code than
  /// the equivalent manual `If`). Returns null when the body doesn't match,
  /// so the caller can fall back to plain synchronous-style generation.
  ({List<IrStatement> body, Map<String, String> resetValues})?
      _extractAsyncReset(AlwaysBlock block) {
    final resetSignal = block.asyncResetSignal!;

    var stmt = block.body;
    if (stmt is SequentialBlock && stmt.statements.length == 1) {
      stmt = stmt.statements.single;
    }
    if (stmt is! IfStatement) return null;

    final conditionMatches = block.asyncResetActiveLow
        ? _isNegatedIdentifier(stmt.condition, resetSignal)
        : _isBareIdentifier(stmt.condition, resetSignal);
    if (!conditionMatches) return null;

    final resetValues = <String, String>{};
    for (final s in _flattenStatements(stmt.thenBranch)) {
      if (s is! AssignmentStatement ||
          s.target is! IdentifierExpression ||
          !_exprGen.isIntDomain(s.value)) {
        return null;
      }
      resetValues[_exprGen.generate(s.target)] = _exprGen.generate(s.value);
    }

    final body = stmt.elseBranch != null
        ? _flattenStatements(stmt.elseBranch!)
        : const <IrStatement>[];
    return (body: body, resetValues: resetValues);
  }

  bool _isNegatedIdentifier(IrExpression expr, String name) {
    if (expr is! UnaryExpression) return false;
    if (expr.operator != UnaryOperator.logicalNot &&
        expr.operator != UnaryOperator.bitwiseNot) {
      return false;
    }
    return _isBareIdentifier(expr.operand, name);
  }

  bool _isBareIdentifier(IrExpression expr, String name) =>
      expr is IdentifierExpression && expr.identifier == name;

  List<IrStatement> _flattenStatements(IrStatement stmt) {
    if (stmt is SequentialBlock) {
      return stmt.statements.expand(_flattenStatements).toList();
    }
    return [stmt];
  }

  void _generateContinuous(IrExpression target, IrExpression value) {
    final lines = _stmtGen.lines(
      AssignmentStatement(
        location: target.location,
        target: target,
        value: value,
        type: AssignmentType.continuous,
      ),
      asListItem: false,
    );
    for (final line in lines) {
      _writeLine(line);
    }
  }

  void _generateForGenerate(ForGenerateBlock block) {
    final init = block.initialization;
    var varName = 'i';
    var initial = '0';
    if (init is AssignmentStatement && init.target is IdentifierExpression) {
      varName = namingStrategy
          .toCamelCase((init.target as IdentifierExpression).identifier);
      initial = _exprGen.generateInt(init.value);
    }
    final condition = block.condition != null
        ? _exprGen.generateInt(block.condition!)
        : 'false';
    final step = _stepText(varName, block.step);

    _writeLine();
    _writeLine('for (var $varName = $initial; $condition; $step) {');
    _indent();
    _generateItems(block.body.items, topLevel: false);
    _dedent();
    _writeLine('}');
  }

  String _stepText(String varName, IrStatement step) {
    if (step is AssignmentStatement && step.target is IdentifierExpression) {
      final target = namingStrategy
          .toCamelCase((step.target as IdentifierExpression).identifier);
      final value = step.value;
      if (value is BinaryExpression &&
          value.operator == BinaryOperator.add &&
          value.left is IdentifierExpression &&
          namingStrategy.toCamelCase(
                  (value.left as IdentifierExpression).identifier) ==
              target &&
          value.right is LiteralExpression &&
          (value.right as LiteralExpression).value == 1) {
        return '$target++';
      }
      return '$target = ${_exprGen.generateInt(value)}';
    }
    return '$varName++';
  }

  void _generateIfGenerate(IfGenerateBlock block) {
    _writeLine();
    _writeLine('if (${_exprGen.generateInt(block.condition)}) {');
    _indent();
    _generateItems(block.thenBranch.items, topLevel: false);
    _dedent();
    if (block.elseBranch != null) {
      _writeLine('} else {');
      _indent();
      _generateItems(block.elseBranch!.items, topLevel: false);
      _dedent();
    }
    _writeLine('}');
  }

  /// A case-generate selects a branch at elaboration time from the constant
  /// value of [CaseGenerateBlock.expression], so it lowers to a Dart
  /// if / else-if chain over the parameter value (default branch, marked by
  /// an item with empty `values`, becomes the trailing `else`).
  void _generateCaseGenerate(CaseGenerateBlock block) {
    final selector = _exprGen.generateInt(block.expression);
    GenerateCaseItem? defaultItem;
    var first = true;

    _writeLine();
    for (final item in block.items) {
      if (item.values.isEmpty) {
        defaultItem = item;
        continue;
      }
      final condition = item.values
          .map((v) => '$selector == ${_exprGen.generateInt(v)}')
          .join(' || ');
      _writeLine('${first ? '' : '} else '}if ($condition) {');
      _indent();
      _generateItems(item.body.items, topLevel: false);
      _dedent();
      first = false;
    }

    if (defaultItem != null) {
      if (first) {
        // Only a default branch: emit it unconditionally.
        _generateItems(defaultItem.body.items, topLevel: false);
        return;
      }
      _writeLine('} else {');
      _indent();
      _generateItems(defaultItem.body.items, topLevel: false);
      _dedent();
    }
    if (!first) _writeLine('}');
  }

  void _generateInstantiation(ModuleInstantiation inst) {
    final instanceName = namingStrategy.toCamelCase(inst.instanceName);
    final className = namingStrategy.toClassName(inst.moduleName);
    final target = _knownModules[inst.moduleName];

    _writeLine();
    if (target == null) {
      diagnostics?.warning(
        "instantiated module '${inst.moduleName}' is not defined in this "
        'file; connections passed positionally',
        code: 'GEN0023',
      );
      final args = [
        for (final conn in inst.portConnections)
          if (conn.value != null) _exprGen.generateLogic(conn.value!),
      ];
      _writeLine('// TODO: verify connections for external module '
          "'${inst.moduleName}'");
      _writeLine('final $instanceName = $className(${args.join(', ')});');
      return;
    }

    // Resolve connections by name (positional entries use $pos<i> keys).
    final byName = <String, IrExpression?>{};
    for (var i = 0; i < inst.portConnections.length; i++) {
      final conn = inst.portConnections[i];
      if (conn.portName.startsWith(r'$pos')) {
        final index = int.tryParse(conn.portName.substring(4)) ?? i;
        if (index < target.ports.length) {
          byName[target.ports[index].name] = conn.value;
        }
      } else {
        byName[conn.portName] = conn.value;
      }
    }

    final args = <String>[];
    for (final port in target.ports) {
      if (port.direction == PortDirection.output) continue;
      final conn = byName[port.name];
      if (conn == null) {
        diagnostics?.warning(
          "input '${port.name}' of instance '${inst.instanceName}' is "
          'unconnected; tied to 0',
          code: 'GEN0024',
        );
        args.add('Const(0, width: ${_widthString(port.width)})');
      } else {
        args.add(_exprGen.generateLogic(conn));
      }
    }

    final paramArgs = <String>[];
    for (var i = 0; i < inst.parameterValues.length; i++) {
      if (i < target.parameters.length) {
        final name = namingStrategy.toCamelCase(target.parameters[i].name);
        paramArgs
            .add('$name: ${_exprGen.generateInt(inst.parameterValues[i])}');
      }
    }
    for (final conn in inst.parameterConnections) {
      if (conn.value == null) continue;
      final name = namingStrategy.toCamelCase(conn.portName);
      paramArgs.add('$name: ${_exprGen.generateInt(conn.value!)}');
    }
    args.addAll(paramArgs);

    _writeLine('final $instanceName = $className(${args.join(', ')});');

    for (final port in target.ports) {
      if (port.direction != PortDirection.output) continue;
      final conn = byName[port.name];
      if (conn == null) continue;
      final targetStr = _exprGen.generate(conn);
      final portField = namingStrategy.toCamelCase(port.name);
      _writeLine('$targetStr <= $instanceName.$portField;');
    }
  }

  /// Legacy path for IR built directly from statements (API users):
  /// statements containing non-blocking assignments become a Sequential
  /// block; everything else combinational.
  void _generateLooseStatement(IrStatement stmt) {
    if (stmt is AssignmentStatement && stmt.type == AssignmentType.continuous) {
      _generateContinuous(stmt.target, stmt.value);
      return;
    }
    final sequential = _containsNonBlocking(stmt);
    _writeLine();
    if (sequential) {
      final clock = _clockHeuristic();
      if (clock == null) {
        _writeLine('// TODO: no clock found for sequential logic');
      }
      _writeLine('Sequential(${clock ?? 'Logic()'}, [');
    } else {
      _writeLine('Combinational([');
    }
    _indent();
    for (final line in _stmtGen.lines(stmt, asListItem: true)) {
      _writeLine(line);
    }
    _dedent();
    _writeLine(']);');
  }

  bool _containsNonBlocking(IrStatement stmt) {
    if (stmt is AssignmentStatement) {
      return stmt.type == AssignmentType.nonBlocking;
    }
    if (stmt is NonBlockingAssignmentStatement) return true;
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
      return stmt.statements.any(_containsNonBlocking);
    }
    if (stmt is ForLoopStatement) {
      return _containsNonBlocking(stmt.body);
    }
    if (stmt is WhileLoopStatement) {
      return _containsNonBlocking(stmt.body);
    }
    return false;
  }

  String? _clockHeuristic() {
    for (final entry in _wa.signalWidths.keys) {
      final lower = entry.toLowerCase();
      if (lower == 'clk' || lower == 'clock') {
        return namingStrategy.toCamelCase(entry);
      }
    }
    return null;
  }

  // ── Widths ───────────────────────────────────────────────────────

  String _widthString(VectorWidth? width) {
    if (width == null) return '1';
    final form = _wa.widthOfVector(width);
    if (form != null) return form.render();
    final msb = width.msb != null ? _exprGen.generateInt(width.msb!) : '0';
    final lsb = width.lsb != null ? _exprGen.generateInt(width.lsb!) : '0';
    return '($msb) - ($lsb) + 1';
  }

  /// Number of elements in an unpacked dimension, valid for either
  /// `[0:N-1]` or `[N-1:0]` orientation.
  String _dimensionCount(VectorWidth dim) {
    final msb = _wa.linearOf(dim.msb);
    final lsb = _wa.linearOf(dim.lsb);
    if (msb != null && lsb != null) {
      final diff = msb - lsb;
      if (diff.isConstant) {
        return '${diff.constant.abs() + 1}';
      }
      final names = diff.coeffs.keys.toList()..sort();
      final leading = names
          .map((n) => diff.coeffs[n]!)
          .firstWhere((c) => c != 0, orElse: () => 1);
      final oriented = leading < 0
          ? (lsb - msb) + LinearExpr.constant(1)
          : diff + LinearExpr.constant(1);
      return oriented.render();
    }
    return '1';
  }

  /// Dart field type for a signal with [dimCount] unpacked dimensions:
  /// `Logic`, `List<Logic>`, `List<List<Logic>>`, ...
  String _arrayFieldType(int dimCount) =>
      '${'List<' * dimCount}Logic${'>' * dimCount}';

  /// Builds a (possibly nested) `List.generate(...)` expression that
  /// allocates every element of an unpacked array, one `List.generate` per
  /// dimension, with each leaf `Logic` named `sig_<i0>_<i1>_...`.
  String _nestedListGenerate(
    SignalDeclaration signal,
    String width,
    int level,
    List<String> indexVars,
  ) {
    if (level == signal.unpackedDims.length) {
      final nameExpr = indexVars.isEmpty
          ? "'${signal.name}'"
          : "'${signal.name}_${indexVars.map((v) => '\${$v}').join('_')}'";
      return 'Logic(name: $nameExpr, width: $width)';
    }
    final count = _dimensionCount(signal.unpackedDims[level]);
    final idx = 'i$level';
    final inner =
        _nestedListGenerate(signal, width, level + 1, [...indexVars, idx]);
    return 'List.generate($count, ($idx) => $inner)';
  }

  // ── Output helpers ───────────────────────────────────────────────

  void _writeLine([String text = '']) {
    if (text.isEmpty) {
      _buffer.writeln();
    } else {
      _buffer.writeln('${'  ' * _indentLevel}$text');
    }
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
