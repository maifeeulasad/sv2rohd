// Copyright (C) 2026
// SPDX-License-Identifier: BSD-3-Clause

import '../common/common.dart';
import 'ir_node.dart';
import 'expression_ir.dart';

/// Represents an assignment statement.
class AssignmentStatement extends IrStatement {
  final IrExpression target;
  final IrExpression value;
  final AssignmentType type;

  AssignmentStatement({
    required super.location,
    required this.target,
    required this.value,
    required this.type,
  });

  @override
  List<IrNode> get children => [target, value];

  @override
  String get nodeType => 'AssignmentStatement';

  @override
  T accept<T>(IrVisitor<T> visitor) => visitor.visitAssignment(this);
}

/// Represents an if statement.
class IfStatement extends IrStatement {
  final IrExpression condition;
  final IrStatement thenBranch;
  final IrStatement? elseBranch;

  IfStatement({
    required super.location,
    required this.condition,
    required this.thenBranch,
    this.elseBranch,
  });

  @override
  List<IrNode> get children {
    final children = <IrNode>[condition, thenBranch];
    if (elseBranch != null) children.add(elseBranch!);
    return children;
  }

  @override
  String get nodeType => 'IfStatement';

  @override
  T accept<T>(IrVisitor<T> visitor) => visitor.visitIfStatement(this);
}

/// Represents a case statement.
class CaseStatement extends IrStatement {
  final IrExpression expression;
  final List<CaseItem> items;
  final CaseKind kind;

  CaseStatement({
    required super.location,
    required this.expression,
    required this.items,
    this.kind = CaseKind.normal,
  });

  @override
  List<IrNode> get children => [expression, ...items];

  @override
  String get nodeType => 'CaseStatement';

  @override
  T accept<T>(IrVisitor<T> visitor) => visitor.visitCaseStatement(this);
}

/// Case statement kinds.
enum CaseKind {
  normal,
  x,
  z,
}

/// Represents a case item.
class CaseItem extends IrNode {
  final List<IrExpression> values;
  final IrStatement? statement;

  CaseItem({
    required super.location,
    required this.values,
    this.statement,
  });

  @override
  List<IrNode> get children {
    final children = values.toList();
    if (statement != null) children.add(statement!);
    return children;
  }

  @override
  String get nodeType => 'CaseItem';

  @override
  T accept<T>(IrVisitor<T> visitor) => visitor.visitStatement(this);
}

/// Represents a for loop statement.
class ForLoopStatement extends IrStatement {
  final IrStatement? initialization;
  final IrExpression? condition;
  final IrStatement? step;
  final IrStatement body;

  ForLoopStatement({
    required super.location,
    this.initialization,
    this.condition,
    this.step,
    required this.body,
  });

  @override
  List<IrNode> get children {
    final children = <IrNode>[];
    if (initialization != null) children.add(initialization!);
    if (condition != null) children.add(condition!);
    if (step != null) children.add(step!);
    children.add(body);
    return children;
  }

  @override
  String get nodeType => 'ForLoopStatement';

  @override
  T accept<T>(IrVisitor<T> visitor) => visitor.visitForLoop(this);
}

/// Represents a while loop statement.
class WhileLoopStatement extends IrStatement {
  final IrExpression condition;
  final IrStatement body;

  WhileLoopStatement({
    required super.location,
    required this.condition,
    required this.body,
  });

  @override
  List<IrNode> get children => [condition, body];

  @override
  String get nodeType => 'WhileLoopStatement';

  @override
  T accept<T>(IrVisitor<T> visitor) => visitor.visitWhileLoop(this);
}

/// Represents a repeat loop statement.
class RepeatLoopStatement extends IrStatement {
  final IrExpression count;
  final IrStatement body;

  RepeatLoopStatement({
    required super.location,
    required this.count,
    required this.body,
  });

  @override
  List<IrNode> get children => [count, body];

  @override
  String get nodeType => 'RepeatLoopStatement';

  @override
  T accept<T>(IrVisitor<T> visitor) => visitor.visitStatement(this);
}

/// Represents a sequential block.
class SequentialBlock extends IrStatement {
  final String? label;
  final List<IrStatement> statements;

  SequentialBlock({
    required super.location,
    this.label,
    this.statements = const [],
  });

  @override
  List<IrNode> get children => statements;

  @override
  String get nodeType => 'SequentialBlock';

  @override
  T accept<T>(IrVisitor<T> visitor) => visitor.visitStatement(this);
}

/// Represents a disable statement.
class DisableStatement extends IrStatement {
  final String target;

  DisableStatement({
    required super.location,
    required this.target,
  });

  @override
  List<IrNode> get children => [];

  @override
  String get nodeType => 'DisableStatement';

  @override
  T accept<T>(IrVisitor<T> visitor) => visitor.visitStatement(this);
}

/// Represents a return statement.
class ReturnStatement extends IrStatement {
  final IrExpression? value;

  ReturnStatement({
    required super.location,
    this.value,
  });

  @override
  List<IrNode> get children => value != null ? [value!] : [];

  @override
  String get nodeType => 'ReturnStatement';

  @override
  T accept<T>(IrVisitor<T> visitor) => visitor.visitStatement(this);
}

/// Represents a break statement.
class BreakStatement extends IrStatement {
  BreakStatement({required super.location});

  @override
  List<IrNode> get children => [];

  @override
  String get nodeType => 'BreakStatement';

  @override
  T accept<T>(IrVisitor<T> visitor) => visitor.visitStatement(this);
}

/// Represents a continue statement.
class ContinueStatement extends IrStatement {
  ContinueStatement({required super.location});

  @override
  List<IrNode> get children => [];

  @override
  String get nodeType => 'ContinueStatement';

  @override
  T accept<T>(IrVisitor<T> visitor) => visitor.visitStatement(this);
}

/// Represents a wait statement.
class WaitStatement extends IrStatement {
  final IrExpression condition;

  WaitStatement({
    required super.location,
    required this.condition,
  });

  @override
  List<IrNode> get children => [condition];

  @override
  String get nodeType => 'WaitStatement';

  @override
  T accept<T>(IrVisitor<T> visitor) => visitor.visitStatement(this);
}

/// Represents an event trigger statement (e.g., ->event).
class EventTriggerStatement extends IrStatement {
  final String eventName;

  EventTriggerStatement({
    required super.location,
    required this.eventName,
  });

  @override
  List<IrNode> get children => [];

  @override
  String get nodeType => 'EventTriggerStatement';

  @override
  T accept<T>(IrVisitor<T> visitor) => visitor.visitStatement(this);
}

/// Represents an empty statement.
class EmptyStatement extends IrStatement {
  EmptyStatement({required super.location});

  @override
  List<IrNode> get children => [];

  @override
  String get nodeType => 'EmptyStatement';

  @override
  T accept<T>(IrVisitor<T> visitor) => visitor.visitStatement(this);
}