// Copyright (C) 2026
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:io';

import 'package:yaml/yaml.dart';

/// Configuration options for SV2ROHD.
class Sv2RohdConfig {
  /// Output configuration.
  final OutputConfig output;

  /// Parsing configuration.
  final ParsingConfig parsing;

  /// Code generation configuration.
  final CodegenConfig codegen;

  /// Analysis configuration.
  final AnalysisConfig analysis;

  const Sv2RohdConfig({
    this.output = const OutputConfig(),
    this.parsing = const ParsingConfig(),
    this.codegen = const CodegenConfig(),
    this.analysis = const AnalysisConfig(),
  });

  /// Load configuration from a YAML file.
  factory Sv2RohdConfig.fromFile(String path) {
    final file = File(path);
    if (!file.existsSync()) {
      throw ConfigException('Configuration file not found: $path');
    }

    final content = file.readAsStringSync();
    return Sv2RohdConfig.fromYaml(content);
  }

  /// Parse configuration from YAML string.
  factory Sv2RohdConfig.fromYaml(String yaml) {
    final doc = loadYaml(yaml);
    if (doc is! YamlMap) {
      throw ConfigException('Invalid YAML structure: expected a map');
    }

    return Sv2RohdConfig(
      output: OutputConfig.fromYaml(doc['output']),
      parsing: ParsingConfig.fromYaml(doc['parsing']),
      codegen: CodegenConfig.fromYaml(doc['codegen']),
      analysis: AnalysisConfig.fromYaml(doc['analysis']),
    );
  }

  /// Convert to YAML string.
  String toYaml() {
    final buffer = StringBuffer();
    buffer.writeln('# SV2ROHD Configuration');
    buffer.writeln('# Generated: ${DateTime.now().toIso8601String()}');
    buffer.writeln();
    buffer.writeln('output:');
    buffer.write(output.toYaml());
    buffer.writeln('parsing:');
    buffer.write(parsing.toYaml());
    buffer.writeln('codegen:');
    buffer.write(codegen.toYaml());
    buffer.writeln('analysis:');
    buffer.write(analysis.toYaml());
    return buffer.toString();
  }
}

/// Output configuration options.
class OutputConfig {
  /// Output directory for generated files.
  final String outputDir;

  /// File naming convention.
  final NamingConvention naming;

  /// Include comments in output.
  final bool includeComments;

  /// Format output code.
  final bool formatOutput;

  /// Generate source maps.
  final bool sourceMaps;

  const OutputConfig({
    this.outputDir = 'generated',
    this.naming = NamingConvention.snakeCase,
    this.includeComments = true,
    this.formatOutput = true,
    this.sourceMaps = false,
  });

  factory OutputConfig.fromYaml(YamlNode? node) {
    if (node is! YamlMap) {
      return const OutputConfig();
    }
    return OutputConfig(
      outputDir: node['output_dir'] ?? 'generated',
      naming: NamingConvention.values.firstWhere(
        (e) => e.name == node['naming'],
        orElse: () => NamingConvention.snakeCase,
      ),
      includeComments: node['include_comments'] ?? true,
      formatOutput: node['format_output'] ?? true,
      sourceMaps: node['source_maps'] ?? false,
    );
  }

  String toYaml() {
    return '''
  output_dir: $outputDir
  naming: ${naming.name}
  include_comments: $includeComments
  format_output: $formatOutput
  source_maps: $sourceMaps
''';
  }
}

/// Naming conventions for generated code.
enum NamingConvention {
  snakeCase,
  camelCase,
  PascalCase,
}

/// Parsing configuration options.
class ParsingConfig {
  /// Enable preprocessing directives.
  final bool preprocess;

  /// Include paths for `include directives.
  final List<String> includePaths;

  /// Define macros for preprocessing.
  final Map<String, String> defines;

  /// Strict SystemVerilog parsing mode.
  final bool strict;

  /// Allow SystemVerilog 2012 features.
  final bool sv2012;

  /// Allow SystemVerilog 2017 features.
  final bool sv2017;

  /// Allow SystemVerilog 2023 features.
  final bool sv2023;

  const ParsingConfig({
    this.preprocess = true,
    this.includePaths = const [],
    this.defines = const {},
    this.strict = false,
    this.sv2012 = true,
    this.sv2017 = false,
    this.sv2023 = false,
  });

