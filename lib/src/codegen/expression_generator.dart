// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

// Parts of this implementation were generated with LLM assistance and
// reviewed by the maintainer.

import '../common/common.dart';
import '../ir/ir.dart';
import 'function_inliner.dart';
import 'naming_strategy.dart';
import 'width_analyzer.dart';

/// Generates ROHD expressions from IR expressions.
///
/// Distinguishes two value domains:
/// - **Logic domain**: hardware signals, generated as ROHD `Logic` code.
/// - **Int domain**: parameters, genvars, and loop variables, which exist as
///   Dart `int` values at module construction time.
class ExpressionGenerator {
  final NamingStrategy namingStrategy;

  /// Width/domain context; optional so the generator can be used standalone.
  final WidthAnalyzer? widthAnalyzer;

  /// SV names of signals represented as `List<Logic>` (unpacked arrays).
  final Set<String> arraySignals;

  /// Inliner for user-defined function calls; null when there are none.
  final FunctionInliner? functionInliner;

  final DiagnosticCollector? diagnostics;

  ExpressionGenerator({
    required this.namingStrategy,
    this.widthAnalyzer,
    Set<String>? arraySignals,
    this.functionInliner,
    this.diagnostics,
  }) : arraySignals = arraySignals ?? <String>{};

  Set<String> get _intDomain => widthAnalyzer?.intDomain ?? const <String>{};

  /// True when [expr] only involves elaboration-time values (parameters,
  /// genvars, literals) and can be rendered as a Dart int expression.
  bool isIntDomain(IrExpression expr) {
    if (expr is LiteralExpression) {
      return expr.kind == LiteralKind.integer ||
          expr.kind == LiteralKind.bitVector;
    }
    if (expr is IdentifierExpression) {
      return _intDomain.contains(namingStrategy.toCamelCase(expr.identifier));
    }
    if (expr is UnaryExpression) return isIntDomain(expr.operand);
    if (expr is BinaryExpression) {
      return isIntDomain(expr.left) && isIntDomain(expr.right);
    }
    if (expr is ConditionalExpression) {
      return isIntDomain(expr.condition) &&
          isIntDomain(expr.trueExpr) &&
          isIntDomain(expr.falseExpr);
    }
    if (expr is FunctionCallExpression) {
      return expr.functionName == r'$clog2' &&
          expr.arguments.every(isIntDomain);
    }
    return false;
  }

  /// Generates an expression for a hardware context. The result is usable as
  /// an operand of ROHD operators or the right-hand side of a conditional
  /// assignment (which both accept ints for constants).
  String generate(IrExpression expr) {
    if (expr is LiteralExpression) {
      return _generateLiteral(expr);
    }
    if (isIntDomain(expr)) {
      return generateInt(expr);
    }
    if (expr is IdentifierExpression) {
      return namingStrategy.toCamelCase(expr.identifier);
    }
    if (expr is BinaryExpression) {
      return _generateBinaryOp(expr);
    }
    if (expr is UnaryExpression) {
      return _generateUnaryOp(expr);
    }
    if (expr is ConditionalExpression) {
      return generateConditional(expr);
    }
    if (expr is ConcatenationExpression) {
      final parts = expr.expressions.map(generateLogic).join(', ');
      return '[$parts].swizzle()';
    }
    if (expr is ReplicationExpression) {
      return '${_postfixOperand(generateLogic(expr.operand))}'
          '.replicate(${generateInt(expr.count)})';
    }
    if (expr is PartSelectExpression) {
      final base = _postfixOperand(generate(expr.base));
      return '$base.slice(${generateInt(expr.msb)}, ${generateInt(expr.lsb)})';
    }
    if (expr is IndexedPartSelectExpression) {
      return _generateIndex(expr);
    }
    if (expr is FunctionCallExpression) {
      return _generateFunctionCall(expr);
    }
    diagnostics?.warning(
      'unsupported expression ${expr.nodeType}; emitting placeholder',
      code: 'GEN0001',
    );
    return 'Const(0)';
  }

  /// Generates a `mux(...)` for a ternary expression. When [widthContext] is
  /// provided (e.g. the assignment target), constant branches are sized to
  /// it so `a ? WIDE_CONST : 0` matches the target width rather than
  /// defaulting each constant to a single bit.
  String generateConditional(ConditionalExpression expr,
      {String? widthContext}) {
    return 'mux(${generateLogic(expr.condition)}, '
        '${generateLogic(expr.trueExpr, widthContext: widthContext)}, '
        '${generateLogic(expr.falseExpr, widthContext: widthContext)})';
  }

