// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

import 'ir_node.dart';
import 'expression_ir.dart';
import 'statement_ir.dart';
import 'module_ir.dart';
import 'ir_visitor.dart';
import '../analysis/symbol.dart';

/// Prints the IR as a string representation.
class IrPrinter extends DefaultIrVisitor<String> {
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
    _writeLine('module ${node.name} (');

    for (final param in node.parameters) {
      _writeLine('  parameter ${param.name};');
    }

    for (final port in node.ports) {
      final directionStr = _portDirectionToString(port.direction);
      _writeLine('  $directionStr ${port.name};');
    }

    _indent();
    for (final item in node.items) {
      item.accept(this);
    }
    _dedent();

    _writeLine('endmodule');

    return '';
  }

  String _portDirectionToString(PortDirection direction) {
    switch (direction) {
      case PortDirection.input:
        return 'input';
      case PortDirection.output:
        return 'output';
      case PortDirection.inout:
        return 'inout';
    }
  }

  @override
  String visitSignal(SignalDeclaration node) {
    final typeStr = _signalTypeToString(node.signalType);
    _writeLine('signal $typeStr ${node.name};');
    return '';
  }

  String _signalTypeToString(SignalType type) {
    switch (type) {
      case SignalType.wire:
        return 'wire';
      case SignalType.reg:
        return 'reg';
      case SignalType.logic:
        return 'logic';
      case SignalType.bit:
        return 'bit';
    }
  }

  @override
  String visitStatement(IrStatement node) {
    _writeLine('${_indentStr()}${node.nodeType}');
    return '';
  }

  @override
  String visitAssignment(AssignmentStatement node) {
    final typeStr = _assignmentTypeToString(node.type);
    _write('${_indentStr()}${node.target}(${node.value}) [$typeStr]');
    return '';
  }

  String _assignmentTypeToString(AssignmentType type) {
    switch (type) {
      case AssignmentType.blocking:
        return 'blocking';
      case AssignmentType.nonBlocking:
        return 'non-blocking';
      case AssignmentType.continuous:
        return 'continuous';
      case AssignmentType.procedural:
        return 'procedural';
    }
  }

  @override
  String visitIfStatement(IfStatement node) {
    _writeLine('${_indentStr()}if');
    node.condition.accept(this);
    _indent();
    node.thenBranch.accept(this);
    _dedent();
    if (node.elseBranch != null) {
      _writeLine('${_indentStr()}else');
      _indent();
      node.elseBranch!.accept(this);
      _dedent();
    }
    return '';
  }

  @override
  String visitCaseStatement(CaseStatement node) {
    _writeLine('${_indentStr()}case');
    node.expression.accept(this);
    _indent();
    for (final item in node.items) {
      _writeLine('${_indentStr()}case_item');
      _indent();
      for (final value in item.values) {
        value.accept(this);
      }
      _dedent();
    }
    _dedent();
    return '';
  }

  @override
  String visitForLoop(ForLoopStatement node) {
    _writeLine('${_indentStr()}for');
    _indent();
    node.body.accept(this);
    _dedent();
    return '';
  }

  @override
  String visitWhileLoop(WhileLoopStatement node) {
    _writeLine('${_indentStr()}while');
    _indent();
    node.body.accept(this);
    _dedent();
    return '';
  }

  @override
  String visitExpression(IrExpression node) {
    _write('${_indentStr()}${node.nodeType}');
    return '';
  }

  @override
  String visitBinaryOp(BinaryExpression node) {
    _writeLine('${_indentStr()}binary(${node.operator})');
    _indent();
    node.left.accept(this);
    node.right.accept(this);
    _dedent();
    return '';
  }

  @override
  String visitUnaryOp(UnaryExpression node) {
    _writeLine('${_indentStr()}unary(${node.operator})');
    _indent();
    node.operand.accept(this);
    _dedent();
    return '';
  }

  @override
  String visitIdentifier(IdentifierExpression node) {
    _writeLine('${_indentStr()}identifier(${node.identifier})');
    return '';
  }

  @override
  String visitLiteral(LiteralExpression node) {
    _writeLine('${_indentStr()}literal(${node.value})');
    return '';
  }

  @override
  String visitModuleInstantiation(ModuleInstantiation node) {
    _writeLine(
        '${_indentStr()}instantiate ${node.moduleName} as ${node.instanceName}');
    _indent();
    for (final conn in node.portConnections) {
      _writeLine('${_indentStr()}port ${conn.portName}');
    }
    _dedent();
    return '';
  }

  @override
  String visitGenerateBlock(GenerateBlock node) {
    _writeLine('${_indentStr()}generate');
    _indent();
    for (final item in node.items) {
      item.accept(this);
    }
    _dedent();
    _writeLine('${_indentStr()}endgenerate');
    return '';
  }

  /// Resets the printer state.
  void reset() {
    _buffer.clear();
    _indentLevel = 0;
  }
}
