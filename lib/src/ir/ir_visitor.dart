// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

import 'ir_node.dart';
import 'expression_ir.dart';
import 'statement_ir.dart';
import 'module_ir.dart';

/// Base visitor class for IR nodes.
abstract class IrVisitor<T> {
  T visitModule(ModuleDeclaration node);
  T visitPort(PortDeclaration node);
  T visitSignal(SignalDeclaration node);
  T visitParameter(ParameterDeclaration node);
  T visitExpression(IrExpression node);
  T visitBinaryOp(BinaryExpression node);
  T visitUnaryOp(UnaryExpression node);
  T visitIdentifier(IdentifierExpression node);
  T visitLiteral(LiteralExpression node);
  T visitStatement(IrStatement node);
  T visitAssignment(AssignmentStatement node);
  T visitIfStatement(IfStatement node);
  T visitCaseStatement(CaseStatement node);
  T visitForLoop(ForLoopStatement node);
  T visitWhileLoop(WhileLoopStatement node);
  T visitModuleInstantiation(ModuleInstantiation node);
  T visitGenerateBlock(GenerateBlock node);
}

/// Default visitor that traverses the IR without modification.
class DefaultIrVisitor<T> implements IrVisitor<T?> {
  @override
  T? visitModule(ModuleDeclaration node) => null;

  @override
  T? visitPort(PortDeclaration node) => null;

  @override
  T? visitSignal(SignalDeclaration node) => null;

  @override
  T? visitParameter(ParameterDeclaration node) => null;

  @override
  T? visitExpression(IrExpression node) {
    for (final child in node.children) {
      if (child is IrExpression) {
        child.accept(this);
      }
    }
    return null;
  }

  @override
  T? visitBinaryOp(BinaryExpression node) {
    node.left.accept(this);
    node.right.accept(this);
    return null;
  }

  @override
  T? visitUnaryOp(UnaryExpression node) {
    node.operand.accept(this);
    return null;
  }

  @override
  T? visitIdentifier(IdentifierExpression node) => null;

  @override
  T? visitLiteral(LiteralExpression node) => null;

  @override
  T? visitStatement(IrStatement node) {
    for (final child in node.children) {
      if (child is IrStatement) {
        child.accept(this);
      } else if (child is IrExpression) {
        child.accept(this);
      }
    }
    return null;
  }

  @override
  T? visitAssignment(AssignmentStatement node) {
    node.target.accept(this);
    node.value.accept(this);
    return null;
  }

  @override
  T? visitIfStatement(IfStatement node) {
    node.condition.accept(this);
    node.thenBranch.accept(this);
    node.elseBranch?.accept(this);
    return null;
  }

  @override
  T? visitCaseStatement(CaseStatement node) {
    node.expression.accept(this);
    for (final item in node.items) {
      for (final value in item.values) {
        value.accept(this);
      }
      item.statement?.accept(this);
    }
    return null;
  }

  @override
  T? visitForLoop(ForLoopStatement node) {
    node.initialization?.accept(this);
    node.condition?.accept(this);
    node.step?.accept(this);
    node.body.accept(this);
    return null;
  }

  @override
  T? visitWhileLoop(WhileLoopStatement node) {
    node.condition.accept(this);
    node.body.accept(this);
    return null;
  }

  @override
  T? visitModuleInstantiation(ModuleInstantiation node) => null;

  @override
  T? visitGenerateBlock(GenerateBlock node) {
    for (final item in node.items) {
      item.accept(this);
    }
    return null;
  }
}
