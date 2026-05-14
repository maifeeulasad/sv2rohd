// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

import '../common/common.dart';
import 'ir_visitor.dart';

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
    required super.location,
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
class VectorWidth extends IrExpression {
  final IrExpression? msb;
  final IrExpression? lsb;

  VectorWidth({
    SourceLocation? location,
    this.msb,
    this.lsb,
  }) : super(location: location ?? SourceLocation.dummy());

  /// Returns true if this is a scalar (no range).
  bool get isScalar => msb == null && lsb == null;

  /// Returns true if this is a packed array.
  bool get isPacked => msb != null && lsb != null;

  @override
  List<IrNode> get children {
    final children = <IrNode>[];
    if (msb != null) children.add(msb!);
    if (lsb != null) children.add(lsb!);
    return children;
  }

  @override
  String get nodeType => 'VectorWidth';

  @override
  T accept<T>(IrVisitor<T> visitor) => visitor.visitExpression(this);
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