  /// Generates an expression that must be a ROHD `Logic` value; int-domain
  /// values and literals are wrapped in `Const`.
  ///
  /// [widthContext] optionally provides a Dart expression whose `.width`
  /// determines the constant's width when the literal itself is unsized.
  String generateLogic(IrExpression expr, {String? widthContext}) {
    if (expr is LiteralExpression &&
        (expr.kind == LiteralKind.integer ||
            expr.kind == LiteralKind.bitVector)) {
      return _constFor(_literalValueText(expr), expr.width, widthContext);
    }
    if (isIntDomain(expr)) {
      return _constFor(generateInt(expr), null, widthContext);
    }
    return generate(expr);
  }

  String _constFor(String valueText, int? width, String? widthContext) {
    if (width != null) {
      return 'Const($valueText, width: $width)';
    }
    if (widthContext != null) {
      return 'Const($valueText, width: $widthContext.width)';
    }
    return 'Const($valueText)';
  }

  /// Generates a Dart `int`/`bool` expression for elaboration-time values.
  String generateInt(IrExpression expr) {
    if (expr is LiteralExpression) {
      return _literalValueText(expr);
    }
    if (expr is IdentifierExpression) {
      final name = namingStrategy.toCamelCase(expr.identifier);
      if (!_intDomain.contains(name) && widthAnalyzer != null) {
        diagnostics?.warning(
          "'${expr.identifier}' used in an elaboration-time context but is "
          'not a parameter or genvar',
          code: 'GEN0002',
        );
      }
      return name;
    }
    if (expr is UnaryExpression) {
      final operand = generateInt(expr.operand);
      return switch (expr.operator) {
        UnaryOperator.plus => operand,
        UnaryOperator.minus => '-$operand',
        UnaryOperator.bitwiseNot => '~$operand',
        UnaryOperator.logicalNot => '!($operand)',
        _ => operand,
      };
    }
    if (expr is BinaryExpression) {
      final left = generateInt(expr.left);
      final right = generateInt(expr.right);
      final op = switch (expr.operator) {
        BinaryOperator.add => '+',
        BinaryOperator.subtract => '-',
        BinaryOperator.multiply => '*',
        BinaryOperator.divide => '~/',
        BinaryOperator.modulo => '%',
        BinaryOperator.and => '&',
        BinaryOperator.or => '|',
        BinaryOperator.xor => '^',
        BinaryOperator.shiftLeft || BinaryOperator.arithmeticShiftLeft => '<<',
        BinaryOperator.shiftRight ||
        BinaryOperator.arithmeticShiftRight =>
          '>>',
        BinaryOperator.equal || BinaryOperator.caseEqual => '==',
        BinaryOperator.notEqual || BinaryOperator.caseNotEqual => '!=',
        BinaryOperator.lessThan => '<',
        BinaryOperator.lessThanOrEqual => '<=',
        BinaryOperator.greaterThan => '>',
        BinaryOperator.greaterThanOrEqual => '>=',
        BinaryOperator.logicalAnd => '&&',
        BinaryOperator.logicalOr => '||',
        _ => '+',
      };
      return '$left $op $right';
    }
    if (expr is ConditionalExpression) {
      return '(${generateInt(expr.condition)} '
          '? ${generateInt(expr.trueExpr)} '
          ': ${generateInt(expr.falseExpr)})';
    }
    if (expr is FunctionCallExpression && expr.functionName == r'$clog2') {
      final args = expr.arguments.map(generateInt).join(', ');
      return 'log2Ceil($args)';
    }
    diagnostics?.warning(
      'unsupported elaboration-time expression ${expr.nodeType}',
      code: 'GEN0003',
    );
    return '0';
  }

  String _literalValueText(LiteralExpression expr) {
    switch (expr.kind) {
      case LiteralKind.integer:
      case LiteralKind.bitVector:
      case LiteralKind.real:
      case LiteralKind.time:
        return expr.value.toString();
      case LiteralKind.string:
        return "'${expr.value}'";
    }
  }

  String _generateLiteral(LiteralExpression expr) {
    if (expr.kind == LiteralKind.string) {
      return "'${expr.value}'";
    }
    return expr.value.toString();
  }

