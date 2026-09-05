// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

// Parts of this implementation were generated with LLM assistance and
// reviewed by the maintainer.

import '../common/common.dart';
import '../ir/ir.dart';
import 'expression_generator.dart';
import 'naming_strategy.dart';
import 'width_analyzer.dart';

/// Generates ROHD `Conditional` statements from IR statements.
///
/// Statements are rendered as items of a `Sequential`/`Combinational` list
/// (suffix `,`) or as standalone statements (suffix `;`).
class StatementGenerator {
  final ExpressionGenerator exprGen;
  final NamingStrategy namingStrategy;
  final WidthAnalyzer? widthAnalyzer;
  final DiagnosticCollector? diagnostics;

  StatementGenerator({
    required this.exprGen,
    required this.namingStrategy,
    this.widthAnalyzer,
    this.diagnostics,
  });

  /// Writes [stmt] into [buffer]; kept for backward compatibility.
  void generate(
    StringBuffer buffer,
    IrStatement stmt, {
    bool asListItem = false,
  }) {
    for (final line in lines(stmt, asListItem: asListItem)) {
      buffer.writeln(line);
    }
  }

  /// Renders [stmt] as a list of relative-indented source lines.
  List<String> lines(IrStatement stmt, {required bool asListItem}) {
    final suffix = asListItem ? ',' : ';';

    if (stmt is SequentialBlock) {
      final result = <String>[];
      for (final s in stmt.statements) {
        result.addAll(lines(s, asListItem: asListItem));
      }
      return result;
    }

    if (stmt is AssignmentStatement) {
      if (stmt.type == AssignmentType.continuous) {
        final target = exprGen.generate(stmt.target);
        final logicValue = _requireLogicValue(stmt.target, stmt.value);
        return ['$target <= $logicValue$suffix'];
      }
      final select = _selectAssignmentLines(stmt.target, stmt.value, suffix);
      if (select != null) return select;
      final target = exprGen.generate(stmt.target);
      final value = assignmentValue(stmt.target, stmt.value);
      return ['$target < $value$suffix'];
    }

    if (stmt is BlockingAssignmentStatement) {
      final select = _selectAssignmentLines(stmt.target, stmt.value, suffix);
      if (select != null) return select;
      final target = exprGen.generate(stmt.target);
      return ['$target < ${assignmentValue(stmt.target, stmt.value)}$suffix'];
    }

    if (stmt is NonBlockingAssignmentStatement) {
      final select = _selectAssignmentLines(stmt.target, stmt.value, suffix);
      if (select != null) return select;
      final target = exprGen.generate(stmt.target);
      return ['$target < ${assignmentValue(stmt.target, stmt.value)}$suffix'];
    }

    if (stmt is IfStatement) {
      return _ifLines(stmt, suffix);
    }

    if (stmt is CaseStatement) {
      return _caseLines(stmt, suffix);
    }

    if (stmt is ForLoopStatement) {
      return _forLines(stmt, asListItem: asListItem);
    }

    if (stmt is WhileLoopStatement) {
      diagnostics?.warning(
        'while loops cannot be elaborated to hardware; skipped',
        code: 'GEN0010',
      );
      return ['// TODO: unsupported while loop'];
    }

    if (stmt is RepeatLoopStatement) {
      diagnostics?.warning(
        'repeat loops cannot be elaborated to hardware; skipped',
        code: 'GEN0011',
      );
      return ['// TODO: unsupported repeat loop'];
    }

    if (stmt is EmptyStatement) {
      return const [];
    }

    if (stmt is DelayStatement) {
      final delay =
          stmt.delay != null ? exprGen.generate(stmt.delay!) : 'unknown';
      return ['// delay #$delay (testbench-only construct)'];
    }

    if (stmt is EventStatement) {
      return ['// event control (testbench-only construct)'];
    }

    if (stmt is VariableDeclarationStatement) {
      diagnostics?.warning(
        "procedural variable '${stmt.variableName}' is not supported",
        code: 'GEN0012',
      );
      return ['// TODO: procedural variable ${stmt.variableName}'];
    }

    if (stmt is ReturnStatement) {
      return ['// return statements are not supported in module context'];
    }

    return ['// TODO: unsupported statement ${stmt.nodeType}'];
  }

