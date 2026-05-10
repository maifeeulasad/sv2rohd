// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

import '../ir/ir.dart';
import 'expression_generator.dart';
import 'naming_strategy.dart';

/// Generates ROHD statements from IR statements.
///
/// Handles:
/// - Assignment statements (blocking, non-blocking)
/// - Conditional statements (if-else)
/// - Case statements
/// - Loop statements (for, while)
/// - Sequential blocks
/// - Return statements
class StatementGenerator {
  final ExpressionGenerator exprGen;
  final NamingStrategy namingStrategy;
  int _indentLevel = 0;

  StatementGenerator({
    required this.exprGen,
    required this.namingStrategy,
  });

  /// Generate a statement.
  void generate(StringBuffer buffer, IrStatement stmt) {
    if (stmt is AssignmentStatement) {
      _generateAssignment(buffer, stmt);
    } else if (stmt is IfStatement) {
      _generateIfStatement(buffer, stmt);
    } else if (stmt is CaseStatement) {
      _generateCaseStatement(buffer, stmt);
    } else if (stmt is ForLoopStatement) {
      _generateForLoop(buffer, stmt);
    } else if (stmt is WhileLoopStatement) {
      _generateWhileLoop(buffer, stmt);
    } else if (stmt is SequentialBlock) {
      _generateSequentialBlock(buffer, stmt);
    } else if (stmt is ReturnStatement) {
      _generateReturnStatement(buffer, stmt);
    } else if (stmt is EmptyStatement) {
      // Skip empty statements
    } else if (stmt is DelayStatement) {
      _generateDelayStatement(buffer, stmt);
    } else if (stmt is EventStatement) {
      _generateEventStatement(buffer, stmt);
    } else if (stmt is VariableDeclarationStatement) {
      _generateVariableDeclaration(buffer, stmt);
    } else if (stmt is BlockingAssignmentStatement) {
      _generateBlockingAssignment(buffer, stmt);
    } else if (stmt is NonBlockingAssignmentStatement) {
      _generateNonBlockingAssignment(buffer, stmt);
    }
  }

  void _generateAssignment(StringBuffer buffer, AssignmentStatement stmt) {
    final target = exprGen.generate(stmt.target);
    final value = exprGen.generate(stmt.value);

    switch (stmt.type) {
      case AssignmentType.blocking:
        _writeLine(buffer, '$target < $value;');
        break;
      case AssignmentType.nonBlocking:
        _writeLine(buffer, '$target <= $value;');
        break;
      case AssignmentType.continuous:
        _writeLine(buffer, '$target <= $value;');
        break;
      case AssignmentType.procedural:
        _writeLine(buffer, '$target < $value;');
        break;
    }
  }

  void _generateBlockingAssignment(
    StringBuffer buffer,
    BlockingAssignmentStatement stmt,
  ) {
    final target = exprGen.generate(stmt.target);
    final value = exprGen.generate(stmt.value);
    _writeLine(buffer, '$target < $value;');
  }

  void _generateNonBlockingAssignment(
    StringBuffer buffer,
    NonBlockingAssignmentStatement stmt,
  ) {
    final target = exprGen.generate(stmt.target);
    final value = exprGen.generate(stmt.value);
    _writeLine(buffer, '$target <= $value;');
  }

  void _generateIfStatement(StringBuffer buffer, IfStatement stmt) {
    final condition = exprGen.generate(stmt.condition);

    _write(buffer, 'If($condition, then: [');
    _indent();

    for (final s in _flattenBlock(stmt.thenBranch)) {
      generate(buffer, s);
    }

    _dedent();
    _write(buffer, ']');

    if (stmt.elseBranch != null) {
      _write(buffer, ', else: [');
      _indent();

      for (final s in _flattenBlock(stmt.elseBranch!)) {
        generate(buffer, s);
      }

      _dedent();
      _write(buffer, ']');
    }

    _writeLine(buffer, '),');
  }

  void _generateCaseStatement(StringBuffer buffer, CaseStatement stmt) {
    final selector = exprGen.generate(stmt.expression);

    _writeLine(buffer, 'Case($selector, [');

    _indent();

    for (final item in stmt.items) {
      _generateCaseItem(buffer, item);
    }

    // Handle default case
    if (stmt.defaultCase != null) {
      _writeLine(buffer, 'CaseItem(null, ['); // Default case
      _indent();
      for (final s in _flattenBlock(stmt.defaultCase!)) {
        generate(buffer, s);
      }
      _dedent();
      _writeLine(buffer, ']),');
    }

    _dedent();
    _writeLine(buffer, ']),');
  }

