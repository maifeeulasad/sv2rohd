// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

// Symbolic width computation used by the code generator. Parts of this
// implementation were generated with LLM assistance.

import '../ir/ir.dart';
import 'naming_strategy.dart';

/// A linear combination of parameter names with integer coefficients plus a
/// constant, e.g. `2*width - 1`. Used to reason symbolically about signal
/// widths that depend on module parameters.
class LinearExpr {
  /// Coefficients per (camelCase) parameter name.
  final Map<String, int> coeffs;
  final int constant;

  const LinearExpr(this.coeffs, this.constant);

  factory LinearExpr.constant(int value) => LinearExpr(const {}, value);

  factory LinearExpr.variable(String name) => LinearExpr({name: 1}, 0);

  bool get isConstant => coeffs.values.every((c) => c == 0);

  int? get asConstant => isConstant ? constant : null;

  LinearExpr operator +(LinearExpr other) {
    final merged = Map<String, int>.from(coeffs);
    other.coeffs.forEach((k, v) => merged[k] = (merged[k] ?? 0) + v);
    return LinearExpr(merged, constant + other.constant);
  }

  LinearExpr operator -(LinearExpr other) {
    final merged = Map<String, int>.from(coeffs);
    other.coeffs.forEach((k, v) => merged[k] = (merged[k] ?? 0) - v);
    return LinearExpr(merged, constant - other.constant);
  }

  LinearExpr scale(int factor) {
    final scaled = coeffs.map((k, v) => MapEntry(k, v * factor));
    return LinearExpr(scaled, constant * factor);
  }

  bool equalsExpr(LinearExpr other) {
    final diff = this - other;
    return diff.isConstant && diff.constant == 0;
  }

  /// Renders this linear expression as Dart source (an `int` expression).
  String render() {
    final parts = <String>[];
    final names = coeffs.keys.toList()..sort();
    for (final name in names) {
      final c = coeffs[name]!;
      if (c == 0) continue;
      if (c == 1) {
        parts.add(name);
      } else if (c == -1) {
        parts.add('-$name');
      } else {
        parts.add('$c * $name');
      }
    }
    if (constant != 0 || parts.isEmpty) {
      parts.add('$constant');
    }
    var result = parts.first;
    for (final part in parts.skip(1)) {
      result += part.startsWith('-') ? ' - ${part.substring(1)}' : ' + $part';
    }
    return result;
  }
}

/// Computes symbolic widths of IR expressions given the declared widths of
/// module signals and the set of elaboration-time (int-domain) names.
class WidthAnalyzer {
  final NamingStrategy namingStrategy;

  /// Declared width per SV signal/port name.
  final Map<String, VectorWidth?> signalWidths = {};

  /// camelCase names of parameters, genvars, and loop variables — values that
  /// are Dart ints at module construction time.
  final Set<String> intDomain = {};

  /// SV names of unpacked-array signals (represented as nested `List<Logic>`).
  final Set<String> arraySignals = {};

  /// Number of unpacked dimensions per array signal.
  final Map<String, int> arrayDimensions = {};

  WidthAnalyzer({required this.namingStrategy});

  /// Converts an elaboration-time IR expression to linear form, or null when
  /// it is not linear (or references hardware signals).
  LinearExpr? linearOf(IrExpression? expr) {
    if (expr == null) return null;
    if (expr is LiteralExpression) {
      final v = expr.value;
      return v is int ? LinearExpr.constant(v) : null;
    }
    if (expr is IdentifierExpression) {
      final name = namingStrategy.toCamelCase(expr.identifier);
      if (intDomain.contains(name)) return LinearExpr.variable(name);
      return null;
    }
    if (expr is UnaryExpression) {
      final inner = linearOf(expr.operand);
      if (inner == null) return null;
      return switch (expr.operator) {
        UnaryOperator.plus => inner,
        UnaryOperator.minus => inner.scale(-1),
        _ => null,
      };
    }
    if (expr is BinaryExpression) {
      final left = linearOf(expr.left);
      final right = linearOf(expr.right);
      if (left == null || right == null) return null;
      switch (expr.operator) {
        case BinaryOperator.add:
          return left + right;
        case BinaryOperator.subtract:
          return left - right;
        case BinaryOperator.multiply:
          if (left.isConstant) return right.scale(left.constant);
          if (right.isConstant) return left.scale(right.constant);
          return null;
        default:
          return null;
      }
    }
    return null;
  }