  String _generateIndex(IndexedPartSelectExpression expr) {
    // Unwind a chain of index selects (mem[a][b]) down to the base.
    final indices = <IrExpression>[];
    IrExpression cursor = expr;
    while (cursor is IndexedPartSelectExpression) {
      indices.add(cursor.index);
      cursor = cursor.base;
    }
    final ordered = indices.reversed.toList();

    if (cursor is IdentifierExpression &&
        arraySignals.contains(cursor.identifier)) {
      final name = namingStrategy.toCamelCase(cursor.identifier);
      final dims = widthAnalyzer?.arrayDimensions[cursor.identifier] ?? 1;
      final sb = StringBuffer(name);
      for (var i = 0; i < ordered.length; i++) {
        final idx = ordered[i];
        if (i < dims) {
          // Indexing into a Dart `List`; its `[]` requires an `int`, so a
          // runtime (non-elaboration-time) index cannot compile. Fail
          // loudly instead of emitting code that looks like success.
          if (!isIntDomain(idx)) {
            diagnostics?.error(
              "array '${cursor.identifier}' is indexed with a runtime "
              'signal, but unpacked-array elements can only be selected '
              'with a compile-time constant (a parameter or genvar); '
              'dynamic array indexing is not supported',
              code: 'GEN0025',
            );
          }
          sb.write('[${generateInt(idx)}]');
        } else {
          // Bit/part select on the element Logic; a hardware index is fine.
          sb.write('[${isIntDomain(idx) ? generateInt(idx) : generate(idx)}]');
        }
      }
      return sb.toString();
    }

    final baseStr = _postfixOperand(generate(expr.base));
    final indexStr = isIntDomain(expr.index)
        ? generateInt(expr.index)
        : generate(expr.index);
    return '$baseStr[$indexStr]';
  }

  String _generateBinaryOp(BinaryExpression expr) {
    final leftIsInt = isIntDomain(expr.left);
    final rightIsInt = isIntDomain(expr.right);

    // A constant on the left of a Logic operand: rewrite so the Logic value
    // is the receiver, mirroring/commuting the operator where possible.
    if (leftIsInt && !rightIsInt) {
      return _generateIntLeft(expr);
    }

    final left = generate(expr.left);

    switch (expr.operator) {
      // Bitwise ROHD operators require Logic operands on both sides.
      case BinaryOperator.and:
      case BinaryOperator.logicalAnd:
        return '($left & ${_logicRight(expr, left)})';
      case BinaryOperator.or:
      case BinaryOperator.logicalOr:
        return '($left | ${_logicRight(expr, left)})';
      case BinaryOperator.xor:
        return '($left ^ ${_logicRight(expr, left)})';
      case BinaryOperator.xnor:
      case BinaryOperator.nxor:
        return '~($left ^ ${_logicRight(expr, left)})';
      case BinaryOperator.nand:
        return '~($left & ${_logicRight(expr, left)})';
      case BinaryOperator.nor:
        return '~($left | ${_logicRight(expr, left)})';

      // Dynamic-accepting operators: ints pass through unchanged.
      case BinaryOperator.add:
        return '($left + ${generate(expr.right)})';
      case BinaryOperator.subtract:
        return '($left - ${generate(expr.right)})';
      case BinaryOperator.multiply:
        return '($left * ${generate(expr.right)})';
      case BinaryOperator.divide:
        return '($left / ${generate(expr.right)})';
      case BinaryOperator.modulo:
        return '($left % ${generate(expr.right)})';
      case BinaryOperator.shiftLeft:
      case BinaryOperator.arithmeticShiftLeft:
        return '($left << ${generate(expr.right)})';
      case BinaryOperator.shiftRight:
        return '($left >>> ${generate(expr.right)})';
      case BinaryOperator.arithmeticShiftRight:
        return '($left >> ${generate(expr.right)})';

      case BinaryOperator.equal:
      case BinaryOperator.caseEqual:
        return '${_postfixOperand(left)}.eq(${generate(expr.right)})';
      case BinaryOperator.notEqual:
      case BinaryOperator.caseNotEqual:
        return '${_postfixOperand(left)}.neq(${generate(expr.right)})';
      case BinaryOperator.lessThan:
        return '${_postfixOperand(left)}.lt(${generate(expr.right)})';
      case BinaryOperator.lessThanOrEqual:
        return '${_postfixOperand(left)}.lte(${generate(expr.right)})';
      case BinaryOperator.greaterThan:
        return '${_postfixOperand(left)}.gt(${generate(expr.right)})';
      case BinaryOperator.greaterThanOrEqual:
        return '${_postfixOperand(left)}.gte(${generate(expr.right)})';
    }
  }

  String _logicRight(BinaryExpression expr, String leftStr) =>
      generateLogic(expr.right, widthContext: _postfixOperand(leftStr));

