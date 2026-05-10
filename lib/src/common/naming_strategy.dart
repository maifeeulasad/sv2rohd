// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

/// Naming strategy for converting SystemVerilog identifiers to Dart.
class NamingStrategy {
  /// Dart keywords that cannot be used as identifiers.
  static const Set<String> dartKeywords = {
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
    'Function',
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

  /// SystemVerilog keywords.
  static const Set<String> svKeywords = {
    'module',
    'endmodule',
    'input',
    'output',
    'inout',
    'logic',
    'wire',
    'reg',
    'bit',
    'byte',
    'int',
    'integer',
    'shortint',
    'longint',
    'shortreal',
    'real',
    'time',
    'typedef',
    'enum',
    'struct',
    'union',
    'package',
    'import',
    'export',
    'parameter',
    'localparam',
    'always',
    'always_ff',
    'always_comb',
    'always_latch',
    'assign',
    'initial',
    'begin',
    'end',
    'if',
    'else',
    'case',
    'endcase',
    'default',
    'for',
    'while',
    'repeat',
    'foreach',
    'do',
    'break',
    'continue',
    'return',
    'function',
    'endfunction',
    'task',
    'endtask',
    'class',
    'endclass',
    'extends',
    'implements',
    'super',
    'this',
    'new',
    'delete',
    'const',
    'final',
    'static',
    'private',
    'public',
    'protected',
    'virtual',
    'pure',
    'interface',
    'endinterface',
    'modport',
    'clocking',
    'endclocking',
    'property',
    'endproperty',
    'sequence',
    'endsequence',
    'rand',
    'randc',
    'constraint',
    'covergroup',
    'endgroup',
    'coverpoint',
    'cross',
    'assert',
    'assume',
    'cover',
    'expect',
    'bind',
    'force',
    'release',
    'fork',
    'join',
    'join_any',
    'join_none',
    'disable',
    'semaphore',
    'mailbox',
    'process',
    'ref',
    'automatic',
    'program',
    'endprogram',
    'checker',
    'endchecker',
  };

  /// Converts a SystemVerilog identifier to a valid Dart identifier.
  String toDart(String identifier) {
    if (identifier.isEmpty) return 'unnamed';

    // Replace invalid characters with underscores
    var result = identifier.replaceAll(RegExp(r'[^a-zA-Z0-9_]'), '_');

    // Ensure starts with letter or underscore
    if (result.isNotEmpty && RegExp(r'^[0-9]').hasMatch(result[0])) {
      result = '_$result';
    }

    result = _sanitizeDartIdentifier(result);

    // Handle Dart keywords
    if (dartKeywords.contains(result)) {
      result = '${result}_';
    }

    return result;
  }

  /// Converts to CamelCase for variable names.
  String toCamelCase(String identifier) {
    final sanitized = toDart(identifier);
    return _toCamelCase(sanitized);
  }

  /// Converts to PascalCase for class names.
  String toClassName(String identifier) {
    final sanitized = toDart(identifier);
    return _toPascalCase(sanitized);
  }

  /// Sanitizes an identifier for use as a Dart identifier.
  String _sanitizeDartIdentifier(String identifier) {
    if (identifier.isEmpty) return 'unnamed';

    // Replace multiple underscores with single
    var result = identifier.replaceAll(RegExp(r'_+'), '_');
    return result.isEmpty ? 'unnamed' : result;
  }

  /// Converts snake_case to camelCase.
  String _toCamelCase(String identifier) {
    final parts = identifier.split('_');
    if (parts.length == 1) {
      return parts[0].toLowerCase();
    }

    final buffer = StringBuffer();
    buffer.write(_lowercaseFirst(parts[0]));

    for (int i = 1; i < parts.length; i++) {
      if (parts[i].isNotEmpty) {
        buffer.write(_uppercaseFirst(parts[i]));
      }
    }

    return buffer.toString();
  }

  String _lowercaseFirst(String value) {
    if (value.isEmpty) return value;
    return value[0].toLowerCase() + value.substring(1);
  }

  String _uppercaseFirst(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }

  /// Converts snake_case to PascalCase.
  String _toPascalCase(String identifier) {
    final camel = _toCamelCase(identifier);
    if (camel.isEmpty) return 'Unnamed';

    return camel[0].toUpperCase() + camel.substring(1);
  }

  /// Resolves naming conflicts by adding a suffix.
  String resolveConflict(String name, Set<String> existing) {
    if (!existing.contains(name)) return name;

    int counter = 1;
    String candidate;
    do {
      candidate = '${name}_$counter';
      counter++;
    } while (existing.contains(candidate));

    return candidate;
  }

  /// Returns true if the identifier is a Dart keyword.
  bool isKeyword(String name) => dartKeywords.contains(name);

  /// Returns true if the identifier is a SystemVerilog keyword.
  bool isSvKeyword(String name) => svKeywords.contains(name);

  /// Adds a suffix to an identifier.
  String addSuffix(String name, String suffix) => '${name}$suffix';

  /// Adds a prefix to an identifier.
  String addPrefix(String name, String prefix) => '$prefix$name';
}
