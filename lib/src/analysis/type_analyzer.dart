// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

import '../common/common.dart';
import 'symbol.dart';
import 'semantic_analyzer.dart';
import '../ir/ir.dart';

/// Type information for expressions and signals.
class TypeInfo {
  final String name;
  final int? width;
  final bool isSigned;
  final bool isFourState; // Supports X and Z

  const TypeInfo({
    required this.name,
    this.width,
    this.isSigned = false,
    this.isFourState = false,
  });

  factory TypeInfo.logic(int width, {bool signed = false}) => TypeInfo(
        name: 'logic',
        width: width,
        isSigned: signed,
        isFourState: true,
      );

  factory TypeInfo.bit(int width, {bool signed = false}) => TypeInfo(
        name: 'bit',
        width: width,
        isSigned: signed,
        isFourState: false,
      );

  factory TypeInfo.integer() => const TypeInfo(
        name: 'integer',
        width: 32,
        isSigned: true,
        isFourState: true,
      );

  factory TypeInfo.real() => const TypeInfo(
        name: 'real',
        width: null,
        isSigned: true,
        isFourState: false,
      );

  factory TypeInfo.logic1() => const TypeInfo(
        name: 'logic',
        width: 1,
        isSigned: false,
        isFourState: true,
      );

  /// Check if this type can be assigned to another type.
  bool canAssignTo(TypeInfo other) {
    // Same type
    if (name == other.name && width == other.width) {
      return true;
    }
    // Width compatible
    if (width != null && other.width != null) {
      return width! <= other.width!;
    }
    return false;
  }

  /// Get promoted type for operations.
  TypeInfo get promoted {
    if (isFourState && !isSigned) {
      return TypeInfo.logic(width ?? 32, signed: true);
    }
    return this;
  }

  @override
  String toString() {
    if (width != null) {
      return '$name[$width]';
    }
    return name;
  }
}

/// Type analyzer for SystemVerilog expressions.
class TypeAnalyzer {
  final DiagnosticCollector diagnostics;
  final Map<String, TypeInfo> _types = {};

  TypeAnalyzer({
    required this.diagnostics,
  }) {
    // Register default types
    _types['logic'] = const TypeInfo(name: 'logic', isFourState: true);
    _types['bit'] = const TypeInfo(name: 'bit', isFourState: false);
    _types['integer'] = TypeInfo.integer();
    _types['int'] = const TypeInfo(name: 'int', width: 32, isSigned: true);
    _types['shortint'] =
        const TypeInfo(name: 'shortint', width: 16, isSigned: true);
    _types['longint'] =
        const TypeInfo(name: 'longint', width: 64, isSigned: true);
    _types['byte'] = const TypeInfo(name: 'byte', width: 8, isSigned: true);
    _types['real'] = TypeInfo.real();
  }

  /// Get type information for a signal.
  TypeInfo getSignalType(SignalDeclaration signal) {
    final width = _getWidth(signal.width);
    final isSigned = false; // Would need to check declaration

    switch (signal.signalType) {
      case SignalType.logic:
        return TypeInfo.logic(width ?? 1, signed: isSigned);
      case SignalType.wire:
        return TypeInfo.logic(width ?? 1, signed: isSigned);
      case SignalType.reg:
        return TypeInfo.logic(width ?? 1, signed: isSigned);
      case SignalType.bit:
        return TypeInfo.bit(width ?? 1, signed: isSigned);
    }
  }

  /// Get type information for an expression.
  TypeInfo getExpressionType(IrExpression expr) {
    if (expr is LiteralExpression) {
      return _getLiteralType(expr);
    } else if (expr is IdentifierExpression) {
      // Would need symbol table lookup
      return TypeInfo.logic1();
    } else if (expr is BinaryExpression) {
      return _getBinaryExpressionType(expr);
    } else if (expr is UnaryExpression) {
      return _getUnaryExpressionType(expr);
    } else if (expr is ConditionalExpression) {
      return _getConditionalType(expr);
    } else if (expr is ConcatenationExpression) {
      return _getConcatenationType(expr);
    } else if (expr is FunctionCallExpression) {
      // Would need function declaration lookup
      return TypeInfo.logic1();
    } else if (expr is PartSelectExpression) {
      return TypeInfo.logic1();
    }
    return TypeInfo.logic1();
  }

  TypeInfo _getLiteralType(LiteralExpression literal) {
    switch (literal.kind) {
      case LiteralKind.integer:
        final value = literal.value as int;
        // Determine width from value
        if (value >= 0) {
          final bits = value == 0 ? 1 : (value.bitLength);
          return TypeInfo.logic(bits, signed: false);
        } else {
          final bits = (-value - 1).bitLength + 1;
          return TypeInfo.logic(bits, signed: true);
        }
      case LiteralKind.real:
        return TypeInfo.real();
      case LiteralKind.string:
        return TypeInfo.logic(literal.value.toString().length * 8);
      case LiteralKind.time:
        return TypeInfo.logic(64);
      case LiteralKind.bitVector:
        return TypeInfo.logic(
            (literal.value as List).length,
            signed: false);
    }
  }

