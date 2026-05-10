// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

import '../common/common.dart';
import 'symbol.dart';
import 'type_analyzer.dart';
import '../ir/ir.dart';

/// Information about an analyzed expression.
class ExpressionInfo {
  final TypeInfo type;
  final bool isConstant;
  final dynamic constValue;
  final Set<String> referencedSignals = {};
  final Set<String> referencedParameters = {};

  const ExpressionInfo({
    required this.type,
    this.isConstant = false,
    this.constValue,
    this.referencedSignals = const {},
    this.referencedParameters = const {},
  });

  factory ExpressionInfo.variable(String name, TypeInfo type) => ExpressionInfo(
        type: type,
        referencedSignals: {name},
      );

  factory ExpressionInfo.constant(dynamic value, TypeInfo type) => ExpressionInfo(
        type: type,
        isConstant: true,
        constValue: value,
      );

  /// Merge with another expression info.
  ExpressionInfo merge(ExpressionInfo other) {
    return ExpressionInfo(
      type: type,
      isConstant: isConstant && other.isConstant,
      constValue: isConstant ? constValue : null,
      referencedSignals: {...referencedSignals, ...other.referencedSignals},
      referencedParameters: {
        ...referencedParameters,
        ...other.referencedParameters
      },
    );
  }
}

/// Analyzer for SystemVerilog expressions.
class ExpressionAnalyzer {
  final TypeAnalyzer typeAnalyzer;
  final Map<String, dynamic> _parameterValues = {};

  ExpressionAnalyzer({
    required this.typeAnalyzer,
  });

  /// Set parameter values for constant evaluation.
  void setParameter(String name, dynamic value) {
    _parameterValues[name] = value;
  }

  /// Analyze an expression and return its info.
  ExpressionInfo analyze(IrExpression expr) {
    if (expr is LiteralExpression) {
      return _analyzeLiteral(expr);
    } else if (expr is IdentifierExpression) {
      return _analyzeIdentifier(expr);
    } else if (expr is BinaryExpression) {
      return _analyzeBinaryOp(expr);
    } else if (expr is UnaryExpression) {
      return _analyzeUnaryOp(expr);
    } else if (expr is ConditionalExpression) {
      return _analyzeConditional(expr);
    } else if (expr is ConcatenationExpression) {
      return _analyzeConcatenation(expr);
    } else if (expr is FunctionCallExpression) {
      return _analyzeFunctionCall(expr);
    } else if (expr is PartSelectExpression) {
      return _analyzePartSelect(expr);
    }
    return ExpressionInfo(type: TypeInfo.logic1());
  }

  ExpressionInfo _analyzeLiteral(LiteralExpression expr) {
    final type = typeAnalyzer.getExpressionType(expr);
    return ExpressionInfo.constant(expr.value, type);
  }

  ExpressionInfo _analyzeIdentifier(IdentifierExpression expr) {
    // Check if it's a parameter
    if (_parameterValues.containsKey(expr.identifier)) {
      final value = _parameterValues[expr.identifier];
      final type = TypeInfo.logic(
        _getWidthFromValue(value),
        signed: value is int && value < 0,
      );
      return ExpressionInfo.constant(value, type);
    }

    // Otherwise it's a signal reference
    final type = TypeInfo.logic1();
    return ExpressionInfo.variable(expr.identifier, type);
  }

  ExpressionInfo _analyzeBinaryOp(BinaryExpression expr) {
    final leftInfo = analyze(expr.left);
    final rightInfo = analyze(expr.right);

    final resultType = typeAnalyzer.getExpressionType(expr);
    final isConst = leftInfo.isConstant && rightInfo.isConstant;

    dynamic constValue;
    if (isConst) {
      constValue = _foldBinary(expr.operator, leftInfo.constValue, rightInfo.constValue);
    }

    return ExpressionInfo(
      type: resultType,
      isConstant: isConst,
      constValue: constValue,
      referencedSignals: {
        ...leftInfo.referencedSignals,
        ...rightInfo.referencedSignals
      },
      referencedParameters: {
        ...leftInfo.referencedParameters,
        ...rightInfo.referencedParameters
      },
    ).merge(leftInfo).merge(rightInfo);
  }

  ExpressionInfo _analyzeUnaryOp(UnaryExpression expr) {
    final operandInfo = analyze(expr.operand);

    final resultType = typeAnalyzer.getExpressionType(expr);
    final isConst = operandInfo.isConstant;

    dynamic constValue;
    if (isConst) {
      constValue = _foldUnary(expr.operator, operandInfo.constValue);
    }

    return ExpressionInfo(
      type: resultType,
      isConstant: isConst,
      constValue: constValue,
      referencedSignals: operandInfo.referencedSignals,
      referencedParameters: operandInfo.referencedParameters,
    );
  }

