// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

import '../ir/ir.dart';
import 'expression_generator.dart';
import 'signal_generator.dart';
import 'naming_strategy.dart';

/// Generates ROHD module classes from IR module declarations.
class ModuleGenerator {
  final ExpressionGenerator exprGen;
  final SignalGenerator signalGen;
  final NamingStrategy namingStrategy;

  ModuleGenerator({
    required this.exprGen,
    required this.signalGen,
    required this.namingStrategy,
  });

  /// Generate module declaration.
  String generate(ModuleDeclaration module) {
    final buffer = StringBuffer();
    final className = namingStrategy.toClassName(module.name);

    // Generate constructor parameters
    final params = _generateConstructorParams(module);

    // Generate class
    buffer.writeln('class $className extends Module {');
    buffer.writeln('  $className($params) : super(name: \'${module.name}\') {');
    buffer.writeln('    build();');
    buffer.writeln('  }');
    buffer.writeln();
    buffer.writeln('  @override');
    buffer.writeln('  void build() {');

    // Generate ports
    for (final port in module.ports) {
      _generatePort(buffer, port);
    }

    // Generate internal signals
    for (final item in module.items) {
      if (item is SignalDeclaration) {
        signalGen.generateSignal(buffer, item);
      }
    }

    buffer.writeln('  }');
    buffer.writeln('}');

    return buffer.toString();
  }

  String _generateConstructorParams(ModuleDeclaration module) {
    final params = <String>[];

    // Add parameter declarations
    for (final param in module.parameters) {
      final paramName = namingStrategy.toCamelCase(param.name);
      final defaultValue = param.defaultValue != null
          ? exprGen.generate(param.defaultValue!)
          : '0';
      params.add('int $paramName = $defaultValue');
    }

    return params.isEmpty ? '' : '{${params.join(', ')}}';
  }

  void _generatePort(StringBuffer buffer, PortDeclaration port) {
    final portName = namingStrategy.toCamelCase(port.name);
    final width = _getWidth(port.width);

    switch (port.direction) {
      case PortDirection.input:
        buffer.writeln(
            "final $portName = addInput('${port.name}', width: $width);");
        break;
      case PortDirection.output:
        buffer.writeln(
            "final $portName = addOutput('${port.name}', width: $width);");
        break;
      case PortDirection.inout:
        buffer.writeln(
            "final $portName = addInOut('${port.name}', width: $width);");
        break;
    }
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