  String _generateIntLeft(BinaryExpression expr) {
    final left = generateInt(expr.left);
    final right = generate(expr.right);
    final rightOperand = _postfixOperand(right);

    switch (expr.operator) {
      // Commutative operators: swap operands.
      case BinaryOperator.add:
        return '($right + $left)';
      case BinaryOperator.multiply:
        return '($right * $left)';
      case BinaryOperator.and:
      case BinaryOperator.logicalAnd:
        return '($right & Const($left, width: $rightOperand.width))';
      case BinaryOperator.or:
      case BinaryOperator.logicalOr:
        return '($right | Const($left, width: $rightOperand.width))';
      case BinaryOperator.xor:
        return '($right ^ Const($left, width: $rightOperand.width))';
      case BinaryOperator.equal:
      case BinaryOperator.caseEqual:
        return '$rightOperand.eq($left)';
      case BinaryOperator.notEqual:
      case BinaryOperator.caseNotEqual:
        return '$rightOperand.neq($left)';

      // Mirrored comparisons: c < x  ≡  x > c.
      case BinaryOperator.lessThan:
        return '$rightOperand.gt($left)';
      case BinaryOperator.lessThanOrEqual:
        return '$rightOperand.gte($left)';
      case BinaryOperator.greaterThan:
        return '$rightOperand.lt($left)';
      case BinaryOperator.greaterThanOrEqual:
        return '$rightOperand.lte($left)';

      // Non-commutative: materialize the constant as a Const.
      default:
        final constant = 'Const($left, width: $rightOperand.width)';
        final op = switch (expr.operator) {
          BinaryOperator.subtract => '-',
          BinaryOperator.divide => '/',
          BinaryOperator.modulo => '%',
          BinaryOperator.shiftLeft ||
          BinaryOperator.arithmeticShiftLeft =>
            '<<',
          BinaryOperator.shiftRight => '>>>',
          BinaryOperator.arithmeticShiftRight => '>>',
          _ => '+',
        };
        return '($constant $op $right)';
    }
  }

  String _generateUnaryOp(UnaryExpression expr) {
    final operand = generate(expr.operand);
    final postfix = _postfixOperand(operand);

    switch (expr.operator) {
      case UnaryOperator.plus:
        return operand;
      case UnaryOperator.minus:
        return '(~$postfix + 1)';
      case UnaryOperator.bitwiseNot:
        return '~$postfix';
      case UnaryOperator.logicalNot:
        final width = widthAnalyzer?.widthOfExpr(expr.operand);
        if (width != null && width.asConstant == 1) {
          return '~$postfix';
        }
        if (width == null) {
          return '~$postfix';
        }
        return '$postfix.eq(0)';
      case UnaryOperator.reductionAnd:
        return '$postfix.and()';
      case UnaryOperator.reductionOr:
        return '$postfix.or()';
      case UnaryOperator.reductionXor:
        return '$postfix.xor()';
      case UnaryOperator.reductionNand:
        return '~$postfix.and()';
      case UnaryOperator.reductionNor:
        return '~$postfix.or()';
      case UnaryOperator.reductionXnor:
        return '~$postfix.xor()';
    }
  }

  String _generateFunctionCall(FunctionCallExpression expr) {
    // Inline calls to user-defined functions by generating their reduced,
    // argument-substituted body.
    final inliner = functionInliner;
    if (inliner != null && inliner.isFunction(expr.functionName)) {
      final inlined = inliner.inline(expr.functionName, expr.arguments);
      if (inlined != null) {
        return _postfixOperand(generate(inlined));
      }
      diagnostics?.error(
        "call to function '${expr.functionName}' could not be inlined; its "
        'body is not supported',
        code: 'GEN0032',
      );
      return 'Const(0)';
    }

    final args = expr.arguments.map((a) => generate(a)).join(', ');
    switch (expr.functionName) {
      case r'$signed':
      case r'$unsigned':
        return args;
      case r'$bits':
      case r'$size':
        return '${_postfixOperand(args)}.width';
      case r'$clog2':
        return 'log2Ceil(${expr.arguments.map(generateInt).join(', ')})';
      default:
        diagnostics?.warning(
          "call to unsupported function '${expr.functionName}'",
          code: 'GEN0004',
        );
        return '${expr.functionName}($args)';
    }
  }

  /// Wraps an operand in parentheses when needed so that postfix access
  /// (`.method`, `[index]`) binds correctly.
  String _postfixOperand(String text) {
    if (RegExp(r'^[A-Za-z_$][A-Za-z0-9_$]*$').hasMatch(text)) return text;
    if (text.startsWith('(') && text.endsWith(')')) return text;
    if (text.startsWith('[') && text.endsWith('.swizzle()')) return text;
    if (RegExp(r'^[A-Za-z0-9_$\[\]\.()]+$').hasMatch(text)) return text;
    return '($text)';
  }
}
