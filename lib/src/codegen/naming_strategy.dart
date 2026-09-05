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

  /// Public type names exported by `package:rohd/rohd.dart`. A generated module
  /// class colliding with one of these produces a Dart name clash ("X is
  /// imported from both …"), so the class name is escaped with a trailing
  /// underscore. The SystemVerilog module name is preserved separately (via
  /// `super(name: …)`), so the escape is Dart-only and does not affect the
  /// generated SystemVerilog.
  static const Set<String> _rohdReservedTypes = {
    'Add', 'And2Gate', 'AndUnary', 'ARShift', 'BusSubset', 'Case', 'CaseItem',
    'CaseZ', 'Combinational', 'Conditional', 'ConditionalAssign',
    'ConditionalGroup', 'Config', 'Const', 'Divide', 'Dumper', 'Else',
    'ElseIf', 'Equals', 'ExternalModule', 'FF', 'FiniteStateMachine',
    'FlipFlop', 'GreaterThan', 'GreaterThanOrEqual', 'If', 'IfBlock', 'Iff',
    'IndexGate', 'Interface', 'LessThan', 'LessThanOrEqual', 'Logic',
    'LogicArray', 'LogicNet', 'LogicStructure', 'LogicValue', 'LShift',
    'Module', 'Modulo', 'Multiply', 'Mux', 'Namer', 'Naming', 'NotGate',
    'Or2Gate', 'OrUnary', 'Passthrough', 'Pipeline', 'Port', 'Power',
    'ReadyValidPipeline', 'ReplicationOp', 'RShift', 'Sanitizer', 'Sequential',
    'SimpleClockGenerator', 'Simulator', 'SsaLogic', 'State', 'StateMachine',
    'Subtract', 'Swizzle', 'SystemVerilog', 'Timestamper', 'TriStateBuffer',
    'Vector', 'WaveDumper', 'Xor2Gate', 'XorUnary',
  };

  /// Raw PascalCase conversion (no reserved-name escaping).
  String _pascalCase(String name) => name
      .split('_')
      .map(
        (p) => p.isEmpty
            ? ''
            : '${p[0].toUpperCase()}${p.substring(1).toLowerCase()}',
      )
      .join();

  /// Convert to PascalCase class name.
  ///
  /// A module class becomes a top-level Dart type, so a name clashing with a
  /// Dart reserved word (`Function`) or a ROHD-exported type (`Mux`,
  /// `Pipeline`, …) is escaped with a trailing underscore. This escape is not
  /// applied to signal/variable names ([toCamelCase]), which live in a
  /// different namespace and do not clash with ROHD type names.
  String toClassName(String name) {
    final className = _pascalCase(name);
    if (className == 'Function' || _rohdReservedTypes.contains(className)) {
      return '${className}_';
    }
    return className;
  }

  /// Convert to camelCase variable name.
  String toCamelCase(String name) {
    var className = _pascalCase(name);
    if (className.isEmpty) return className;
    // Historical escape: `Function` is a built-in type name.
    if (className == 'Function') className = 'Function_';
    final camel = '${className[0].toLowerCase()}${className.substring(1)}';
    return _dartReserved.contains(camel) ? '${camel}_' : camel;
  }

  /// Convert to snake_case (preserves original for signal names).
  String toSnakeCase(String name) {
    return name;
  }
}
