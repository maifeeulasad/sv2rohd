// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

import 'package:test/test.dart';
import 'package:sv2rohd/sv2rohd.dart';

void main() {
  group('Symbol', () {
    test('creates port symbol correctly', () {
      final scope = Scope(name: 'test', kind: ScopeKind.module);
      final symbol = Symbol(
        name: 'clk',
        kind: SymbolKind.port,
        definitionLocation: SourceRange.point(SourceLocation.dummy()),
        definedInScope: scope,
        portDirection: PortDirection.input,
      );

      expect(symbol.name, 'clk');
      expect(symbol.kind, SymbolKind.port);
      expect(symbol.portDirection, PortDirection.input);
    });

    test('creates signal symbol correctly', () {
      final scope = Scope(name: 'test', kind: ScopeKind.module);
      final symbol = Symbol(
        name: 'data_bus',
        kind: SymbolKind.signal,
        definitionLocation: SourceRange.point(SourceLocation.dummy()),
        definedInScope: scope,
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

      final symbol = Symbol(
        name: 'test_signal',
        kind: SymbolKind.signal,
        definitionLocation: SourceRange.point(SourceLocation.dummy()),
        definedInScope: scope,
      );

      scope.define('test_signal', symbol);

      final resolved = scope.lookup('test_signal');
      expect(resolved, isNotNull);
      expect(resolved!.first.name, 'test_signal');
    });

    test('returns null for unresolved symbols', () {
      final scope = Scope(
        name: 'test_module',
        kind: ScopeKind.module,
      );

      final resolved = scope.lookup('non_existent');
      expect(resolved, isNull);
    });
  });

  group('SymbolTable', () {
    test('creates empty symbol table', () {
      final table = SymbolTable();
      expect(table.currentScope, isNull);
    });

    test('enters and exits scopes', () {
      final table = SymbolTable();
      table.pushScope('outer', ScopeKind.module);
      expect(table.currentScope?.name, 'outer');

      table.pushScope('inner', ScopeKind.function);
      expect(table.currentScope?.name, 'inner');

      table.popScope();
      expect(table.currentScope?.name, 'outer');
    });

    test('defines and retrieves symbols', () {
      final table = SymbolTable();
      table.pushScope('test', ScopeKind.module);

      final scope = table.currentScope!;
      final symbol = Symbol(
        name: 'my_signal',
        kind: SymbolKind.signal,
        definitionLocation: SourceRange.point(SourceLocation.dummy()),
        definedInScope: scope,
      );

      table.define('my_signal', symbol);
      final resolved = table.lookup('my_signal');

      expect(resolved, isNotNull);
      expect(resolved!.first.name, 'my_signal');
    });
  });

  group('AnalysisError', () {
    test('creates error with message', () {
      final error = AnalysisError(
        message: 'Test error',
        location: SourceRange.point(SourceLocation.dummy()),
        code: 'E001',
      );

      expect(error.message, 'Test error');
      expect(error.code, 'E001');
    });

    test('creates warning with message', () {
      final warning = AnalysisError(
        message: 'Test warning',
        location: SourceRange.point(SourceLocation.dummy()),
        code: 'W001',
      );

      expect(warning.message, 'Test warning');
      expect(warning.code, 'W001');
    });
  });

  group('TypeInfo', () {
    test('creates integer type info', () {
      final typeInfo = TypeInfo.integer();
      expect(typeInfo.name, 'integer');
      expect(typeInfo.width, 32);
    });

    test('creates logic type info', () {
      final typeInfo = TypeInfo.logic(8);
      expect(typeInfo.name, 'logic');
      expect(typeInfo.width, 8);
    });

    test('creates bit type info', () {
      final typeInfo = TypeInfo.bit(16);
      expect(typeInfo.name, 'bit');
      expect(typeInfo.width, 16);
    });

    test('creates real type info', () {
      final typeInfo = TypeInfo.real();
      expect(typeInfo.name, 'real');
    });

    test('type compatibility check for matching widths', () {
      final typeA = TypeInfo.logic(8);
      final typeB = TypeInfo.logic(8);

      expect(typeA.canAssignTo(typeB), true);
    });

    test('type compatibility check for narrowing assignment', () {
      final typeA = TypeInfo.logic(16);
      final typeB = TypeInfo.logic(8);

      expect(typeA.canAssignTo(typeB), false);
    });

    test('integer and logic are same when compatible', () {
      final intType = TypeInfo.integer();
      final logicType = TypeInfo.logic(32);

      expect(intType.canAssignTo(logicType), true);
    });
  });

  group('SemanticAnalyzer', () {
    late DiagnosticCollector diagnostics;
    late SemanticAnalyzer analyzer;

    setUp(() {
      diagnostics = DiagnosticCollector();
      analyzer = SemanticAnalyzer(diagnostics: diagnostics);
    });

    test('analyzes valid module', () {
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
            signalType: SignalType.reg,
          ),
        ],
      );

      final result = analyzer.analyzeModule(module);

      expect(result.errors, isEmpty);
    });

    test('analyzes module with parameters', () {
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

      expect(result.errors, isEmpty);
    });

    test('warns on undeclared signal usage in continuous assignment', () {
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

      expect(result.errors, isEmpty);
      expect(
        result.warnings.where((warning) => warning.code == 'SEM002'),
        isNotEmpty,
      );
    });
  });

  group('TypeAnalyzer', () {
    late TypeAnalyzer typeAnalyzer;

    setUp(() {
      typeAnalyzer = TypeAnalyzer(diagnostics: DiagnosticCollector());
    });

    test('infers signal types from a declaration', () {
      final signal = SignalDeclaration(
        location: SourceLocation.dummy(),
        name: 'internal_bus',
        signalType: SignalType.logic,
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

      final typeInfo = typeAnalyzer.getSignalType(signal);

      expect(typeInfo.name, 'logic');
      expect(typeInfo.width, 16);
    });

    test('infers expression types from arithmetic', () {
      final expr = BinaryExpression(
        location: SourceLocation.dummy(),
        left: LiteralExpression(
          location: SourceLocation.dummy(),
          value: 7,
          kind: LiteralKind.integer,
        ),
        operator: BinaryOperator.add,
        right: LiteralExpression(
          location: SourceLocation.dummy(),
          value: 1,
          kind: LiteralKind.integer,
        ),
      );

      final typeInfo = typeAnalyzer.getExpressionType(expr);

      expect(typeInfo.name, 'logic');
      expect(typeInfo.width, 3);
    });

    test('checks assignment compatibility by width', () {
      final target = LiteralExpression(
        location: SourceLocation.dummy(),
        value: List<bool>.filled(8, false),
        kind: LiteralKind.bitVector,
      );
      final widerValue = LiteralExpression(
        location: SourceLocation.dummy(),
        value: List<bool>.filled(16, true),
        kind: LiteralKind.bitVector,
      );

      expect(typeAnalyzer.checkAssignment(target, widerValue), false);
      expect(typeAnalyzer.checkAssignment(target, target), true);
    });
  });

  group('ExpressionAnalyzer', () {
    late ExpressionAnalyzer exprAnalyzer;
    late TypeAnalyzer typeAnalyzer;

    setUp(() {
      typeAnalyzer = TypeAnalyzer(diagnostics: DiagnosticCollector());
      exprAnalyzer = ExpressionAnalyzer(typeAnalyzer: typeAnalyzer);
    });

    test('evaluates constant integer literal', () {
      final literal = LiteralExpression(
        location: SourceLocation.dummy(),
        value: 42,
        kind: LiteralKind.integer,
      );

      final info = exprAnalyzer.analyze(literal);
      expect(info.isConstant, true);
      expect(info.constValue, 42);
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
          value: 32,
          kind: LiteralKind.integer,
        ),
      );

      final info = exprAnalyzer.analyze(expr);
      expect(info.isConstant, true);
      expect(info.constValue, 42);
    });

    test('identifies non-constant identifier expressions', () {
      final expr = IdentifierExpression(
        location: SourceLocation.dummy(),
        identifier: 'signal_a',
      );

      final info = exprAnalyzer.analyze(expr);
      expect(info.isConstant, false);
      expect(info.referencedSignals, contains('signal_a')); 
    });

    test('evaluates parameter references when provided', () {
      exprAnalyzer.setParameter('WIDTH', 8);

      final expr = IdentifierExpression(
        location: SourceLocation.dummy(),
        identifier: 'WIDTH',
      );

      final info = exprAnalyzer.analyze(expr);
      expect(info.isConstant, true);
      expect(info.constValue, 8);
    });
  });
}
