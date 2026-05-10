// Copyright (C) 2026
// SPDX-License-Identifier: BSD-3-Clause

import 'package:test/test.dart';
import 'package:sv2rohd/src/common/common.dart';

void main() {
  group('SourceLocation', () {
    test('creates with correct values', () {
      final location = SourceLocation('test.sv', 10, 5, 100);
      expect(location.sourceName, 'test.sv');
      expect(location.line, 10);
      expect(location.column, 5);
      expect(location.offset, 100);
    });

    test('formats correctly', () {
      final location = SourceLocation('test.sv', 10, 5, 100);
      expect(location.formatted, 'test.sv:10:5');
    });
  });

  group('SourceRange', () {
    test('creates with start and end locations', () {
      final start = SourceLocation('test.sv', 1, 1, 0);
      final end = SourceLocation('test.sv', 2, 1, 50);
      final range = SourceRange(start, end);
      expect(range.start, start);
      expect(range.end, end);
    });

    test('contains checks if offset is within range', () {
      final start = SourceLocation('test.sv', 1, 1, 10);
      final end = SourceLocation('test.sv', 1, 10, 50);
      final range = SourceRange(start, end);
      expect(range.contains(30), true);
      expect(range.contains(5), false);
      expect(range.contains(60), false);
    });

    test('overlaps checks if ranges intersect', () {
      final range1 = SourceRange(
        SourceLocation('test.sv', 1, 1, 0),
        SourceLocation('test.sv', 1, 1, 50),
      );
      final range2 = SourceRange(
        SourceLocation('test.sv', 1, 1, 25),
        SourceLocation('test.sv', 1, 1, 75),
      );
      final range3 = SourceRange(
        SourceLocation('test.sv', 1, 1, 60),
        SourceLocation('test.sv', 1, 1, 100),
      );

      expect(range1.overlaps(range2), true);
      expect(range1.overlaps(range3), false);
    });
  });

  group('Diagnostic', () {
    test('creates info diagnostic', () {
      final diag = Diagnostic.info('Test info', code: 'TEST001');
      expect(diag.severity, DiagnosticSeverity.info);
      expect(diag.message, 'Test info');
      expect(diag.code, 'TEST001');
    });

    test('creates warning diagnostic', () {
      final diag = Diagnostic.warning('Test warning', code: 'TEST002');
      expect(diag.severity, DiagnosticSeverity.warning);
      expect(diag.message, 'Test warning');
    });

    test('creates error diagnostic', () {
      final diag = Diagnostic.error('Test error', code: 'TEST003');
      expect(diag.severity, DiagnosticSeverity.error);
      expect(diag.message, 'Test error');
    });
  });

  group('DiagnosticCollector', () {
    test('collects diagnostics', () {
      final collector = DiagnosticCollector();
      collector.info('Info message');
      collector.warning('Warning message');
      collector.error('Error message');

      expect(collector.diagnostics.length, 3);
      expect(collector.infos.length, 1);
      expect(collector.warnings.length, 1);
      expect(collector.errors.length, 1);
    });

    test('calculates summary correctly', () {
      final collector = DiagnosticCollector();
      collector.info('Info 1');
      collector.info('Info 2');
      collector.warning('Warning 1');
      collector.error('Error 1');
      collector.error('Error 2');

      final summary = collector.summary;
      expect(summary.errors, 2);
      expect(summary.warnings, 1);
      expect(summary.infos, 2);
      expect(summary.total, 5);
    });

    test('checks for errors and warnings', () {
      final collector = DiagnosticCollector();
      expect(collector.hasErrors, false);
      expect(collector.hasWarnings, false);

      collector.warning('Warning');
      expect(collector.hasWarnings, true);
      expect(collector.hasErrors, false);

      collector.error('Error');
      expect(collector.hasErrors, true);
    });
  });

  group('NamingStrategy', () {
    test('converts to valid Dart identifier', () {
      final strategy = NamingStrategy();
      expect(strategy.toDart('my_signal'), 'my_signal');
      expect(strategy.toDart('MY_SIGNAL'), 'MY_SIGNAL');
    });

    test('handles Dart keywords', () {
      final strategy = NamingStrategy();
      expect(strategy.toDart('if'), 'if_');
      expect(strategy.toDart('class'), 'class_');
      expect(strategy.toDart('return'), 'return_');
    });

    test('converts to camelCase', () {
      final strategy = NamingStrategy();
      expect(strategy.toCamelCase('my_signal'), 'mySignal');
      expect(strategy.toCamelCase('MY_SIGNAL'), 'mYSIGNAL');
      expect(strategy.toCamelCase('signal_name_big'), 'signalNameBig');
    });

    test('converts to PascalCase', () {
      final strategy = NamingStrategy();
      expect(strategy.toClassName('my_signal'), 'MySignal');
      expect(strategy.toClassName('myModule'), 'Mymodule');
      expect(strategy.toClassName('signal'), 'Signal');
    });

    test('resolves naming conflicts', () {
      final strategy = NamingStrategy();
      final existing = {'signal', 'signal_1', 'signal_2'};
      expect(strategy.resolveConflict('signal', existing), 'signal_3');
      expect(strategy.resolveConflict('new_signal', existing), 'new_signal');
    });

    test('detects keywords', () {
      final strategy = NamingStrategy();
      expect(strategy.isKeyword('if'), true);
      expect(strategy.isKeyword('class'), true);
      expect(strategy.isKeyword('my_signal'), false);
    });
  });

  group('Utils', () {
    test('validates identifiers', () {
      expect(Utils.isValidIdentifier('valid_name'), true);
      expect(Utils.isValidIdentifier('_private'), true);
      expect(Utils.isValidIdentifier('\$sys'), true);
      expect(Utils.isValidIdentifier('123invalid'), false);
      expect(Utils.isValidIdentifier(''), false);
      expect(Utils.isValidIdentifier('has space'), false);
    });

    test('converts to snake_case', () {
      expect(Utils.toSnakeCase('camelCase'), 'camel_Case');
      expect(Utils.toSnakeCase('PascalCase'), 'pascal_Case');
      expect(Utils.toSnakeCase('snake_case'), 'snake_case');
      expect(Utils.toSnakeCase('ALLCAPS'), 'a_L_L_C_A_P_S');
    });

    test('converts to PascalCase', () {
      expect(Utils.toPascalCase('camelCase'), 'CamelCase');
      expect(Utils.toPascalCase('snake_case'), 'SnakeCase');
      expect(Utils.toPascalCase('ALLCAPS'), 'AlLcApS');
    });

    test('converts to camelCase', () {
      expect(Utils.toCamelCase('camelCase'), 'camelcase');
      expect(Utils.toCamelCase('snake_case'), 'snakeCase');
      expect(Utils.toCamelCase('PascalCase'), 'pascalCase');
    });

    test('checks for blank strings', () {
      expect(Utils.isBlank(null), true);
      expect(Utils.isBlank(''), true);
      expect(Utils.isBlank('   '), true);
      expect(Utils.isBlank('content'), false);
    });

    test('trims safely', () {
      expect(Utils.trim(null), null);
      expect(Utils.trim('  content  '), 'content');
    });

    test('repeats strings', () {
      expect(Utils.repeat('a', 3), 'aaa');
      expect(Utils.repeat('ab', 2), 'abab');
      expect(Utils.repeat('x', 0), '');
      expect(Utils.repeat('x', -1), '');
    });
  });
}