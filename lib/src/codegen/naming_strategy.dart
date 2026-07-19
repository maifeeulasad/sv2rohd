// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

/// Naming strategy for code generation.
///
/// Converts SystemVerilog identifiers to appropriate Dart/ROHD naming conventions.
class NamingStrategy {
  const NamingStrategy();

  /// Dart reserved words and built-in identifiers that cannot be used as a
  /// plain variable name. A generated identifier colliding with one of these
  /// is escaped with a trailing underscore (e.g. `in` -> `in_`).
  static const Set<String> _dartReserved = {
    'abstract',
    'as',
    'assert',
    'async',
    'await',
    'break',
    'case',
    'catch',
    'class',
    'const',
    'continue',
    'covariant',
    'default',
    'deferred',
    'do',
    'dynamic',
    'else',
    'enum',
    'export',
    'extends',
    'extension',
    'external',
    'factory',
    'false',
    'final',
    'finally',
    'for',
    'get',
    'hide',
    'if',
    'implements',
    'import',
    'in',
    'interface',
    'is',
    'late',
    'library',
    'mixin',
    'new',
    'null',
    'on',
    'operator',
    'part',
    'required',
    'rethrow',
    'return',
    'set',
    'show',
    'static',
    'super',
    'switch',
    'sync',
    'this',
    'throw',
    'true',
    'try',
    'typedef',
    'var',
    'void',
    'while',
    'with',
    'yield',
  };

  /// Convert to PascalCase class name.
  String toClassName(String name) {
    final parts = name.split('_');
    final className = parts
        .map(
          (p) => p.isEmpty
              ? ''
              : '${p[0].toUpperCase()}${p.substring(1).toLowerCase()}',
        )
        .join();
    // The only PascalCase-shaped Dart reserved word is `Function`.
    return className == 'Function' ? 'Function_' : className;
  }

  /// Convert to camelCase variable name.
  String toCamelCase(String name) {
    final className = toClassName(name);
    if (className.isEmpty) return className;
    final camel = '${className[0].toLowerCase()}${className.substring(1)}';
    return _dartReserved.contains(camel) ? '${camel}_' : camel;
  }

  /// Convert to snake_case (preserves original for signal names).
  String toSnakeCase(String name) {
    return name;
  }
}
