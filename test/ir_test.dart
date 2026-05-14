// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

import 'package:test/test.dart';
import 'package:sv2rohd/src/common/common.dart';
import 'package:sv2rohd/src/ir/ir.dart';
import 'package:sv2rohd/src/analysis/symbol.dart';

void main() {
  group('IrNode', () {
    test('creates with location', () {
      final location =
          SourceLocation(sourceName: 'test.sv', line: 1, column: 1, offset: 0);
      // Test would use concrete implementations
    });
  });

  group('ModuleDeclaration', () {
    test('creates with basic properties', () {
      final location =
          SourceLocation(sourceName: 'test.sv', line: 1, column: 1, offset: 0);
      final module = ModuleDeclaration(
        location: location,
        name: 'TestModule',
        parameters: [],
        ports: [],
        items: [],
      );

      expect(module.name, 'TestModule');
      expect(module.nodeType, 'ModuleDeclaration');
      expect(module.parameters, isEmpty);
      expect(module.ports, isEmpty);
    });

    test('contains children', () {
      final location =
          SourceLocation(sourceName: 'test.sv', line: 1, column: 1, offset: 0);
      final port = PortDeclaration(
        location: location,
        name: 'clk',
        direction: PortDirection.input,
      );

      final module = ModuleDeclaration(
        location: location,
        name: 'TestModule',
        ports: [port],
      );

      expect(module.children, contains(port));
    });
  });

  group('PortDeclaration', () {
    test('creates with direction', () {
      final location =
          SourceLocation(sourceName: 'test.sv', line: 1, column: 1, offset: 0);
      final port = PortDeclaration(
        location: location,
        name: 'data_in',
        direction: PortDirection.input,
      );

      expect(port.name, 'data_in');
      expect(port.direction, PortDirection.input);
    });

    test('creates with width', () {
      final location =
          SourceLocation(sourceName: 'test.sv', line: 1, column: 1, offset: 0);
      final width = VectorWidth(
        msb: LiteralExpression(
          location: location,
          kind: LiteralKind.integer,
          value: 7,
        ),
        lsb: LiteralExpression(
          location: location,
          kind: LiteralKind.integer,
          value: 0,
        ),
      );

      final port = PortDeclaration(
        location: location,
        name: 'data_bus',
        direction: PortDirection.output,
        width: width,
      );

      expect(port.width, isNotNull);
      expect(port.width!.msb, isNotNull);
      expect(port.width!.lsb, isNotNull);
    });
  });

  group('SignalDeclaration', () {
    test('creates with signal type', () {
      final location =
          SourceLocation(sourceName: 'test.sv', line: 1, column: 1, offset: 0);
      final signal = SignalDeclaration(
        location: location,
        name: 'my_wire',
        signalType: SignalType.wire,
      );

      expect(signal.name, 'my_wire');
      expect(signal.signalType, SignalType.wire);
    });

    test('creates with reg type', () {
      final location =
          SourceLocation(sourceName: 'test.sv', line: 1, column: 1, offset: 0);
      final signal = SignalDeclaration(
        location: location,
        name: 'my_reg',
        signalType: SignalType.reg,
      );

      expect(signal.signalType, SignalType.reg);
    });
  });

  group('Expression IR', () {
    test('BinaryExpression creates with operator', () {
      final location =
          SourceLocation(sourceName: 'test.sv', line: 1, column: 1, offset: 0);
      final left = LiteralExpression(
        location: location,
        kind: LiteralKind.integer,
        value: 1,
      );
      final right = LiteralExpression(
        location: location,
        kind: LiteralKind.integer,
        value: 2,
      );

      final binary = BinaryExpression(
        location: location,
        left: left,
        right: right,
        operator: BinaryOperator.add,
      );

      expect(binary.operator, BinaryOperator.add);
      expect(binary.left, left);
      expect(binary.right, right);
    });

    test('UnaryExpression creates with operator', () {
      final location =
          SourceLocation(sourceName: 'test.sv', line: 1, column: 1, offset: 0);
      final operand = IdentifierExpression(
        location: location,
        identifier: 'data',
      );

      final unary = UnaryExpression(
        location: location,
        operand: operand,
        operator: UnaryOperator.bitwiseNot,
      );

      expect(unary.operator, UnaryOperator.bitwiseNot);
      expect(unary.operand, operand);
    });

    test('IdentifierExpression creates', () {
      final location =
          SourceLocation(sourceName: 'test.sv', line: 1, column: 1, offset: 0);
      final id = IdentifierExpression(
        location: location,
        identifier: 'my_signal',
      );

      expect(id.identifier, 'my_signal');
    });

    test('LiteralExpression creates', () {
      final location =
          SourceLocation(sourceName: 'test.sv', line: 1, column: 1, offset: 0);
      final literal = LiteralExpression(
        location: location,
        kind: LiteralKind.integer,
        value: 42,
      );

      expect(literal.value, 42);
      expect(literal.kind, LiteralKind.integer);
    });

    test('ConditionalExpression creates', () {
      final location =
          SourceLocation(sourceName: 'test.sv', line: 1, column: 1, offset: 0);
      final cond = LiteralExpression(
        location: location,
        kind: LiteralKind.integer,
        value: 1,
      );
      final trueExpr = LiteralExpression(
        location: location,
        kind: LiteralKind.integer,
        value: 10,
      );
      final falseExpr = LiteralExpression(
        location: location,
        kind: LiteralKind.integer,
        value: 20,
      );

      final conditional = ConditionalExpression(
        location: location,
        condition: cond,
        trueExpr: trueExpr,
        falseExpr: falseExpr,
      );

      expect(conditional.condition, cond);
      expect(conditional.trueExpr, trueExpr);
      expect(conditional.falseExpr, falseExpr);
    });
  });

  group('Statement IR', () {
    test('AssignmentStatement creates with type', () {
      final location =
          SourceLocation(sourceName: 'test.sv', line: 1, column: 1, offset: 0);
      final target = IdentifierExpression(
        location: location,
        identifier: 'out_sig',
      );
      final value = LiteralExpression(
        location: location,
        kind: LiteralKind.integer,
        value: 1,
      );

      final assignment = AssignmentStatement(
        location: location,
        target: target,
        value: value,
        type: AssignmentType.blocking,
      );

      expect(assignment.type, AssignmentType.blocking);
      expect(assignment.target, target);
      expect(assignment.value, value);
    });

    test('IfStatement creates with branches', () {
      final location =
          SourceLocation(sourceName: 'test.sv', line: 1, column: 1, offset: 0);
      final cond = IdentifierExpression(
        location: location,
        identifier: 'enable',
      );
      final thenStmt = EmptyStatement(location: location);
      final elseStmt = EmptyStatement(location: location);

      final ifStmt = IfStatement(
        location: location,
        condition: cond,
        thenBranch: thenStmt,
        elseBranch: elseStmt,
      );

      expect(ifStmt.condition, cond);
      expect(ifStmt.thenBranch, thenStmt);
      expect(ifStmt.elseBranch, elseStmt);
    });

    test('ForLoopStatement creates', () {
      final location =
          SourceLocation(sourceName: 'test.sv', line: 1, column: 1, offset: 0);
      final body = EmptyStatement(location: location);

      final forLoop = ForLoopStatement(
        location: location,
        body: body,
      );

      expect(forLoop.body, body);
    });
  });

  group('IrPrinter', () {
    test('prints module declaration', () {
      final printer = IrPrinter();
      final location =
          SourceLocation(sourceName: 'test.sv', line: 1, column: 1, offset: 0);

      final module = ModuleDeclaration(
        location: location,
        name: 'TestModule',
        ports: [
          PortDeclaration(
            location: location,
            name: 'clk',
            direction: PortDirection.input,
          ),
        ],
      );

      module.accept(printer);
      expect(printer.output, contains('module TestModule'));
      expect(printer.output, contains('input clk'));
    });
  });

  group('VectorWidth', () {
    test('detects scalar', () {
      final scalar = VectorWidth();
      expect(scalar.isScalar, true);
      expect(scalar.isPacked, false);
    });

    test('detects packed array', () {
      final location =
          SourceLocation(sourceName: 'test.sv', line: 1, column: 1, offset: 0);
      final packed = VectorWidth(
        msb: LiteralExpression(
          location: location,
          kind: LiteralKind.integer,
          value: 7,
        ),
        lsb: LiteralExpression(
          location: location,
          kind: LiteralKind.integer,
          value: 0,
        ),
      );

      expect(packed.isScalar, false);
      expect(packed.isPacked, true);
    });
  });
}