  /// Renders the right-hand side of an assignment, adjusting widths to match
  /// the target where SystemVerilog context rules require it.
  String assignmentValue(IrExpression target, IrExpression value) {
    final wa = widthAnalyzer;
    if (wa == null) return exprGen.generate(value);
    if (value is LiteralExpression || exprGen.isIntDomain(value)) {
      // Integer constants are sized by ROHD from the assignment context.
      return exprGen.generate(value);
    }
    // A ternary assigned to a wider target must size its constant branches to
    // the target, otherwise each `Const` defaults to a single bit.
    if (value is ConditionalExpression) {
      final targetRef = _postfix(exprGen.generate(target));
      return exprGen.generateConditional(value, widthContext: targetRef);
    }
    final targetWidth = wa.widthOfExpr(target);
    final valueWidth = wa.widthOfExpr(value);
    if (targetWidth == null || valueWidth == null) {
      return exprGen.generate(value);
    }
    final diff = valueWidth - targetWidth;
    if (!diff.isConstant || diff.constant == 0) {
      return exprGen.generate(value);
    }
    final targetRef = _postfix(exprGen.generate(target));
    return _fitted(value, targetRef, targetWidth);
  }

  /// Like [assignmentValue] but guarantees the result is a `Logic` (as
  /// required by the `<=`/`gets` continuous assignment operator).
  String _requireLogicValue(IrExpression target, IrExpression value) {
    if (value is LiteralExpression || exprGen.isIntDomain(value)) {
      final targetRef = _postfix(exprGen.generate(target));
      return exprGen.generateLogic(value, widthContext: targetRef);
    }
    return assignmentValue(target, value);
  }

  /// Lowers a procedural assignment whose left-hand side is a bit- or
  /// part-select (`sig[i] = …`, `sig[msb:lsb] = …`) into a whole-signal
  /// conditional using ROHD's `withSet`, which returns a copy of the signal
  /// with the selected bits replaced.
  ///
  /// ROHD marks the result of a bit/part-select as read-only, so the direct
  /// lowering `sig[i] < value` throws "has been marked as unassignable" at
  /// construction (issue #31). `sig < sig.withSet(i, value)` instead reads the
  /// current (staged) value of `sig`, replaces the selected bits, and assigns
  /// the whole signal — matching SystemVerilog blocking (`always_comb`) and
  /// non-blocking (`always_ff`) bit-write semantics, where the unselected bits
  /// keep their prior value.
  ///
  /// Returns null when [target] is not a bit/part-select on an assignable
  /// Logic vector (the caller then uses the normal lowering).
  List<String>? _selectAssignmentLines(
    IrExpression target,
    IrExpression value,
    String suffix,
  ) {
    if (target is IndexedPartSelectExpression && _isLogicBitSelect(target)) {
      final index = target.index;
      if (!exprGen.isIntDomain(index)) {
        diagnostics?.error(
          'assignment to a bit-select with a runtime (non-constant) index is '
          'not supported; ROHD needs a compile-time bit position for withSet',
          code: 'GEN0028',
        );
        return ['// TODO: dynamic bit-select assignment$suffix'];
      }
      final base = _postfix(exprGen.generate(target.base));
      final idx = exprGen.generateInt(index);
      final update = _sizedUpdate(value, '1');
      return ['$base < $base.withSet($idx, $update)$suffix'];
    }

    if (target is PartSelectExpression) {
      final msb = target.msb;
      final lsb = target.lsb;
      if (!exprGen.isIntDomain(msb) || !exprGen.isIntDomain(lsb)) {
        diagnostics?.error(
          'assignment to a part-select with runtime (non-constant) bounds is '
          'not supported; ROHD needs compile-time bounds for withSet',
          code: 'GEN0028',
        );
        return ['// TODO: dynamic part-select assignment$suffix'];
      }
      final base = _postfix(exprGen.generate(target.base));
      final lsbStr = exprGen.generateInt(lsb);
      final widthExpr = '(${exprGen.generateInt(msb)}) - ($lsbStr) + 1';
      final update = _sizedUpdate(value, widthExpr);
      return ['$base < $base.withSet($lsbStr, $update)$suffix'];
    }

    return null;
  }

