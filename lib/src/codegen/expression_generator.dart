// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

import '../ir/ir.dart';
import 'naming_strategy.dart';

/// Generates ROHD expressions from IR expressions.
class ExpressionGenerator {
  final NamingStrategy namingStrategy;

  ExpressionGenerator({required this.namingStrategy});

  /// Generate ROHD expression string from IR expression.
  String generate(IrExpression expr) {
    if (expr is LiteralExpression) {
      return _generateLiteral(expr);
    } else if (expr is IdentifierExpression) {
      return _generateIdentifier(expr);
    } else if (expr is BinaryExpression) {
      return _generateBinaryOp(expr);
    } else if (expr is UnaryExpression) {
      return _generateUnaryOp(expr);
    } else if (expr is ConditionalExpression) {
      return _generateConditional(expr);
    } else if (expr is ConcatenationExpression) {
      return _generateConcatenation(expr);
    } else if (expr is FunctionCallExpression) {
      return _generateFunctionCall(expr);
    } else if (expr is PartSelectExpression) {
      return _generatePartSelect(expr);
    }
    return 'Logic()';
  }

  String _generateLiteral(LiteralExpression expr) {
    switch (expr.kind) {
      case LiteralKind.integer:
        return expr.value.toString();
      case LiteralKind.real:
        return expr.value.toString();
      case LiteralKind.string:
        return "'${expr.value}'";
      case LiteralKind.time:
        return expr.value.toString();
      case LiteralKind.bitVector:
        return expr.value.toString();
    }
  }

  String _generateIdentifier(IdentifierExpression expr) {
    final name = namingStrategy.toCamelCase(expr.identifier);

    // Handle part selects like signal[7:0]
    if (expr.indices.isNotEmpty) {
      // Simplified - would need more complex handling
    }

    return name;
  }

  String _generateBinaryOp(BinaryExpression expr) {
    final left = generate(expr.left);
    final right = generate(expr.right);

    switch (expr.operator) {
      case BinaryOperator.add:
        return '($left + $right)';
      case BinaryOperator.subtract:
        return '($left - $right)';
      case BinaryOperator.multiply:
        return '($left * $right)';
      case BinaryOperator.divide:
        return '($left / $right)';
      case BinaryOperator.modulo:
        return '($left % $right)';
      case BinaryOperator.and:
        return '($left & $right)';
      case BinaryOperator.or:
        return '($left | $right)';
      case BinaryOperator.xor:
        return '($left ^ $right)';
      case BinaryOperator.xnor:
        return '~($left ^ $right)';
      case BinaryOperator.nxor:
        return '~($left ^ $right)';
      case BinaryOperator.equal:
        return '$left.eq($right)';
      case BinaryOperator.notEqual:
        return '$left.neq($right)';
      case BinaryOperator.caseEqual:
        return '$left.eq($right)'; // ROHD doesn't have === operator
      case BinaryOperator.caseNotEqual:
        return '$left.neq($right)';
      case BinaryOperator.lessThan:
        return '$left.lt($right)';
      case BinaryOperator.lessThanOrEqual:
        return '$left.le($right)';
      case BinaryOperator.greaterThan:
        return '$left.gt($right)';
      case BinaryOperator.greaterThanOrEqual:
        return '$left.ge($right)';
      case BinaryOperator.logicalAnd:
        return '($left & $right)';
      case BinaryOperator.logicalOr:
        return '($left | $right)';
      case BinaryOperator.shiftLeft:
        return '($left << $right)';
      case BinaryOperator.shiftRight:
        return '($left >> $right)';
      case BinaryOperator.arithmeticShiftLeft:
        return '($left << $right)';
      case BinaryOperator.arithmeticShiftRight:
        return '($left >> $right)';
      case BinaryOperator.nand:
        return '~($left & $right)';
      case BinaryOperator.nor:
        return '~($left | $right)';
    }
  }

  String _generateUnaryOp(UnaryExpression expr) {
    final operand = generate(expr.operand);

    switch (expr.operator) {
      case UnaryOperator.plus:
        return operand;
      case UnaryOperator.minus:
        return '-$operand';
      case UnaryOperator.bitwiseNot:
        return '~$operand';
      case UnaryOperator.logicalNot:
        return '~$operand';
    }
  }

  String _generateConditional(ConditionalExpression expr) {
    final cond = generate(expr.condition);
    final trueExpr = generate(expr.trueExpr);
    final falseExpr = generate(expr.falseExpr);
    return '$cond.mux($trueExpr, $falseExpr)';
  }

  String _generateConcatenation(ConcatenationExpression expr) {
    final parts = expr.expressions.map((e) => generate(e)).join(', ');
    return '[$parts]';
  }

  String _generateFunctionCall(FunctionCallExpression expr) {
    final args = expr.arguments.map((a) => generate(a)).join(', ');

    // Handle common system functions
    switch (expr.functionName) {
      case r'$signed':
        return '$args';
      case r'$unsigned':
        return '$args';
      case r'$bits':
        return '$args.width';
      case r'$clog2':
        return '$args.clog2()';
      case r'$size':
        return '$args.width';
      default:
        // Regular function call
        return '${expr.functionName}($args)';
    }
  }

  String _generatePartSelect(PartSelectExpression expr) {
    final base = generate(expr.base);
    final msb = generate(expr.msb);
    final lsb = generate(expr.lsb);
    return '$base[$msb:$lsb]';
  }
}