  factory ParsingConfig.fromYaml(YamlNode? node) {
    if (node is! YamlMap) {
      return const ParsingConfig();
    }

    final includePaths = <String>[];
    if (node['include_paths'] is YamlList) {
      for (final p in node['include_paths']) {
        includePaths.add(p.toString());
      }
    }

    final defines = <String, String>{};
    if (node['defines'] is YamlMap) {
      for (final entry in node['defines'].entries) {
        defines[entry.key.toString()] = entry.value.toString();
      }
    }

    return ParsingConfig(
      preprocess: node['preprocess'] ?? true,
      includePaths: includePaths,
      defines: defines,
      strict: node['strict'] ?? false,
      sv2012: node['sv2012'] ?? true,
      sv2017: node['sv2017'] ?? false,
      sv2023: node['sv2023'] ?? false,
    );
  }

  String toYaml() {
    final buffer = StringBuffer();
    buffer.writeln('  preprocess: $preprocess');
    buffer.writeln('  include_paths:');
    for (final p in includePaths) {
      buffer.writeln('    - $p');
    }
    buffer.writeln('  defines:');
    for (final entry in defines.entries) {
      buffer.writeln('    ${entry.key}: "${entry.value}"');
    }
    buffer.writeln('  strict: $strict');
    buffer.writeln('  sv2012: $sv2012');
    buffer.writeln('  sv2017: $sv2017');
    buffer.writeln('  sv2023: $sv2023');
    return buffer.toString();
  }
}

/// Code generation configuration options.
class CodegenConfig {
  /// Target framework.
  final TargetFramework target;

  /// Generate testbenches.
  final bool generateTests;

  /// Generate documentation.
  final bool generateDocs;

  /// Preserve signal names.
  final bool preserveNames;

  /// Generate waveform viewer support.
  final bool waveformSupport;

  /// Optimization level.
  final int optimizationLevel;

  const CodegenConfig({
    this.target = TargetFramework.rohd,
    this.generateTests = false,
    this.generateDocs = false,
    this.preserveNames = true,
    this.waveformSupport = false,
    this.optimizationLevel = 1,
  });

  factory CodegenConfig.fromYaml(YamlNode? node) {
    if (node is! YamlMap) {
      return const CodegenConfig();
    }
    return CodegenConfig(
      target: TargetFramework.values.firstWhere(
        (e) => e.name == node['target'],
        orElse: () => TargetFramework.rohd,
      ),
      generateTests: node['generate_tests'] ?? false,
      generateDocs: node['generate_docs'] ?? false,
      preserveNames: node['preserve_names'] ?? true,
      waveformSupport: node['waveform_support'] ?? false,
      optimizationLevel: node['optimization_level'] ?? 1,
    );
  }

  String toYaml() {
    return '''
  target: ${target.name}
  generate_tests: $generateTests
  generate_docs: $generateDocs
  preserve_names: $preserveNames
  waveform_support: $waveformSupport
  optimization_level: $optimizationLevel
''';
  }
}

/// Target frameworks for code generation.
enum TargetFramework {
  rohd,
  systemverilog,
  verilog,
}

/// Analysis configuration options.
class AnalysisConfig {
  /// Enable semantic analysis.
  final bool semanticAnalysis;

  /// Enable type checking.
  final bool typeChecking;

  /// Enable linting rules.
  final List<String> lintRules;

  /// Treat warnings as errors.
  final bool warningsAsErrors;

  /// Maximum errors before stopping.
  final int maxErrors;

  const AnalysisConfig({
    this.semanticAnalysis = true,
    this.typeChecking = true,
    this.lintRules = const [],
    this.warningsAsErrors = false,
    this.maxErrors = 50,
  });

  factory AnalysisConfig.fromYaml(YamlNode? node) {
    if (node is! YamlMap) {
      return const AnalysisConfig();
    }

    final lintRules = <String>[];
    if (node['lint_rules'] is YamlList) {
      for (final r in node['lint_rules']) {
        lintRules.add(r.toString());
      }
    }

    return AnalysisConfig(
      semanticAnalysis: node['semantic_analysis'] ?? true,
      typeChecking: node['type_checking'] ?? true,
      lintRules: lintRules,
      warningsAsErrors: node['warnings_as_errors'] ?? false,
      maxErrors: node['max_errors'] ?? 50,
    );
  }

  String toYaml() {
    final buffer = StringBuffer();
    buffer.writeln('  semantic_analysis: $semanticAnalysis');
    buffer.writeln('  type_checking: $typeChecking');
    buffer.writeln('  lint_rules:');
    for (final r in lintRules) {
      buffer.writeln('    - $r');
    }
    buffer.writeln('  warnings_as_errors: $warningsAsErrors');
    buffer.writeln('  max_errors: $maxErrors');
    return buffer.toString();
  }
}

/// Configuration exception.
class ConfigException implements Exception {
  final String message;

  const ConfigException(this.message);

  @override
  String toString() => 'ConfigException: $message';
}
