// Copyright (C) 2026
// SPDX-License-Identifier: BSD-3-Clause

import '../ir/ir.dart';

/// Generates ROHD signal declarations from IR signal declarations.
class SignalGenerator {
  final NamingStrategy namingStrategy;

  SignalGenerator({required this.namingStrategy});

  /// Generate signal declaration code.
  void generateSignal(StringBuffer buffer, SignalDeclaration signal) {
    final name = namingStrategy.toCamelCase(signal.name);
    final width = _getWidth(signal.width);

    // In ROHD, internal signals are declared as Logic
    buffer.write('final $name = Logic(name: \'${signal.name}\', width: $width)');

    if (signal.initialValue != null) {
      buffer.write('; // TODO: Initial value');
    }
    buffer.writeln(';');
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
}

/// Simple naming strategy.
class NamingStrategy {
  const NamingStrategy();

  String toClassName(String name) {
    final parts = name.split('_');
    return parts
        .map((p) => p.isEmpty ? '' : '${p[0].toUpperCase()}${p.substring(1).toLowerCase()}')
        .join();
  }

  String toCamelCase(String name) {
    final className = toClassName(name);
    if (className.isEmpty) return className;
    return '${className[0].toLowerCase()}${className.substring(1)}';
  }
}
