// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

import 'package:test/test.dart';
import 'package:sv2rohd/sv2rohd.dart';

void main() {
  group('ExpressionGenerator', () {
    late ExpressionGenerator exprGen;
    late NamingStrategy namingStrategy;

    setUp(() {
      namingStrategy = const NamingStrategy();
      exprGen = ExpressionGenerator(namingStrategy: namingStrategy);
    });

    test('generates integer literals', () {
      final literal = LiteralExpression(
        location: SourceLocation.dummy(),
        value: 42,
        kind: LiteralKind.integer,
      );
      expect(exprGen.generate(literal), '42');
    });

    test('generates string literals', () {
      final literal = LiteralExpression(
        location: SourceLocation.dummy(),
        value: 'hello',
        kind: LiteralKind.string,
      );
      expect(exprGen.generate(literal), "'hello'");
    });

    test('generates identifiers', () {
      final identifier = IdentifierExpression(
        location: SourceLocation.dummy(),
        identifier: 'data_bus',
      );
      expect(exprGen.generate(identifier), 'dataBus');
    });

    test('generates binary addition', () {
      final binary = BinaryExpression(
        location: SourceLocation.dummy(),
        left: IdentifierExpression(
          location: SourceLocation.dummy(),
          identifier: 'a',
        ),
        operator: BinaryOperator.add,
        right: IdentifierExpression(
          location: SourceLocation.dummy(),
          identifier: 'b',
        ),
      );
      expect(exprGen.generate(binary), '(a + b)');
    });

    test('generates binary equality comparison', () {
      final binary = BinaryExpression(
        location: SourceLocation.dummy(),
        left: IdentifierExpression(
          location: SourceLocation.dummy(),
          identifier: 'a',
        ),
        operator: BinaryOperator.equal,
        right: IdentifierExpression(
          location: SourceLocation.dummy(),
          identifier: 'b',
        ),
      );
      expect(exprGen.generate(binary), 'a.eq(b)');
    });

    test('generates conditional expression', () {
      final conditional = ConditionalExpression(
        location: SourceLocation.dummy(),
        condition: IdentifierExpression(
          location: SourceLocation.dummy(),
          identifier: 'sel',
        ),
        trueExpr: IdentifierExpression(
          location: SourceLocation.dummy(),
          identifier: 'a',
        ),
        falseExpr: IdentifierExpression(
          location: SourceLocation.dummy(),
          identifier: 'b',
        ),
      );
      expect(exprGen.generate(conditional), 'mux(sel, a, b)');
    });

    test('generates concatenation', () {
      final concat = ConcatenationExpression(
        location: SourceLocation.dummy(),
        expressions: [
          IdentifierExpression(
            location: SourceLocation.dummy(),
            identifier: 'a',
          ),
          IdentifierExpression(
            location: SourceLocation.dummy(),
            identifier: 'b',
          ),
        ],
      );
      expect(exprGen.generate(concat), '[a, b].swizzle()');
    });
  });

  group('NamingStrategy', () {
    test('converts snake_case to PascalCase', () {
      const strategy = NamingStrategy();
      expect(strategy.toClassName('module_name'), 'ModuleName');
      expect(strategy.toClassName('data_bus'), 'DataBus');
      expect(strategy.toClassName('simple'), 'Simple');
    });

    test('converts snake_case to camelCase', () {
      const strategy = NamingStrategy();
      expect(strategy.toCamelCase('module_name'), 'moduleName');
      expect(strategy.toCamelCase('data_bus'), 'dataBus');
      expect(strategy.toCamelCase('simple'), 'simple');
    });

    test('handles empty strings', () {
      const strategy = NamingStrategy();
      expect(strategy.toClassName(''), '');
      expect(strategy.toCamelCase(''), '');
    });

    test('handles single word', () {
      const strategy = NamingStrategy();
      expect(strategy.toClassName('foo'), 'Foo');
      expect(strategy.toCamelCase('foo'), 'foo');
    });

    test('escapes Dart reserved words in camelCase names', () {
      const strategy = NamingStrategy();
      expect(strategy.toCamelCase('in'), 'in_');
      expect(strategy.toCamelCase('is'), 'is_');
      expect(strategy.toCamelCase('switch'), 'switch_');
      expect(strategy.toCamelCase('new'), 'new_');
      // Non-keywords are untouched.
      expect(strategy.toCamelCase('input'), 'input');
      expect(strategy.toCamelCase('data'), 'data');
    });

    test('escapes the one PascalCase-shaped reserved word (Function)', () {
      const strategy = NamingStrategy();
      expect(strategy.toClassName('function'), 'Function_');
      expect(strategy.toClassName('func'), 'Func');
    });
  });

  group('SignalGenerator', () {
    late SignalGenerator signalGen;
    late NamingStrategy namingStrategy;

    setUp(() {
      namingStrategy = const NamingStrategy();
      signalGen = SignalGenerator(namingStrategy: namingStrategy);
    });

    test('generates simple signal', () {
      final signal = SignalDeclaration(
        location: SourceLocation.dummy(),
        name: 'data_out',
        signalType: SignalType.logic,
      );
      final buffer = StringBuffer();
      signalGen.generateSignal(buffer, signal);
      expect(buffer.toString().contains('dataOut'), true);
    });

    test('generates signal with width', () {
      final signal = SignalDeclaration(
        location: SourceLocation.dummy(),
        name: 'data_bus',
        signalType: SignalType.logic,
        width: VectorWidth(
          location: SourceLocation.dummy(),
          msb: LiteralExpression(
            location: SourceLocation.dummy(),
            value: 7,
            kind: LiteralKind.integer,
          ),
          lsb: LiteralExpression(
            location: SourceLocation.dummy(),
            value: 0,
            kind: LiteralKind.integer,
          ),
        ),
      );
      final buffer = StringBuffer();
      signalGen.generateSignal(buffer, signal);
      expect(buffer.toString().contains('width: 8'), true);
    });
  });

  group('ModuleGenerator', () {
    late ModuleGenerator moduleGen;
    late NamingStrategy namingStrategy;
    late ExpressionGenerator exprGen;
    late SignalGenerator signalGen;

    setUp(() {
      namingStrategy = const NamingStrategy();
      exprGen = ExpressionGenerator(namingStrategy: namingStrategy);
      signalGen = SignalGenerator(namingStrategy: namingStrategy);
      moduleGen = ModuleGenerator(
        exprGen: exprGen,
        signalGen: signalGen,
        namingStrategy: namingStrategy,
      );
    });

    test('generates simple module', () {
      final module = ModuleDeclaration(
        location: SourceLocation.dummy(),
        name: 'simple_module',
        ports: [],
        items: [],
      );
      final result = moduleGen.generate(module);
      expect(result.contains('class SimpleModule extends Module'), true);
    });

    test('generates module with input port', () {
      final module = ModuleDeclaration(
        location: SourceLocation.dummy(),
        name: 'test_module',
        ports: [
          PortDeclaration(
            location: SourceLocation.dummy(),
            name: 'clk',
            direction: PortDirection.input,
          ),
        ],
        items: [],
      );
      final result = moduleGen.generate(module);
      expect(result.contains("addInput('clk'"), true);
    });

    test('generates module with output port', () {
      final module = ModuleDeclaration(
        location: SourceLocation.dummy(),
        name: 'test_module',
        ports: [
          PortDeclaration(
            location: SourceLocation.dummy(),
            name: 'data_out',
            direction: PortDirection.output,
          ),
        ],
        items: [],
      );
      final result = moduleGen.generate(module);
      expect(result.contains("addOutput('data_out'"), true);
    });

    test('generates module with parameters', () {
      final module = ModuleDeclaration(
        location: SourceLocation.dummy(),
        name: 'parameterized_module',
        ports: [],
        parameters: [
          ParameterDeclaration(
            location: SourceLocation.dummy(),
            name: 'width',
            defaultValue: LiteralExpression(
              location: SourceLocation.dummy(),
              value: 8,
              kind: LiteralKind.integer,
            ),
          ),
        ],
        items: [],
      );
      final result = moduleGen.generate(module);
      expect(result.contains('int width = 8'), true);
    });
  });

  group('RohdGenerator', () {
    late RohdGenerator generator;

    setUp(() {
      generator = RohdGenerator();
    });

    test('generates complete module', () {
      final module = ModuleDeclaration(
        location: SourceLocation.dummy(),
        name: 'full_adder',
        ports: [
          PortDeclaration(
            location: SourceLocation.dummy(),
            name: 'a',
            direction: PortDirection.input,
          ),
          PortDeclaration(
            location: SourceLocation.dummy(),
            name: 'b',
            direction: PortDirection.input,
          ),
          PortDeclaration(
            location: SourceLocation.dummy(),
            name: 'sum',
            direction: PortDirection.output,
          ),
        ],
        items: [
          ContinuousAssignment(
            location: SourceLocation.dummy(),
            target: IdentifierExpression(
              location: SourceLocation.dummy(),
              identifier: 'sum',
            ),
            value: BinaryExpression(
              location: SourceLocation.dummy(),
              left: IdentifierExpression(
                location: SourceLocation.dummy(),
                identifier: 'a',
              ),
              operator: BinaryOperator.xor,
              right: IdentifierExpression(
                location: SourceLocation.dummy(),
                identifier: 'b',
              ),
            ),
          ),
        ],
      );

      final result = generator.generate(module);
      expect(result.contains("import 'package:rohd/rohd.dart';"), true);
      expect(result.contains('class FullAdder extends Module'), true);
      expect(result.contains('sum <= (a ^ b)'), true);
    });
  });
}