  void _generateCaseItem(StringBuffer buffer, CaseItem item) {
    for (final value in item.values) {
      final val = exprGen.generate(value);
      _writeLine(buffer, 'CaseItem($val, [');
      _indent();

      if (item.statement != null) {
        for (final s in _flattenBlock(item.statement!)) {
          generate(buffer, s);
        }
      }

      _dedent();
      _writeLine(buffer, ']),');
    }
  }

  void _generateForLoop(StringBuffer buffer, ForLoopStatement stmt) {
    // ROHD supports for loops in combinational logic via `Combinational` or `Sequential`
    // We use the built-in for loop syntax

    // Extract variable name from initialization if present
    String varName = 'i';
    String initialValue = '0';

    if (stmt.initialization is AssignmentStatement) {
      final initAssign = stmt.initialization as AssignmentStatement;
      if (initAssign.target is IdentifierExpression) {
        varName = namingStrategy.toCamelCase(
          (initAssign.target as IdentifierExpression).identifier,
        );
      }
      initialValue = exprGen.generate(initAssign.value);
    }

    final condition =
        stmt.condition != null ? exprGen.generate(stmt.condition!) : 'true';
    final step = stmt.step != null ? _extractStep(stmt.step!) : '$varName + 1';

    _writeLine(
        buffer, 'for (var $varName = $initialValue; $condition; $step) {');
    _indent();
    generate(buffer, stmt.body);
    _dedent();
    _writeLine(buffer, '}');
  }

  String _extractStep(IrStatement step) {
    // Extract step expression from step statement
    // This handles the common case of `i = i + 1` or `i++`
    if (step is AssignmentStatement) {
      final value = exprGen.generate(step.value);
      return value;
    }
    return '$varName + 1';
  }

  void _generateWhileLoop(StringBuffer buffer, WhileLoopStatement stmt) {
    final condition =
        exprGen.generate(stmt.condition);

    _writeLine(buffer, 'while ($condition) {');
    _indent();
    generate(buffer, stmt.body);
    _dedent();
    _writeLine(buffer, '}');
  }

  void _generateSequentialBlock(StringBuffer buffer, SequentialBlock stmt) {
    _writeLine(buffer, '{');
    _indent();

    for (final s in stmt.statements) {
      generate(buffer, s);
    }

    _dedent();
    _writeLine(buffer, '}');
  }

  void _generateReturnStatement(StringBuffer buffer, ReturnStatement stmt) {
    if (stmt.value != null) {
      final value = exprGen.generate(stmt.value!);
      _writeLine(buffer, 'return $value;');
    } else {
      _writeLine(buffer, 'return;');
    }
  }

  void _generateDelayStatement(StringBuffer buffer, DelayStatement stmt) {
    // ROHD uses Simulator for delays in testbenches
    if (stmt.delay != null) {
      final delay = exprGen.generate(stmt.delay!);
      _writeLine(buffer, '// delay #$delay');
      // Could generate: Simulator.setMaxSimTime(...) or similar
    }
  }

  void _generateEventStatement(StringBuffer buffer, EventStatement stmt) {
    // Event statements (wait, @) - typically testbench only
    if (stmt.expression != null) {
      final event = exprGen.generate(stmt.expression!);
      _writeLine(buffer, '// event @( $event )');
    }
  }

  void _generateVariableDeclaration(
    StringBuffer buffer,
    VariableDeclarationStatement stmt,
  ) {
    // Variable declarations within procedures
    final varName = namingStrategy.toCamelCase(stmt.variableName);
    final width = _getWidth(stmt.width);
    final typeName = stmt.varType ?? 'Logic';

    if (width == 1) {
      _writeLine(buffer,
          'final $varName = $typeName(name: \'${stmt.variableName}\');');
    } else {
      _writeLine(
        buffer,
        'final $varName = $typeName(name: \'${stmt.variableName}\', width: $width);',
      );
    }
  }

  List<IrStatement> _flattenBlock(IrStatement stmt) {
    if (stmt is SequentialBlock) {
      return stmt.statements.expand(_flattenBlock).toList();
    }
    return [stmt];
  }

  int _getWidth(VectorWidth? width) {
    if (width == null) return 1;
    if (width.msb is LiteralExpression && width.lsb is LiteralExpression) {
      final msb = (width.msb as LiteralExpression).value as int;
      final lsb = (width.lsb as LiteralExpression).value as int;
      return (msb - lsb).abs() + 1;
    }
    return 1;
  }

  void _write(StringBuffer buffer, String text) {
    buffer.write(text);
  }

  void _writeLine(StringBuffer buffer, [String text = '']) {
    buffer.writeln('${'  ' * _indentLevel}$text');
  }

  void _indent() {
    _indentLevel++;
  }

  void _dedent() {
    if (_indentLevel > 0) {
      _indentLevel--;
    }
  }
}
