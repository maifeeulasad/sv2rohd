// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

import '../ir/ir.dart';

/// Generates ROHD module instantiations from IR.
class InstantiationGenerator {
  final ExpressionGenerator exprGen;
  final NamingStrategy namingStrategy;

  InstantiationGenerator({
    required this.exprGen,
    required this.namingStrategy,
  });

  /// Generate module instantiation code.
  void generateInstantiation(
    StringBuffer buffer,
    ModuleInstantiation inst,
  ) {
    final instanceName = namingStrategy.toCamelCase(inst.instanceName);
    final className = namingStrategy.toClassName(inst.moduleName);

    // Generate parameter overrides if any
    if (inst.parameterValues.isNotEmpty) {
      _generateParameterizedInstantiation(buffer, className, instanceName, inst);
    } else {
      _generateSimpleInstantiation(buffer, className, instanceName, inst);
    }
  }

  void _generateParameterizedInstantiation(
    StringBuffer buffer,
    String className,
    String instanceName,
    ModuleInstantiation inst,
  ) {
    // For parameterized modules, we pass parameters in the constructor
    final params = <String>[];
    for (final param in inst.parameterValues) {
      params.add(exprGen.generate(param));
    }

    // Generate port connections
    final portConns = <String>[];
    for (final conn in inst.portConnections) {
      portConns.add(_generatePortConnection(conn));
    }

    buffer.write('final $instanceName = $className(');
    buffer.write(params.join(', '));
    if (portConns.isNotEmpty) {
      if (params.isNotEmpty) buffer.write(', ');
      buffer.write(portConns.join(', '));
    }
    buffer.writeln(');');
  }

  void _generateSimpleInstantiation(
    StringBuffer buffer,
    String className,
    String instanceName,
    ModuleInstantiation inst,
  ) {
    // Generate port connections
    final portConns = <String>[];
    for (final conn in inst.portConnections) {
      portConns.add(_generatePortConnection(conn));
    }

    buffer.write('final $instanceName = $className(');
    buffer.write(portConns.join(', '));
    buffer.writeln(');');
  }

  String _generatePortConnection(PortConnection conn) {
    final portName = namingStrategy.toCamelCase(conn.portName);

    if (conn.value != null) {
      final value = exprGen.generate(conn.value!);
      return '$portName: $value';
    } else {
      // Connected to signal with same name
      return portName;
    }
  }
}

/// Naming strategy for code generation.
class NamingStrategy {
  const NamingStrategy();

  String toClassName(String name) {
    final parts = name.split('_');
    return parts
        .map(
          (p) => p.isEmpty ? '' : '${p[0].toUpperCase()}${p.substring(1).toLowerCase()}',
        )
        .join();
  }

  String toCamelCase(String name) {
    final className = toClassName(name);
    if (className.isEmpty) return className;
    return '${className[0].toLowerCase()}${className.substring(1)}';
  }
}