// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

import '../common/common.dart';
import 'ir_node.dart';

/// Represents a binary expression.
class BinaryExpression extends IrExpression {
  final IrExpression left;
  final IrExpression right;
  final BinaryOperator operator;

  BinaryExpression({
    required super.location,
    required this.left,
    required this.right,
    required this.operator,
  });

  @override
  List<IrNode> get children => [left, right];

  @override
  String get nodeType => 'BinaryExpression';

  @override
  T accept<T>(IrVisitor<T> visitor) => visitor.visitBinaryOp(this);
}

/// Binary operators.
enum BinaryOperator {
  add,
  subtract,
  multiply,
  divide,
  modulo,
  and,
  or,
  xor,
  xnor,
  equal,
  notEqual,
  caseEqual,
  caseNotEqual,
  lessThan,
  lessThanOrEqual,
  greaterThan,
  greaterThanOrEqual,
  logicalAnd,
  logicalOr,
  shiftLeft,
  shiftRight,
  arithmeticShiftLeft,
  arithmeticShiftRight,
}

/// Represents a unary expression.
class UnaryExpression extends IrExpression {
  final IrExpression operand;
  final UnaryOperator operator;

  UnaryExpression({
    required super.location,
    required this.operand,
    required this.operator,
  });

  @override
  List<IrNode> get children => [operand];

  @override
  String get nodeType => 'UnaryExpression';

  @override
  T accept<T>(IrVisitor<T> visitor) => visitor.visitUnaryOp(this);
}

/// Unary operators.
enum UnaryOperator {
  plus,
  minus,
  bitwiseNot,
  logicalNot,
}

/// Represents an identifier reference.
class IdentifierExpression extends IrExpression {
  final String identifier;
  final List<VectorWidth> indices;

  IdentifierExpression({
    required super.location,
    required this.identifier,
    this.indices = const [],
  });

  @override
  List<IrNode> get children => indices;

  @override
  String get nodeType => 'IdentifierExpression';

  @override
  T accept<T>(IrVisitor<T> visitor) => visitor.visitIdentifier(this);
}

/// Represents a literal value.
class LiteralExpression extends IrExpression {
  final LiteralKind kind;
  final dynamic value;

  LiteralExpression({
    required super.location,
    required this.kind,
    required this.value,
  });

  @override
  List<IrNode> get children => [];

  @override
  String get nodeType => 'LiteralExpression';

  @override
  T accept<T>(IrVisitor<T> visitor) => visitor.visitLiteral(this);
}

/// Literal kinds.
enum LiteralKind {
  integer,
  real,
  string,
  time,
  bitVector,
}

/// Represents a concatenation expression.
class ConcatenationExpression extends IrExpression {
  final List<IrExpression> expressions;

  ConcatenationExpression({
    required super.location,
    required this.expressions,
  });

  @override
  List<IrNode> get children => expressions;

  @override
  String get nodeType => 'ConcatenationExpression';

  @override
  T accept<T>(IrVisitor<T> visitor) => visitor.visitExpression(this);
}

/// Represents a conditional expression (?:).
class ConditionalExpression extends IrExpression {
  final IrExpression condition;
  final IrExpression trueExpr;
  final IrExpression falseExpr;

  ConditionalExpression({
    required super.location,
    required this.condition,
    required this.trueExpr,
    required this.falseExpr,
  });

  @override
  List<IrNode> get children => [condition, trueExpr, falseExpr];

  @override
  String get nodeType => 'ConditionalExpression';

  @override
  T accept<T>(IrVisitor<T> visitor) => visitor.visitExpression(this);
}

/// Represents a function call expression.
class FunctionCallExpression extends IrExpression {
  final String functionName;
  final List<IrExpression> arguments;

  FunctionCallExpression({
    required super.location,
    required this.functionName,
    this.arguments = const [],
  });

  @override
  List<IrNode> get children => arguments;

  @override
  String get nodeType => 'FunctionCallExpression';

  @override
  T accept<T>(IrVisitor<T> visitor) => visitor.visitExpression(this);
}

/// Represents a part select expression (e.g., signal[7:0]).
class PartSelectExpression extends IrExpression {
  final IrExpression base;
  final IrExpression msb;
  final IrExpression lsb;

  PartSelectExpression({
    required super.location,
    required this.base,
    required this.msb,
    required this.lsb,
  });

  @override
  List<IrNode> get children => [base, msb, lsb];

  @override
  String get nodeType => 'PartSelectExpression';

  @override
  T accept<T>(IrVisitor<T> visitor) => visitor.visitExpression(this);
}

/// Represents an indexed part select (e.g., signal[7]).
class IndexedPartSelectExpression extends IrExpression {
  final IrExpression base;
  final IrExpression index;

  IndexedPartSelectExpression({
    required super.location,
    required this.base,
    required this.index,
  });

  @override
  List<IrNode> get children => [base, index];

  @override
  String get nodeType => 'IndexedPartSelectExpression';

  @override
  T accept<T>(IrVisitor<T> visitor) => visitor.visitExpression(this);
}
