// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

import 'package:test/test.dart';
import 'package:sv2rohd/sv2rohd.dart';

void main() {
  group('Symbol', () {
    test('creates port symbol correctly', () {
      final port = PortDeclaration(
        location: SourceLocation.dummy(),
        name: 'clk',
        direction: PortDirection.input,
      );

      final symbol = Symbol(
        name: 'clk',
        kind: SymbolKind.port,
        declaration: port,
      );

      expect(symbol.name, 'clk');
      expect(symbol.kind, SymbolKind.port);
      expect(symbol.declaration, port);
    });

    test('creates signal symbol correctly', () {
      final signal = SignalDeclaration(
        location: SourceLocation.dummy(),
        name: 'data_bus',
      );

      final symbol = Symbol(
        name: 'data_bus',
        kind: SymbolKind.signal,
        declaration: signal,
      );

      expect(symbol.name, 'data_bus');
      expect(symbol.kind, SymbolKind.signal);
    });
  });

  group('Scope', () {
    test('creates module scope correctly', () {
      final scope = Scope(
        name: 'test_module',
        kind: ScopeKind.module,
      );

      expect(scope.name, 'test_module');
      expect(scope.kind, ScopeKind.module);
    });

    test('adds and retrieves symbols', () {
      final scope = Scope(
        name: 'test_module',
        kind: ScopeKind.module,
      );

      final signal = SignalDeclaration(
        location: SourceLocation.dummy(),
        name: 'test_signal',
      );

      scope.define(
          'test_signal',
          Symbol(
            name: 'test_signal',
            kind: SymbolKind.signal,
            declaration: signal,
          ));

      final resolved = scope.resolve('test_signal');
      expect(resolved, isNotNull);
      expect(resolved!.name, 'test_signal');
    });

    test('returns null for unresolved symbols', () {
      final scope = Scope(
        name: 'test_module',
        kind: ScopeKind.module,
      );

      final resolved = scope.resolve('non_existent');
      expect(resolved, isNull);
    });
  });

  group('SymbolTable', () {
    test('creates empty symbol table', () {
      final table = SymbolTable();
      expect(table.currentScope, isNotNull);
    });

    test('enters and exits scopes', () {
      final table = SymbolTable();
      table.enterScope('outer', ScopeKind.module);
      expect(table.currentScope?.name, 'outer');

      table.enterScope('inner', ScopeKind.function);
      expect(table.currentScope?.name, 'inner');

      table.exitScope();
      expect(table.currentScope?.name, 'outer');
    });

    test('defines and resolves symbols in current scope', () {
      final table = SymbolTable();

      final signal = SignalDeclaration(
        location: SourceLocation.dummy(),
        name: 'my_signal',
      );

      table.define(
          'my_signal',
          Symbol(
            name: 'my_signal',
            kind: SymbolKind.signal,
            declaration: signal,
          ));

      final resolved = table.resolve('my_signal');
      expect(resolved, isNotNull);
      expect(resolved!.name, 'my_signal');
    });
  });

  group('AnalysisError', () {
    test('creates error with severity.error', () {
      final error = AnalysisError(
        severity: Severity.error,
        message: 'Test error',
        location: SourceLocation.dummy(),
      );

      expect(error.severity, Severity.error);
      expect(error.message, 'Test error');
    });

    test('creates warning with severity.warning', () {
      final warning = AnalysisError(
        severity: Severity.warning,
        message: 'Test warning',
        location: SourceLocation.dummy(),
      );

      expect(warning.severity, Severity.warning);
      expect(warning.message, 'Test warning');
    });
  });

  group('TypeInfo', () {
    test('creates integer type info', () {
      final typeInfo = TypeInfo.integer();
      expect(typeInfo.kind, TypeKind.integer);
      expect(typeInfo.width, 32);
    });

    test('creates logic type info', () {
      final typeInfo = TypeInfo.logic(width: 8);
      expect(typeInfo.kind, TypeKind.logic);
      expect(typeInfo.width, 8);
    });

    test('creates unsigned type info', () {
      final typeInfo = TypeInfo.unsigned(width: 16);
      expect(typeInfo.kind, TypeKind.unsigned);
      expect(typeInfo.width, 16);
    });

    test('creates signed type info', () {
      final typeInfo = TypeInfo.signed(width: 16);
      expect(typeInfo.kind, TypeKind.signed);
      expect(typeInfo.width, 16);
    });

    test('creates real type info', () {
      final typeInfo = TypeInfo.real();
      expect(typeInfo.kind, TypeKind.real);
    });

    test('type compatibility check for matching widths', () {
      final typeA = TypeInfo.logic(width: 8);
      final typeB = TypeInfo.logic(width: 8);

      expect(typeA.isCompatible(typeB), true);
    });

    test('type compatibility check for mismatched widths', () {
      final typeA = TypeInfo.logic(width: 8);
      final typeB = TypeInfo.logic(width: 16);

      expect(typeA.isCompatible(typeB), false);
    });

    test('integer and logic are compatible', () {
      final intType = TypeInfo.integer();
      final logicType = TypeInfo.logic(width: 32);

      expect(intType.isCompatible(logicType), true);
    });
  });

  group('SemanticAnalyzer', () {
    test('analyzes simple module', () {
      final analyzer = SemanticAnalyzer();
      final module = ModuleDeclaration(
        location: SourceLocation.dummy(),
        name: 'test_module',
        ports: [
          PortDeclaration(
            location: SourceLocation.dummy(),
            name: 'clk',
            direction: PortDirection.input,
          ),
          PortDeclaration(
            location: SourceLocation.dummy(),
            name: 'data_out',
            direction: PortDirection.output,
          ),
        ],
        items: [
          SignalDeclaration(
            location: SourceLocation.dummy(),
            name: 'internal_reg',
          ),
        ],
      );

      final result = analyzer.analyzeModule(module);

      expect(result.errors.where((e) => e.severity == Severity.error), isEmpty);
    });

    test('detects undeclared signal usage', () {
      final analyzer = SemanticAnalyzer();
      final module = ModuleDeclaration(
        location: SourceLocation.dummy(),
        name: 'test_module',
        ports: [
          PortDeclaration(
            location: SourceLocation.dummy(),
            name: 'data_in',
            direction: PortDirection.input,
          ),
        ],
        items: [
          ContinuousAssignment(
            location: SourceLocation.dummy(),
            target: IdentifierExpression(
              location: SourceLocation.dummy(),
              identifier: 'undeclared_signal',
            ),
            value: IdentifierExpression(
              location: SourceLocation.dummy(),
              identifier: 'data_in',
            ),
          ),
        ],
      );

      final result = analyzer.analyzeModule(module);

      expect(
        result.errors.where((e) => e.severity == Severity.error),
        isNotEmpty,
      );
    });

    test('analyzes module with parameters', () {
      final analyzer = SemanticAnalyzer();
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

      final result = analyzer.analyzeModule(module);

      expect(result.errors.where((e) => e.severity == Severity.error), isEmpty);
    });
  });

  group('TypeAnalyzer', () {
    late TypeAnalyzer typeAnalyzer;

    setUp(() {
      typeAnalyzer = TypeAnalyzer();
    });

    test('infers port types', () {
      final inputPort = PortDeclaration(
        location: SourceLocation.dummy(),
        name: 'data_in',
        direction: PortDirection.input,
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

      final typeInfo = typeAnalyzer.inferPortType(inputPort);
      expect(typeInfo.width, 8);
    });

    test('infers signal types', () {
      final signal = SignalDeclaration(
        location: SourceLocation.dummy(),
        name: 'internal_bus',
        width: VectorWidth(
          location: SourceLocation.dummy(),
          msb: LiteralExpression(
            location: SourceLocation.dummy(),
            value: 15,
            kind: LiteralKind.integer,
          ),
          lsb: LiteralExpression(
            location: SourceLocation.dummy(),
            value: 0,
            kind: LiteralKind.integer,
          ),
        ),
      );

      final typeInfo = typeAnalyzer.inferSignalType(signal);
      expect(typeInfo.width, 16);
    });

    test('infers binary expression types', () {
      final left = IdentifierExpression(
        location: SourceLocation.dummy(),
        identifier: 'a',
      );
      final right = IdentifierExpression(
        location: SourceLocation.dummy(),
        identifier: 'b',
      );

      final binary = BinaryExpression(
        location: SourceLocation.dummy(),
        left: left,
        operator: BinaryOperator.add,
        right: right,
      );

      // Note: Full width inference requires context from operands
      // This is a simplified test
      final typeInfo = typeAnalyzer.inferExpressionType(binary);
      expect(typeInfo.kind, TypeKind.logic);
    });

    test('checks expression type compatibility', () {
      final typeA = TypeInfo.logic(width: 8);
      final typeB = TypeInfo.logic(width: 8);

      expect(typeAnalyzer.checkCompatibility(typeA, typeB), true);
    });
  });

  group('ExpressionAnalyzer', () {
    late ExpressionAnalyzer exprAnalyzer;

    setUp(() {
      exprAnalyzer = ExpressionAnalyzer();
    });

    test('evaluates constant integer literal', () {
      final literal = LiteralExpression(
        location: SourceLocation.dummy(),
        value: 42,
        kind: LiteralKind.integer,
      );

      final info = exprAnalyzer.analyze(literal);
      expect(info.isConstant, true);
      expect(info.constantValue, 42);
    });

    test('evaluates constant arithmetic expression', () {
      final expr = BinaryExpression(
        location: SourceLocation.dummy(),
        left: LiteralExpression(
          location: SourceLocation.dummy(),
          value: 10,
          kind: LiteralKind.integer,
        ),
        operator: BinaryOperator.add,
        right: LiteralExpression(
          location: SourceLocation.dummy(),
          value: 20,
          kind: LiteralKind.integer,
        ),
      );

      final info = exprAnalyzer.analyze(expr);
      expect(info.isConstant, true);
      expect(info.constantValue, 30);
    });

    test('identifies non-constant expression', () {
      final expr = IdentifierExpression(
        location: SourceLocation.dummy(),
        identifier: 'signal_a',
      );

      final info = exprAnalyzer.analyze(expr);
      expect(info.isConstant, false);
    });

    test('evaluates conditional expression at compile time', () {
      final expr = ConditionalExpression(
        location: SourceLocation.dummy(),
        condition: LiteralExpression(
          location: SourceLocation.dummy(),
          value: 1,
          kind: LiteralKind.integer,
        ),
        trueExpr: LiteralExpression(
          location: SourceLocation.dummy(),
          value: 10,
          kind: LiteralKind.integer,
        ),
        falseExpr: LiteralExpression(
          location: SourceLocation.dummy(),
          value: 20,
          kind: LiteralKind.integer,
        ),
      );

      final info = exprAnalyzer.analyze(expr);
      expect(info.isConstant, true);
      expect(info.constantValue, 10);
    });
  });
}
