// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

import '../ir/ir.dart';
import 'naming_strategy.dart';

/// Generates ROHD signal declarations from IR signal declarations.
class SignalGenerator {
  final NamingStrategy namingStrategy;

  SignalGenerator({required this.namingStrategy});

  /// Generate signal declaration code.
  void generateSignal(StringBuffer buffer, SignalDeclaration signal) {
    final name = namingStrategy.toCamelCase(signal.name);
    final width = _getWidth(signal.width);

    // In ROHD, internal signals are declared as Logic
    buffer
        .write('final $name = Logic(name: \'${signal.name}\', width: $width)');

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
