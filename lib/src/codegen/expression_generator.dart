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
    // A bit/part-select of an elaboration-time int stays in the int domain.
    if (expr is PartSelectExpression) return isIntDomain(expr.base);
    if (expr is IndexedPartSelectExpression) {
      return isIntDomain(expr.base) && isIntDomain(expr.index);
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
      // A part-select of an elaboration-time int (e.g. `i[$clog2(N)-1:0]` on a
      // loop variable) is integer bit math, not a `Logic.slice`.
      if (isIntDomain(expr.base)) {
        final base = _postfixOperand(generateInt(expr.base));
        final lsb = generateInt(expr.lsb);
        final width = '(${generateInt(expr.msb)}) - ($lsb) + 1';
        return '(($base >> $lsb) & ((1 << ($width)) - 1))';
      }
      // A part-select whose bounds depend on a runtime signal (e.g. an
      // indexed part-select `data[sel*W +: W]` with a Logic `sel`) has no
      // faithful `Logic.slice` lowering — `slice` needs compile-time bounds.
      // Emit a diagnostic rather than `slice(<Logic>)`, which does not compile.
      if (!isIntDomain(expr.msb) || !isIntDomain(expr.lsb)) {
        diagnostics?.error(
          'part-select with runtime (non-constant) bounds is not supported; '
          'ROHD slice bounds must be compile-time constants',
          code: 'GEN0027',
        );
        return 'Const(0)';
      }
      final base = _postfixOperand(generate(expr.base));
      return '$base.slice(${generateInt(expr.msb)}, ${generateInt(expr.lsb)})';
    }
    if (expr is IndexedPartSelectExpression) {
      // A bit-select of an elaboration-time int is integer bit math.
      if (isIntDomain(expr.base) && isIntDomain(expr.index)) {
        final base = _postfixOperand(generateInt(expr.base));
        return '(($base >> ${generateInt(expr.index)}) & 1)';
      }
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
      // Parenthesize operands only where operator precedence requires it, so
      // `(i+1)*DW` keeps its parentheses while `width + 1` stays flat. All
      // these operators are left-associative: the right operand also needs
      // parentheses at equal precedence (e.g. `a - (b - c)`).
      final prec = _intPrecedence(expr.operator);
      final left = _intOperand(expr.left, prec, isRight: false);
      final right = _intOperand(expr.right, prec, isRight: true);
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
    // Bit/part-selects of an elaboration-time int are integer bit math.
    if (expr is PartSelectExpression && isIntDomain(expr.base)) {
      final base = _postfixOperand(generateInt(expr.base));
      final lsb = generateInt(expr.lsb);
      final width = '(${generateInt(expr.msb)}) - ($lsb) + 1';
      return '(($base >> $lsb) & ((1 << ($width)) - 1))';
    }
    if (expr is IndexedPartSelectExpression &&
        isIntDomain(expr.base) &&
        isIntDomain(expr.index)) {
      final base = _postfixOperand(generateInt(expr.base));
      return '(($base >> ${generateInt(expr.index)}) & 1)';
    }
    diagnostics?.warning(
      'unsupported elaboration-time expression ${expr.nodeType}',
      code: 'GEN0003',
    );
    return '0';
  }

  /// Relative precedence of an int-domain binary operator (higher binds
  /// tighter), used to decide when a rendered operand needs parentheses.
  static int _intPrecedence(BinaryOperator op) => switch (op) {
        BinaryOperator.logicalOr => 1,
        BinaryOperator.logicalAnd => 2,
        BinaryOperator.or => 3,
        BinaryOperator.xor => 4,
        BinaryOperator.and => 5,
        BinaryOperator.equal ||
        BinaryOperator.caseEqual ||
        BinaryOperator.notEqual ||
        BinaryOperator.caseNotEqual =>
          6,
        BinaryOperator.lessThan ||
        BinaryOperator.lessThanOrEqual ||
        BinaryOperator.greaterThan ||
        BinaryOperator.greaterThanOrEqual =>
          7,
        BinaryOperator.shiftLeft ||
        BinaryOperator.arithmeticShiftLeft ||
        BinaryOperator.shiftRight ||
        BinaryOperator.arithmeticShiftRight =>
          8,
        BinaryOperator.add || BinaryOperator.subtract => 9,
        BinaryOperator.multiply ||
        BinaryOperator.divide ||
        BinaryOperator.modulo =>
          10,
        _ => 0,
      };

  /// Renders [expr] as an operand of a binary op at [parentPrec], adding
  /// parentheses when the child binds looser than the parent (or equally, for
  /// the right operand of a left-associative operator).
  String _intOperand(IrExpression expr, int parentPrec, {required bool isRight}) {
    final text = generateInt(expr);
    if (expr is BinaryExpression) {
      final childPrec = _intPrecedence(expr.operator);
      if (childPrec < parentPrec || (isRight && childPrec == parentPrec)) {
        return '($text)';
      }
    }
    return text;
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
    // Signed comparisons need the two's-complement identity regardless of
    // which operand is constant, so handle them before any operand rewrite.
    if (_isRelational(expr.operator) && _isSignedComparison(expr)) {
      return _signedCompare(expr, _relationalName(expr.operator));
    }

    // ROHD has no signed multiply/divide/modulo. Add/subtract are bit-
    // identical to unsigned in two's complement, but these are not, so warn
    // rather than silently emitting unsigned arithmetic.
    if ((expr.operator == BinaryOperator.multiply ||
            expr.operator == BinaryOperator.divide ||
            expr.operator == BinaryOperator.modulo) &&
        isSignedExpr(expr.left) &&
        isSignedExpr(expr.right)) {
      diagnostics?.warning(
        'signed multiply/divide/modulo is generated as unsigned (ROHD has no '
        'signed variant); the low bits of a truncated result are correct, '
        'but verify wider or division/modulo results',
        code: 'GEN0033',
      );
    }

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

  static bool _isRelational(BinaryOperator op) =>
      op == BinaryOperator.lessThan ||
      op == BinaryOperator.lessThanOrEqual ||
      op == BinaryOperator.greaterThan ||
      op == BinaryOperator.greaterThanOrEqual;

  static String _relationalName(BinaryOperator op) => switch (op) {
        BinaryOperator.lessThan => 'lt',
        BinaryOperator.lessThanOrEqual => 'lte',
        BinaryOperator.greaterThan => 'gt',
        _ => 'gte',
      };

  Set<String> get _signedSignals =>
      widthAnalyzer?.signedSignals ?? const <String>{};

  /// True when [expr] has two's-complement (signed) type per SystemVerilog:
  /// a signed signal, `$signed(...)`, unary minus, or an arithmetic
  /// combination of signed operands. Part-selects and reductions are
  /// unsigned. Not used for elaboration-time (int) expressions.
  bool isSignedExpr(IrExpression expr) {
    if (expr is IdentifierExpression) {
      return _signedSignals.contains(expr.identifier);
    }
    if (expr is UnaryExpression) {
      if (expr.operator == UnaryOperator.minus) return true;
      if (expr.operator == UnaryOperator.plus ||
          expr.operator == UnaryOperator.bitwiseNot) {
        return isSignedExpr(expr.operand);
      }
      return false;
    }
    if (expr is BinaryExpression) {
      switch (expr.operator) {
        case BinaryOperator.add:
        case BinaryOperator.subtract:
        case BinaryOperator.multiply:
        case BinaryOperator.divide:
        case BinaryOperator.modulo:
        case BinaryOperator.and:
        case BinaryOperator.or:
        case BinaryOperator.xor:
          return isSignedExpr(expr.left) && isSignedExpr(expr.right);
        default:
          return false;
      }
    }
    if (expr is FunctionCallExpression) {
      return expr.functionName == r'$signed';
    }
    if (expr is ConditionalExpression) {
      return isSignedExpr(expr.trueExpr) && isSignedExpr(expr.falseExpr);
    }
    return false;
  }

  /// A comparison is signed only when both operands are signed (a literal
  /// operand adopts the other operand's signedness), per SystemVerilog.
  bool _isSignedComparison(BinaryExpression expr) {
    final l = expr.left;
    final r = expr.right;
    final lSigned = isSignedExpr(l);
    final rSigned = isSignedExpr(r);
    final lIsSigned = lSigned || (l is LiteralExpression && rSigned);
    final rIsSigned = rSigned || (r is LiteralExpression && lSigned);
    return lIsSigned && rIsSigned;
  }

  /// Emits a signed comparison using the two's-complement identity, since
  /// ROHD's comparison operators are unsigned. For same-sign operands the
  /// unsigned comparison already orders correctly; when the sign bits differ,
  /// the negative operand (sign bit 1) is the smaller one.
  ///
  ///   a <s b  ==  (a[msb] != b[msb]) ? a[msb] : (a <u b)
  ///   a >s b  ==  (a[msb] != b[msb]) ? b[msb] : (a >u b)
  String _signedCompare(BinaryExpression expr, String op) {
    final leftConst = expr.left is LiteralExpression || isIntDomain(expr.left);
    final rightConst =
        expr.right is LiteralExpression || isIntDomain(expr.right);

    // Size a constant operand to the other (signal) operand's width so the
    // sign bit and comparison line up.
    String a;
    String b;
    if (leftConst && !rightConst) {
      b = _postfixOperand(generate(expr.right));
      a = _postfixOperand(generateLogic(expr.left, widthContext: b));
    } else if (rightConst && !leftConst) {
      a = _postfixOperand(generate(expr.left));
      b = _postfixOperand(generateLogic(expr.right, widthContext: a));
    } else {
      a = _postfixOperand(generateLogic(expr.left));
      b = _postfixOperand(generateLogic(expr.right));
    }

    final sa = '$a[-1]';
    final sb = '$b[-1]';
    final differ = '$sa.neq($sb)';
    switch (op) {
      case 'lt':
        return 'mux($differ, $sa, $a.lt($b))';
      case 'gt':
        return 'mux($differ, $sb, $a.gt($b))';
      case 'lte': // ~(a >s b)
        return '~mux($differ, $sb, $a.gt($b))';
      case 'gte': // ~(a <s b)
        return '~mux($differ, $sa, $a.lt($b))';
      default:
        return '$a.lt($b)';
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
