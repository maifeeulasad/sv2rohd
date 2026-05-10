// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

import '../ir/ir.dart';
import 'expression_generator.dart';
import 'signal_generator.dart';
import 'naming_strategy.dart';

/// Generates ROHD code from IR generate blocks.
///
/// In SystemVerilog, generate blocks can be used for:
/// - Conditional generation (if-generate)
/// - Case generation (case-generate)
/// - Loop generation (for-generate)
///
/// ROHD handles this differently - generate blocks are typically resolved at
/// parse time, but we can still generate equivalent Dart code.
class GenerateBlockGenerator {
  final ExpressionGenerator exprGen;
  final SignalGenerator signalGen;
  final NamingStrategy namingStrategy;

  GenerateBlockGenerator({
    required this.exprGen,
    required this.signalGen,
    required this.namingStrategy,
  });

  /// Generate generate block code.
  void generate(
    StringBuffer buffer,
    GenerateBlock block,
  ) {
    switch (block.kind) {
      case GenerateKind.ifGenerate:
        _generateIfGenerate(buffer, block);
        break;
      case GenerateKind.forGenerate:
        _generateForGenerate(buffer, block);
        break;
      case GenerateKind.caseGenerate:
        _generateCaseGenerate(buffer, block);
        break;
      case GenerateKind.loopGenerate:
        _generateLoopGenerate(buffer, block);
        break;
    }
  }

  void _generateIfGenerate(
    StringBuffer buffer,
    GenerateBlock block,
  ) {
    // if-generate blocks have a condition expression
    if (block.condition != null) {
      final condition = exprGen.generate(block.condition!);
      buffer.writeln('// if-generate');
      buffer.writeln('// Condition: $condition');
      _generateBlockItems(buffer, block.items);
    } else {
      // Plain generate block (not originally if-generate)
      _generateBlockItems(buffer, block.items);
    }
  }

  void _generateForGenerate(
    StringBuffer buffer,
    GenerateBlock block,
  ) {
    // for-generate blocks
    buffer.writeln('// for-generate');
    _generateBlockItems(buffer, block.items);
  }

  void _generateCaseGenerate(
    StringBuffer buffer,
    GenerateBlock block,
  ) {
    // case-generate blocks
    buffer.writeln('// case-generate');
    if (block.condition != null) {
      final selector = exprGen.generate(block.condition!);
      buffer.writeln('// Selector: $selector');
    }
    _generateBlockItems(buffer, block.items);
  }

  void _generateLoopGenerate(
    StringBuffer buffer,
    GenerateBlock block,
  ) {
    // Loop generate - unrolled in ROHD
    buffer.writeln('// loop-generate');
    _generateBlockItems(buffer, block.items);
  }

  void _generateBlockItems(StringBuffer buffer, List<IrNode> items) {
    for (final item in items) {
      if (item is SignalDeclaration) {
        signalGen.generateSignal(buffer, item);
      } else if (item is GenerateBlock) {
        generate(buffer, item);
      } else if (item is ContinuousAssignment) {
        _generateContinuousAssignment(buffer, item);
      } else if (item is ModuleInstantiation) {
        _generateInstantiation(buffer, item);
      }
    }
  }

  void _generateContinuousAssignment(
    StringBuffer buffer,
    ContinuousAssignment assign,
  ) {
    final target = exprGen.generate(assign.target);
    final value = exprGen.generate(assign.value);
    buffer.writeln('$target <= $value;');
  }

  void _generateInstantiation(
    StringBuffer buffer,
    ModuleInstantiation inst,
  ) {
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

    buffer.writeln('final $instanceName = $className(${conns.join(', ')});');
  }
}