  /// True when [expr] selects a single bit of a Logic vector (as opposed to
  /// indexing an unpacked-array element, which yields an assignable element
  /// Logic and needs no `withSet`). A select is a Logic bit-select when the
  /// index-chain depth exceeds the base signal's unpacked-array dimensions.
  bool _isLogicBitSelect(IndexedPartSelectExpression expr) {
    var depth = 0;
    IrExpression cursor = expr;
    while (cursor is IndexedPartSelectExpression) {
      depth++;
      cursor = cursor.base;
    }
    if (cursor is! IdentifierExpression) {
      // Bit-select on a non-identifier base (e.g. a concatenation); treat as a
      // Logic bit-select.
      return true;
    }
    final id = cursor.identifier;
    final dims = exprGen.arraySignals.contains(id)
        ? (widthAnalyzer?.arrayDimensions[id] ?? 1)
        : 0;
    return depth > dims;
  }

  /// Renders [value] as a ROHD `Logic` of the given Dart [widthExpr] (an int
  /// expression), for use as the `withSet` update operand. Integer-domain
  /// values and literals become width-sized `Const`s; Logic values are emitted
  /// as-is (their width is expected to match the selected range).
  String _sizedUpdate(IrExpression value, String widthExpr) {
    if (exprGen.isIntDomain(value)) {
      return 'Const(${exprGen.generateInt(value)}, width: $widthExpr)';
    }
    return exprGen.generate(value);
  }

  String _fitted(IrExpression value, String targetRef, LinearExpr targetWidth) {
    final wa = widthAnalyzer!;

    if (value is LiteralExpression || exprGen.isIntDomain(value)) {
      return exprGen.generate(value);
    }

    if (value is BinaryExpression) {
      switch (value.operator) {
        case BinaryOperator.add:
        case BinaryOperator.subtract:
          final l = _fitted(value.left, targetRef, targetWidth);
          final r = _fitted(value.right, targetRef, targetWidth);
          final op = value.operator == BinaryOperator.add ? '+' : '-';
          return '($l $op $r)';
        case BinaryOperator.and:
        case BinaryOperator.or:
        case BinaryOperator.xor:
          final l = _fittedLogic(value.left, targetRef, targetWidth);
          final r = _fittedLogic(value.right, targetRef, targetWidth);
          final op = switch (value.operator) {
            BinaryOperator.and => '&',
            BinaryOperator.or => '|',
            _ => '^',
          };
          return '($l $op $r)';
        default:
          break;
      }
    }

    final width = wa.widthOfExpr(value);
    if (width != null) {
      final diff = width - targetWidth;
      if (diff.isConstant && diff.constant < 0) {
        return '${_postfix(exprGen.generate(value))}'
            '.zeroExtend($targetRef.width)';
      }
      if (diff.isConstant && diff.constant > 0) {
        return '${_postfix(exprGen.generate(value))}'
            '.getRange(0, $targetRef.width)';
      }
    }
    return exprGen.generate(value);
  }

  String _fittedLogic(
    IrExpression value,
    String targetRef,
    LinearExpr targetWidth,
  ) {
    if (value is LiteralExpression || exprGen.isIntDomain(value)) {
      return exprGen.generateLogic(value, widthContext: targetRef);
    }
    return _fitted(value, targetRef, targetWidth);
  }

  List<String> _ifLines(IfStatement stmt, String suffix) {
    final condition = exprGen.generate(stmt.condition);
    final result = <String>['If($condition, then: ['];
    result.addAll(_indented(_branchLines(stmt.thenBranch)));
    if (stmt.elseBranch != null) {
      result.add('], orElse: [');
      result.addAll(_indented(_branchLines(stmt.elseBranch!)));
    }
    result.add('])$suffix');
    return result;
  }