  /// Width of a declared vector as linear form: msb - lsb + 1 (1 for scalars).
  LinearExpr? widthOfVector(VectorWidth? width) {
    if (width == null) return LinearExpr.constant(1);
    final msb = linearOf(width.msb);
    final lsb = linearOf(width.lsb);
    if (msb == null || lsb == null) return null;
    return msb - lsb + LinearExpr.constant(1);
  }

  /// Symbolic width of a hardware expression, or null when unknown.
  LinearExpr? widthOfExpr(IrExpression expr) {
    if (expr is LiteralExpression) {
      return expr.width != null ? LinearExpr.constant(expr.width!) : null;
    }
    if (expr is IdentifierExpression) {
      final camel = namingStrategy.toCamelCase(expr.identifier);
      if (intDomain.contains(camel)) return null;
      if (!signalWidths.containsKey(expr.identifier)) return null;
      return widthOfVector(signalWidths[expr.identifier]);
    }
    if (expr is IndexedPartSelectExpression) {
      // Unwind a chain of index selects (e.g. mem[a][b][c]) down to its
      // base identifier, counting the indices applied.
      var indexCount = 0;
      IrExpression cursor = expr;
      while (cursor is IndexedPartSelectExpression) {
        indexCount++;
        cursor = cursor.base;
      }
      if (cursor is IdentifierExpression &&
          arraySignals.contains(cursor.identifier)) {
        final dims = arrayDimensions[cursor.identifier] ?? 1;
        if (indexCount < dims) {
          // Still an array/list, not a scalar hardware value.
          return null;
        }
        final elementWidth = widthOfVector(signalWidths[cursor.identifier]);
        // Any indices beyond the unpacked dims are bit-selects on the
        // element Logic; each single-bit select yields width 1.
        if (indexCount == dims) return elementWidth;
        return LinearExpr.constant(1);
      }
      // Bit-select on an ordinary vector signal.
      return LinearExpr.constant(1);
    }
    if (expr is PartSelectExpression) {
      final msb = linearOf(expr.msb);
      final lsb = linearOf(expr.lsb);
      if (msb == null || lsb == null) return null;
      return msb - lsb + LinearExpr.constant(1);
    }
    if (expr is ConcatenationExpression) {
      var total = LinearExpr.constant(0);
      for (final part in expr.expressions) {
        final w = widthOfExpr(part);
        if (w == null) return null;
        total = total + w;
      }
      return total;
    }
    if (expr is ReplicationExpression) {
      final count = linearOf(expr.count);
      final w = widthOfExpr(expr.operand);
      if (count == null || w == null) return null;
      if (count.isConstant) return w.scale(count.constant);
      if (w.isConstant) return count.scale(w.constant);
      return null;
    }
    if (expr is UnaryExpression) {
      return switch (expr.operator) {
        UnaryOperator.logicalNot ||
        UnaryOperator.reductionAnd ||
        UnaryOperator.reductionOr ||
        UnaryOperator.reductionXor ||
        UnaryOperator.reductionNand ||
        UnaryOperator.reductionNor ||
        UnaryOperator.reductionXnor =>
          LinearExpr.constant(1),
        _ => widthOfExpr(expr.operand),
      };
    }
    if (expr is BinaryExpression) {
      switch (expr.operator) {
        case BinaryOperator.equal:
        case BinaryOperator.notEqual:
        case BinaryOperator.caseEqual:
        case BinaryOperator.caseNotEqual:
        case BinaryOperator.lessThan:
        case BinaryOperator.lessThanOrEqual:
        case BinaryOperator.greaterThan:
        case BinaryOperator.greaterThanOrEqual:
        case BinaryOperator.logicalAnd:
        case BinaryOperator.logicalOr:
          return LinearExpr.constant(1);
        case BinaryOperator.shiftLeft:
        case BinaryOperator.shiftRight:
        case BinaryOperator.arithmeticShiftLeft:
        case BinaryOperator.arithmeticShiftRight:
          return widthOfExpr(expr.left);
        default:
          final left = widthOfExpr(expr.left);
          final right = widthOfExpr(expr.right);
          if (left == null) return right;
          if (right == null) return left;
          // Operands of equal symbolic width produce that width; otherwise
          // the wider operand wins when the difference is a known constant.
          final diff = left - right;
          if (diff.isConstant) {
            return diff.constant >= 0 ? left : right;
          }
          return null;
      }
    }
    if (expr is ConditionalExpression) {
      final t = widthOfExpr(expr.trueExpr);
      final f = widthOfExpr(expr.falseExpr);
      if (t == null) return f;
      if (f == null) return t;
      final diff = t - f;
      if (diff.isConstant) return diff.constant >= 0 ? t : f;
      return null;
    }
    return null;
  }
}