  ExpressionInfo _analyzeConditional(ConditionalExpression expr) {
    final condInfo = analyze(expr.condition);
    final trueInfo = analyze(expr.trueExpr);
    final falseInfo = analyze(expr.falseExpr);

    final resultType = typeAnalyzer.getExpressionType(expr);
    final isConst = condInfo.isConstant && trueInfo.isConstant && falseInfo.isConstant;

    return ExpressionInfo(
      type: resultType,
      isConstant: isConst,
      referencedSignals: {
        ...condInfo.referencedSignals,
        ...trueInfo.referencedSignals,
        ...falseInfo.referencedSignals,
      },
      referencedParameters: {
        ...condInfo.referencedParameters,
        ...trueInfo.referencedParameters,
        ...falseInfo.referencedParameters,
      },
    );
  }

  ExpressionInfo _analyzeConcatenation(ConcatenationExpression expr) {
    final type = typeAnalyzer.getExpressionType(expr);
    final signals = <String>{};
    final params = <String>{};

    for (final subExpr in expr.expressions) {
      final info = analyze(subExpr);
      signals.addAll(info.referencedSignals);
      params.addAll(info.referencedParameters);
    }

    return ExpressionInfo(
      type: type,
      referencedSignals: signals,
      referencedParameters: params,
    );
  }

  ExpressionInfo _analyzeFunctionCall(FunctionCallExpression expr) {
    // Handle system functions
    if (expr.functionName == r'$bits') {
      // $bits returns number of bits
      if (expr.arguments.isNotEmpty) {
        final argInfo = analyze(expr.arguments.first);
        return ExpressionInfo(
          type: TypeInfo.integer(),
          isConstant: argInfo.isConstant,
          constValue: argInfo.type.width,
          referencedSignals: argInfo.referencedSignals,
          referencedParameters: argInfo.referencedParameters,
        );
      }
    } else if (expr.functionName == r'$clog2') {
      // $clog2 returns ceiling log2
      if (expr.arguments.isNotEmpty) {
        final argInfo = analyze(expr.arguments.first);
        int? constValue;
        if (argInfo.isConstant && argInfo.constValue is int) {
          constValue = (argInfo.constValue as int).bitLength;
        }
        return ExpressionInfo(
          type: TypeInfo.integer(),
          isConstant: argInfo.isConstant && constValue != null,
          constValue: constValue,
          referencedSignals: argInfo.referencedSignals,
          referencedParameters: argInfo.referencedParameters,
        );
      }
    }

    return ExpressionInfo(
      type: TypeInfo.logic1(),
      referencedSignals: expr.arguments
          .expand((a) => analyze(a).referencedSignals)
          .toSet(),
      referencedParameters: expr.arguments
          .expand((a) => analyze(a).referencedParameters)
          .toSet(),
    );
  }

  ExpressionInfo _analyzePartSelect(PartSelectExpression expr) {
    final baseInfo = analyze(expr.base);
    return ExpressionInfo(
      type: TypeInfo.logic1(),
      referencedSignals: baseInfo.referencedSignals,
      referencedParameters: baseInfo.referencedParameters,
    );
  }

  dynamic _foldBinary(BinaryOperator op, dynamic left, dynamic right) {
    if (left is! int || right is! int) return null;

    switch (op) {
      case BinaryOperator.add:
        return left + right;
      case BinaryOperator.subtract:
        return left - right;
      case BinaryOperator.multiply:
        return left * right;
      case BinaryOperator.divide:
        return right != 0 ? left ~/ right : null;
      case BinaryOperator.modulo:
        return right != 0 ? left % right : null;
      case BinaryOperator.and:
        return left & right;
      case BinaryOperator.or:
        return left | right;
      case BinaryOperator.xor:
        return left ^ right;
      default:
        return null;
    }
  }

  dynamic _foldUnary(UnaryOperator op, dynamic operand) {
    if (operand is! int) return null;

    switch (op) {
      case UnaryOperator.plus:
        return operand;
      case UnaryOperator.minus:
        return -operand;
      case UnaryOperator.bitwiseNot:
        return ~operand;
      case UnaryOperator.logicalNot:
        return operand == 0 ? 1 : 0;
    }
  }

  int _getWidthFromValue(dynamic value) {
    if (value is int) {
      if (value == 0) return 1;
      return value >= 0 ? value.bitLength : (-value - 1).bitLength + 1;
    }
    return 1;
  }
}
