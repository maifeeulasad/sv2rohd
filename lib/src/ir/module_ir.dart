// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

import '../analysis/symbol.dart';
import 'ir_node.dart';
import 'ir_visitor.dart';

/// Generate block kinds.
enum GenerateKind {
  ifGenerate,
  forGenerate,
  caseGenerate,
  loopGenerate,
}

/// Represents a module declaration in the IR.
class ModuleDeclaration extends IrNode {
  final String name;
  final List<ParameterDeclaration> parameters;
  final List<PortDeclaration> ports;
  final List<IrNode> items;

  ModuleDeclaration({
    required super.location,
    required this.name,
    this.parameters = const [],
    this.ports = const [],
    this.items = const [],
  });

  @override
  List<IrNode> get children => [...parameters, ...ports, ...items];

  @override
  String get nodeType => 'ModuleDeclaration';

  @override
  T accept<T>(IrVisitor<T> visitor) => visitor.visitModule(this);
}

/// Represents a parameter declaration.
class ParameterDeclaration extends IrDeclaration {
  final IrExpression? defaultValue;
  final IrType? type;

  ParameterDeclaration({
    required super.location,
    required super.name,
    this.defaultValue,
    this.type,
  });

  @override
  List<IrNode> get children {
    final children = <IrNode>[];
    if (defaultValue != null) children.add(defaultValue!);
    if (type != null) children.add(type!);
    return children;
  }

  @override
  String get nodeType => 'ParameterDeclaration';

  @override
  T accept<T>(IrVisitor<T> visitor) => visitor.visitParameter(this);
}

/// Represents a port declaration.
class PortDeclaration extends IrDeclaration {
  final PortDirection direction;
  final IrType? type;
  final VectorWidth? width;

  PortDeclaration({
    required super.location,
    required super.name,
    required this.direction,
    this.type,
    this.width,
  });

  @override
  List<IrNode> get children {
    final children = <IrNode>[];
    if (type != null) children.add(type!);
    if (width != null && width!.msb != null) children.add(width!.msb!);
    if (width != null && width!.lsb != null) children.add(width!.lsb!);
    return children;
  }

  @override
  String get nodeType => 'PortDeclaration';

  @override
  T accept<T>(IrVisitor<T> visitor) => visitor.visitPort(this);
}

/// Represents a signal declaration.
class SignalDeclaration extends IrDeclaration {
  final SignalType signalType;
  final IrType? type;
  final VectorWidth? width;
  final IrExpression? initialValue;

  SignalDeclaration({
    required super.location,
    required super.name,
    required this.signalType,
    this.type,
    this.width,
    this.initialValue,
  });

  @override
  List<IrNode> get children {
    final children = <IrNode>[];
    if (type != null) children.add(type!);
    if (width != null && width!.msb != null) children.add(width!.msb!);
    if (width != null && width!.lsb != null) children.add(width!.lsb!);
    if (initialValue != null) children.add(initialValue!);
    return children;
  }

  @override
  String get nodeType => 'SignalDeclaration';

  @override
  T accept<T>(IrVisitor<T> visitor) => visitor.visitSignal(this);
}

/// Represents an always block.
class AlwaysBlock extends IrNode {
  final BlockKind kind;
  final IrStatement body;

  AlwaysBlock({
    required super.location,
    required this.kind,
    required this.body,
  });

  @override
  List<IrNode> get children => [body];

  @override
  String get nodeType => 'AlwaysBlock';

  @override
  T accept<T>(IrVisitor<T> visitor) => body.accept(visitor);
}

/// Represents an initial block.
class InitialBlock extends IrNode {
  final IrStatement body;

  InitialBlock({
    required super.location,
    required this.body,
  });

  @override
  List<IrNode> get children => [body];

  @override
  String get nodeType => 'InitialBlock';

  @override
  T accept<T>(IrVisitor<T> visitor) => body.accept(visitor);
}

/// Represents a continuous assignment.
class ContinuousAssignment extends IrNode {
  final IrExpression target;
  final IrExpression value;
  final List<IrExpression> delays;

  ContinuousAssignment({
    required super.location,
    required this.target,
    required this.value,
    this.delays = const [],
  });

  @override
  List<IrNode> get children => [target, value, ...delays];

  @override
  String get nodeType => 'ContinuousAssignment';

  @override
  T accept<T>(IrVisitor<T> visitor) => visitor.visitExpression(target);
}

/// Represents a module instantiation.
class ModuleInstantiation extends IrNode {
  final String moduleName;
  final String instanceName;
  final List<IrExpression> parameterValues;
  final List<PortConnection> portConnections;

  ModuleInstantiation({
    required super.location,
    required this.moduleName,
    required this.instanceName,
    this.parameterValues = const [],
    this.portConnections = const [],
  });

  @override
  List<IrNode> get children => [...parameterValues, ...portConnections];

  @override
  String get nodeType => 'ModuleInstantiation';

  @override
  T accept<T>(IrVisitor<T> visitor) => visitor.visitModuleInstantiation(this);
}

/// Represents a port connection.
class PortConnection extends IrNode {
  final String portName;
  final IrExpression? value;

  PortConnection({
    required super.location,
    required this.portName,
    this.value,
  });

  @override
  List<IrNode> get children => value != null ? [value!] : [];

  @override
  String get nodeType => 'PortConnection';

  @override
  T accept<T>(IrVisitor<T> visitor) =>
      value != null ? value!.accept(visitor) : (null as T);
}

