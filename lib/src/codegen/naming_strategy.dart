// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

/// Naming strategy for code generation.
///
/// Converts SystemVerilog identifiers to appropriate Dart/ROHD naming conventions.
class NamingStrategy {
  const NamingStrategy();

  /// Convert to PascalCase class name.
  String toClassName(String name) {
    final parts = name.split('_');
    return parts
        .map(
          (p) => p.isEmpty
              ? ''
              : '${p[0].toUpperCase()}${p.substring(1).toLowerCase()}',
        )
        .join();
  }

  /// Convert to camelCase variable name.
  String toCamelCase(String name) {
    final className = toClassName(name);
    if (className.isEmpty) return className;
    return '${className[0].toLowerCase()}${className.substring(1)}';
  }

  /// Convert to snake_case (preserves original for signal names).
  String toSnakeCase(String name) {
    return name;
  }
}