  List<String> _caseLines(CaseStatement stmt, String suffix) {
    final selector = exprGen.generate(stmt.expression);
    final selectorRef = _postfix(selector);
    final caseClass = switch (stmt.kind) {
      CaseKind.z => 'CaseZ',
      CaseKind.x => 'CaseZ',
      _ => 'Case',
    };
    if (stmt.kind == CaseKind.x) {
      diagnostics?.warning(
        'casex mapped to CaseZ; x digits are matched as wildcards',
        code: 'GEN0013',
      );
    }

    final result = <String>['$caseClass($selector, ['];
    for (final item in stmt.items) {
      for (final value in item.values) {
        final rendered = _caseItemValue(value, stmt.kind, selectorRef);
        result.add('  CaseItem($rendered, [');
        if (item.statement != null) {
          result.addAll(_indented(_branchLines(item.statement!), 2));
        }
        result.add('  ]),');
      }
    }
    if (stmt.defaultCase != null) {
      result.add('], defaultItem: [');
      result.addAll(_indented(_branchLines(stmt.defaultCase!)));
    }
    result.add('])$suffix');
    return result;
  }

  /// Renders a single case-item value, preserving x/z wildcard bits for
  /// `casez`/`casex` (see [LiteralExpression.wildcardBits]) instead of
  /// collapsing them to a literal 0, since `CaseZ` matches wildcard bits
  /// via the item value's own `z` digits, not the case kind alone.
  String _caseItemValue(IrExpression value, CaseKind kind, String selectorRef) {
    if (value is LiteralExpression) {
      if (kind != CaseKind.normal && value.wildcardBits != null) {
        return "Const(LogicValue.ofString('${value.wildcardBits}'))";
      }
      return 'Const(${value.value}, width: $selectorRef.width)';
    }
    return exprGen.generateLogic(value, widthContext: selectorRef);
  }

  List<String> _forLines(ForLoopStatement stmt, {required bool asListItem}) {
    final header = _forHeader(stmt);
    final body = _branchLines(stmt.body);
    if (asListItem) {
      // Collection-for with spread keeps the loop inside a Conditional list.
      return [
        '$header ...[',
        ..._indented(body),
        '],',
      ];
    }
    return [
      '$header {',
      ..._indented(lines(stmt.body, asListItem: false).toList(growable: true)),
      '}',
    ];
  }

  String _forHeader(ForLoopStatement stmt) {
    var varName = 'i';
    var initial = '0';
    final init = stmt.initialization;
    if (init is AssignmentStatement && init.target is IdentifierExpression) {
      varName = namingStrategy
          .toCamelCase((init.target as IdentifierExpression).identifier);
      initial = exprGen.generateInt(init.value);
    }
    final condition =
        stmt.condition != null ? exprGen.generateInt(stmt.condition!) : 'false';
    final step = _stepText(varName, stmt.step);
    return 'for (var $varName = $initial; $condition; $step)';
  }

  String _stepText(String varName, IrStatement? step) {
    if (step is AssignmentStatement && step.target is IdentifierExpression) {
      final target = namingStrategy
          .toCamelCase((step.target as IdentifierExpression).identifier);
      final value = step.value;
      if (value is BinaryExpression &&
          value.operator == BinaryOperator.add &&
          value.left is IdentifierExpression &&
          namingStrategy.toCamelCase(
                  (value.left as IdentifierExpression).identifier) ==
              target &&
          value.right is LiteralExpression &&
          (value.right as LiteralExpression).value == 1) {
        return '$target++';
      }
      return '$target = ${exprGen.generateInt(value)}';
    }
    return '$varName++';
  }

  List<String> _branchLines(IrStatement stmt) => lines(stmt, asListItem: true);

  List<String> _indented(List<String> input, [int levels = 1]) {
    final pad = '  ' * levels;
    return [for (final line in input) line.isEmpty ? line : '$pad$line'];
  }

  String _postfix(String text) {
    if (RegExp(r'^[A-Za-z_$][A-Za-z0-9_$\[\]\.]*$').hasMatch(text)) {
      return text;
    }
    return '($text)';
  }
}
