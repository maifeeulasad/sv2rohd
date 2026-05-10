// Copyright (C) 2026
// SPDX-License-Identifier: BSD-3-Clause

import '../ir/ir.dart';
import 'expression_generator.dart';

/// Generates testbench code for ROHD.
///
/// Handles testbench-specific constructs like:
/// - Stimulus generation
/// - Clock generation
/// - Reset sequence
/// - Monitor/assertion logic
/// - Simulator registration
class TestbenchGenerator {
  final ExpressionGenerator exprGen;
  int _indentLevel = 0;

  TestbenchGenerator({required this.exprGen});

  /// Generate testbench module.
  void generate(StringBuffer buffer, TestbenchDeclaration testbench) {
    // Generate imports
    buffer.writeln("import 'package:rohd/rohd.dart';");
    buffer.writeln("import 'package:rohd_sim/rohd_sim.dart';");
    buffer.writeln();

    final className = _toClassName(testbench.name);
    buffer.writeln('class ${className}TB {');
    _indent();

    buffer.writeln('final Module _dut;');
    buffer.writeln();
    buffer.writeln('${className}TB(this._dut);');
    buffer.writeln();

    // Generate test methods
    for (final test in testbench.tests) {
      _generateTest(buffer, test);
    }

    _dedent();
    buffer.writeln('}');
  }

  void _generateTest(StringBuffer buffer, TestDefinition test) {
    final testName = _toCamelCase(test.name);
    buffer.writeln('Future<void> $testName() async {');
    _indent();

    buffer.writeln('// Setup');
    if (test.clock != null) {
      _generateClockSetup(buffer, test.clock!);
    }

    if (test.resetSequence != null) {
      _generateResetSequence(buffer, test.resetSequence!);
    }

    // Generate stimulus
    for (final stimulus in test.stimuli) {
      _generateStimulus(buffer, stimulus);
    }

    // Wait for completion
    if (test.duration != null) {
      final duration = exprGen.generate(test.duration!);
      buffer.writeln('await Simulator().run();');
    }

    _dedent();
    buffer.writeln('}');
    buffer.writeln();
  }

  void _generateClockSetup(StringBuffer buffer, ClockGeneration clock) {
    buffer.writeln('// Clock generation');
    final period = exprGen.generate(clock.period);
    buffer.writeln('final clk = Clock(logic: _dut.clk);');
    buffer.writeln('await clk.start($period);');
  }

  void _generateResetSequence(StringBuffer buffer, ResetSequence reset) {
    buffer.writeln('// Reset sequence');
    if (reset.resetActiveHigh) {
      buffer.writeln('dut.rst.put(1);');
      final duration = exprGen.generate(reset.duration);
      buffer.writeln('await Future.delayed(Duration(microseconds: $duration));');
      buffer.writeln('dut.rst.put(0);');
    }
  }

  void _generateStimulus(StringBuffer buffer, StimulusDefinition stimulus) {
    switch (stimulus.kind) {
      case StimulusKind.clock:
        buffer.writeln('// Clock stimulus');
        break;
      case StimulusKind.reset:
        buffer.writeln('// Reset stimulus');
        break;
      case StimulusKind.data:
        buffer.writeln('// Data stimulus');
        _generateDataStimulus(buffer, stimulus);
        break;
      case StimulusKind.burst:
        buffer.writeln('// Burst stimulus');
        _generateBurstStimulus(buffer, stimulus);
        break;
    }
  }

  void _generateDataStimulus(
    StringBuffer buffer,
    StimulusDefinition stimulus,
  ) {
    if (stimulus.value != null) {
      final signalName = _toCamelCase(stimulus.signalName);
      final value = exprGen.generate(stimulus.value!);
      buffer.writeln('dut.$signalName.put($value);');
    }
  }

  void _generateBurstStimulus(
    StringBuffer buffer,
    StimulusDefinition stimulus,
  ) {
    buffer.writeln('for (var i = 0; i < ${stimulus.count}; i++) {');
    _indent();
    buffer.writeln('// Burst data');
    _dedent();
    buffer.writeln('}');
  }

  String _toClassName(String name) {
    final parts = name.split('_');
    return parts
        .map(
          (p) => p.isEmpty ? '' : '${p[0].toUpperCase()}${p.substring(1).toLowerCase()}',
        )
        .join();
  }

  String _toCamelCase(String name) {
    final className = _toClassName(name);
    if (className.isEmpty) return className;
    return '${className[0].toLowerCase()}${className.substring(1)}';
  }

  void _indent() {
    _indentLevel++;
  }

  void _dedent() {
    if (_indentLevel > 0) {
      _indentLevel--;
    }
  }

  void _writeLine(StringBuffer buffer, String text) {
    buffer.writeln('${'  ' * _indentLevel}$text');
  }
}

/// Testbench declaration.
class TestbenchDeclaration extends IrNode {
  final String name;
  final List<TestDefinition> tests;

  TestbenchDeclaration({
    required super.location,
    required this.name,
    this.tests = const [],
  });

  @override
  List<IrNode> get children => tests;

  @override
  String get nodeType => 'TestbenchDeclaration';
}

/// Test definition.
class TestDefinition extends IrNode {
  final String name;
  final IrExpression? clock;
  final ResetSequence? resetSequence;
  final List<StimulusDefinition> stimuli;
  final IrExpression? duration;

  TestDefinition({
    required super.location,
    required this.name,
    this.clock,
    this.resetSequence,
    this.stimuli = const [],
    this.duration,
  });

  @override
  List<IrNode> get children {
    final children = <IrNode>[];
    if (clock != null) children.add(clock!);
    if (resetSequence != null) children.add(resetSequence!);
    if (duration != null) children.add(duration!);
    children.addAll(stimuli);
    return children;
  }

  @override
  String get nodeType => 'TestDefinition';
}

/// Clock generation.
class ClockGeneration extends IrNode {
  final IrExpression period;

  ClockGeneration({
    required super.location,
    required this.period,
  });

  @override
  List<IrNode> get children => [period];

  @override
  String get nodeType => 'ClockGeneration';
}

/// Reset sequence.
class ResetSequence extends IrNode {
  final IrExpression duration;
  final bool resetActiveHigh;

  ResetSequence({
    required super.location,
    required this.duration,
    this.resetActiveHigh = true,
  });

  @override
  List<IrNode> get children => [duration];

  @override
  String get nodeType => 'ResetSequence';
}

/// Stimulus definition.
class StimulusDefinition extends IrNode {
  final StimulusKind kind;
  final String signalName;
  final IrExpression? value;
  final int count;

  StimulusDefinition({
    required super.location,
    required this.kind,
    required this.signalName,
    this.value,
    this.count = 1,
  });

  @override
  List<IrNode> get children => value != null ? [value!] : [];

  @override
  String get nodeType => 'StimulusDefinition';
}

/// Stimulus kind.
enum StimulusKind {
  clock,
  reset,
  data,
  burst,
}
