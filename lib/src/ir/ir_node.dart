// Copyright (C) 2026
// SPDX-License-Identifier: BSD-3-Clause

import '../common/common.dart';

/// Base class for all IR nodes.
abstract class IrNode {
  /// The source location of this node.
  final SourceLocation location;

  /// Creates a new IR node.
  IrNode({required this.location});

  /// Accepts a visitor.
  T accept<T>(IrVisitor<T> visitor);

  /// Returns a list of child nodes.
  List<IrNode> get children;

  /// Returns the name of this node type.
  String get nodeType;
}

/// Base class for declaration nodes.
abstract class IrDeclaration extends IrNode {
  final String name;

  IrDeclaration({
    required this.location,
    required this.name,
  });
}

/// Base class for expression nodes.
abstract class IrExpression extends IrNode {
  IrExpression({required super.location});
}

/// Base class for statement nodes.
abstract class IrStatement extends IrNode {
  IrStatement({required super.location});
}

/// Base class for type nodes.
abstract class IrType extends IrNode {
  IrType({required super.location});
}

/// Represents a vector width.
class VectorWidth {
  final IrExpression? msb;
  final IrExpression? lsb;

  const VectorWidth({this.msb, this.lsb});

  /// Returns true if this is a scalar (no range).
  bool get isScalar => msb == null && lsb == null;

  /// Returns true if this is a packed array.
  bool get isPacked => msb != null && lsb != null;
}

/// Represents a port direction.
enum PortDirection {
  input,
  output,
  inout,
}

/// Represents a signal type.
enum SignalType {
  wire,
  reg,
  logic,
  bit,
}

/// Represents a statement block kind.
enum BlockKind {
  alwaysComb,
  alwaysFf,
  alwaysLatch,
  initial,
  finalBlock,
}

/// Represents an assignment type.
enum AssignmentType {
  blocking,
  nonBlocking,
  continuous,
  procedural,
}

/// Visitor interface for IR nodes.
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