  TypeInfo _getBinaryExpressionType(BinaryExpression expr) {
    final leftType = getExpressionType(expr.left);
    final rightType = getExpressionType(expr.right);

    switch (expr.operator) {
      case BinaryOperator.add:
      case BinaryOperator.subtract:
      case BinaryOperator.multiply:
      case BinaryOperator.divide:
      case BinaryOperator.modulo:
        // Arithmetic: result width = max(left, right) + 1 for multiply
        int resultWidth;
        if (expr.operator == BinaryOperator.multiply) {
          resultWidth = (leftType.width ?? 1) + (rightType.width ?? 1);
        } else {
          resultWidth = (leftType.width ?? 1) > (rightType.width ?? 1)
              ? leftType.width!
              : rightType.width!;
        }
        final isSigned = leftType.isSigned && rightType.isSigned;
        return TypeInfo.logic(resultWidth, signed: isSigned);

      case BinaryOperator.and:
      case BinaryOperator.or:
      case BinaryOperator.xor:
      case BinaryOperator.xnor:
      case BinaryOperator.nand:
      case BinaryOperator.nor:
      case BinaryOperator.nxor:
        // Bitwise: result width = max(left, right)
        final resultWidth = (leftType.width ?? 1) > (rightType.width ?? 1)
            ? leftType.width!
            : rightType.width!;
        return TypeInfo.logic(resultWidth, signed: false);

      case BinaryOperator.equal:
      case BinaryOperator.notEqual:
      case BinaryOperator.caseEqual:
      case BinaryOperator.caseNotEqual:
      case BinaryOperator.lessThan:
      case BinaryOperator.lessThanOrEqual:
      case BinaryOperator.greaterThan:
      case BinaryOperator.greaterThanOrEqual:
        // Comparison: result width = 1
        return TypeInfo.logic1();

      case BinaryOperator.logicalAnd:
      case BinaryOperator.logicalOr:
        // Logical: result width = 1
        return TypeInfo.logic1();

      case BinaryOperator.shiftLeft:
      case BinaryOperator.shiftRight:
      case BinaryOperator.arithmeticShiftLeft:
      case BinaryOperator.arithmeticShiftRight:
        // Shift: result width = left operand width
        return leftType;

      default:
        return TypeInfo.logic1();
    }
  }

  TypeInfo _getUnaryExpressionType(UnaryExpression expr) {
    final operandType = getExpressionType(expr.operand);

    switch (expr.operator) {
      case UnaryOperator.bitwiseNot:
        // ~ : same width
        return operandType;
      case UnaryOperator.logicalNot:
        // ! : 1 bit result
        return TypeInfo.logic1();
      case UnaryOperator.plus:
      case UnaryOperator.minus:
        // Unary +/-: result width = operand width + 1
        return TypeInfo.logic((operandType.width ?? 1) + 1, signed: true);
    }
  }

  TypeInfo _getConditionalType(ConditionalExpression expr) {
    final trueType = getExpressionType(expr.trueExpr);
    final falseType = getExpressionType(expr.falseExpr);

    // Result type is max of true and false branch types
    final width = (trueType.width ?? 1) > (falseType.width ?? 1)
        ? trueType.width
        : falseType.width;
    final isSigned = trueType.isSigned && falseType.isSigned;

    return TypeInfo.logic(width ?? 1, signed: isSigned);
  }

  TypeInfo _getConcatenationType(ConcatenationExpression expr) {
    int totalWidth = 0;
    for (final subExpr in expr.expressions) {
      final type = getExpressionType(subExpr);
      totalWidth += type.width ?? 1;
    }
    return TypeInfo.logic(totalWidth);
  }

  int? _getWidth(VectorWidth? width) {
    if (width == null || width.msb == null || width.lsb == null) {
      return null;
    }
    if (width.msb is LiteralExpression && width.lsb is LiteralExpression) {
      final msb = (width.msb as LiteralExpression).value as int;
      final lsb = (width.lsb as LiteralExpression).value as int;
      return (msb - lsb + 1).abs();
    }
    return null;
  }

  /// Check assignment type compatibility.
  bool checkAssignment(IrExpression target, IrExpression value) {
    final targetType = getExpressionType(target);
    final valueType = getExpressionType(value);

    if (!valueType.canAssignTo(targetType)) {
      diagnostics.warning(
        'Type mismatch: ${valueType} cannot be assigned to ${targetType}',
        code: 'TYPE001',
      );
      return false;
    }
    return true;
  }
}