/// Represents a generate block.
class GenerateBlock extends IrNode {
  final String? label;
  final List<IrNode> items;
  final GenerateKind kind;
  final IrExpression? condition;

  GenerateBlock({
    required super.location,
    this.label,
    this.items = const [],
    this.kind = GenerateKind.loopGenerate,
    this.condition,
  });

  @override
  List<IrNode> get children => items;

  @override
  String get nodeType => 'GenerateBlock';

  @override
  T accept<T>(IrVisitor<T> visitor) => visitor.visitGenerateBlock(this);
}

/// Represents a genvar declaration.
class GenvarDeclaration extends IrDeclaration {
  GenvarDeclaration({
    required super.location,
    required super.name,
  });

  @override
  List<IrNode> get children => [];

  @override
  String get nodeType => 'GenvarDeclaration';

  @override
  T accept<T>(IrVisitor<T> visitor) => null as T;
}

/// Represents a for generate block.
class ForGenerateBlock extends IrNode {
  final IrStatement initialization;
  final IrExpression? condition;
  final IrStatement step;
  final GenerateBlock body;

  ForGenerateBlock({
    required super.location,
    required this.initialization,
    this.condition,
    required this.step,
    required this.body,
  });

  @override
  List<IrNode> get children =>
      [initialization, if (condition != null) condition!, step, body];

  @override
  String get nodeType => 'ForGenerateBlock';

  @override
  T accept<T>(IrVisitor<T> visitor) => visitor.visitGenerateBlock(body);
}

/// Represents an if generate block.
class IfGenerateBlock extends IrNode {
  final IrExpression condition;
  final GenerateBlock thenBranch;
  final GenerateBlock? elseBranch;

  IfGenerateBlock({
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
  String get nodeType => 'IfGenerateBlock';

  @override
  T accept<T>(IrVisitor<T> visitor) => visitor.visitGenerateBlock(thenBranch);
}

/// Represents a case generate block.
class CaseGenerateBlock extends IrNode {
  final IrExpression expression;
  final List<GenerateCaseItem> items;

  CaseGenerateBlock({
    required super.location,
    required this.expression,
    required this.items,
  });

  @override
  List<IrNode> get children => [expression, ...items];

  @override
  String get nodeType => 'CaseGenerateBlock';

  @override
  T accept<T>(IrVisitor<T> visitor) => visitor.visitExpression(expression);
}

/// Represents a case item in generate.
class GenerateCaseItem extends IrNode {
  final List<IrExpression> values;
  final GenerateBlock body;

  GenerateCaseItem({
    required super.location,
    required this.values,
    required this.body,
  });

  @override
  List<IrNode> get children => [...values, body];

  @override
  String get nodeType => 'GenerateCaseItem';

  @override
  T accept<T>(IrVisitor<T> visitor) => visitor.visitGenerateBlock(body);
}

/// Represents a function declaration.
class FunctionDeclaration extends IrNode {
  final String name;
  final IrType? returnType;
  final List<FunctionPort> ports;
  final List<IrNode> items;

  FunctionDeclaration({
    required super.location,
    required this.name,
    this.returnType,
    this.ports = const [],
    this.items = const [],
  });

  @override
  List<IrNode> get children =>
      [if (returnType != null) returnType!, ...ports, ...items];

  @override
  String get nodeType => 'FunctionDeclaration';

  @override
  T accept<T>(IrVisitor<T> visitor) => null as T;
}

/// Represents a function port.
class FunctionPort extends IrNode {
  final String name;
  final PortDirection direction;
  final IrType? type;

  FunctionPort({
    required super.location,
    required this.name,
    required this.direction,
    this.type,
  });

  @override
  List<IrNode> get children => type != null ? [type!] : [];

  @override
  String get nodeType => 'FunctionPort';

  @override
  T accept<T>(IrVisitor<T> visitor) =>
      type != null ? type!.accept(visitor) : (null as T);
}

/// Represents a task declaration.
class TaskDeclaration extends IrNode {
  final String name;
  final List<TaskPort> ports;
  final List<IrNode> items;

  TaskDeclaration({
    required super.location,
    required this.name,
    this.ports = const [],
    this.items = const [],
  });

  @override
  List<IrNode> get children => [...ports, ...items];

  @override
  String get nodeType => 'TaskDeclaration';

  @override
  T accept<T>(IrVisitor<T> visitor) => null as T;
}

/// Represents a task port.
class TaskPort extends IrNode {
  final String name;
  final PortDirection direction;
  final IrType? type;

  TaskPort({
    required super.location,
    required this.name,
    required this.direction,
    this.type,
  });

  @override
  List<IrNode> get children => type != null ? [type!] : [];

  @override
  String get nodeType => 'TaskPort';

  @override
  T accept<T>(IrVisitor<T> visitor) =>
      type != null ? type!.accept(visitor) : (null as T);
}

/// Represents a raw code snippet emitted by the frontend when a construct is
/// not yet modeled as a dedicated IR node.
/// todo: recheck @maifeeulasad
class RawCodeItem extends IrNode {
  final String code;

  RawCodeItem({
    required super.location,
    required this.code,
  });

  @override
  List<IrNode> get children => [];

  @override
  String get nodeType => 'RawCodeItem';

  @override
  T accept<T>(IrVisitor<T> visitor) => visitor.visitRawCode(this);
}
