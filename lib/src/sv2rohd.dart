// Copyright (C) 2026
// SPDX-License-Identifier: BSD-3-Clause

import 'package:args/args.dart';
import 'package:path/path.dart' as p;
import 'src/common/common.dart';
import 'src/frontend/frontend.dart';
import 'src/ir/ir.dart';

/// Main entry point for sv2rohd.
class SV2ROHD {
  final DiagnosticCollector diagnostics;
  final NamingStrategy namingStrategy;

  /// Creates a new SV2ROHD converter.
  SV2ROHD({
    DiagnosticCollector? diagnostics,
    NamingStrategy? namingStrategy,
  })  : diagnostics = diagnostics ?? DiagnosticCollector(),
        namingStrategy = namingStrategy ?? NamingStrategy();

  /// Converts a SystemVerilog file to ROHD Dart code.
  String convert(String sourcePath, {String? outputPath}) {
    // Read source file
    final source = _readFile(sourcePath);

    // Create frontend
    final frontend = Frontend(diagnostics: diagnostics);
    final parsed = frontend.parseSource(source, sourceName: sourcePath);

    // Build IR
    final builder = IrBuilder(
      diagnostics: diagnostics,
      namingStrategy: namingStrategy,
    );
    final module = builder.buildModule(parsed);

    // Translate to ROHD
    final translator = RohdTranslator(namingStrategy: namingStrategy);
    module.accept(translator);

    // Output
    final output = translator.output;

    if (outputPath != null) {
      _writeFile(outputPath, output);
    }

    return output;
  }

  /// Returns the diagnostic summary.
  String get diagnosticSummary => diagnostics.summary.toString();

  /// Returns true if there are errors.
  bool get hasErrors => diagnostics.hasErrors;

  String _readFile(String path) {
    // Implementation would use dart:io
    throw UnimplementedError('File reading not yet implemented');
  }

  void _writeFile(String path, String content) {
    // Implementation would use dart:io
    throw UnimplementedError('File writing not yet implemented');
  }
}

/// Main CLI entry point.
void main(List<String> arguments) {
  final parser = ArgParser()
    ..addOption('output', abbr: 'o', help: 'Output file path')
    ..addOption('include', abbr: 'I', help: 'Include search path', allowMultiple: true)
    ..addFlag('verbose', abbr: 'v', help: 'Verbose output')
    ..addFlag('help', abbr: 'h', help: 'Show help');

  try {
    final results = parser.parse(arguments);

    if (results['help'] == true) {
      print('''
SV2ROHD - SystemVerilog to ROHD Converter

Usage: sv2rohd [options] <input_file>

Options:
  -o, --output <file>    Output file path
  -I, --include <path>    Include search path
  -v, --verbose           Verbose output
  -h, --help              Show this help message
''');
      return;
    }

    if (results.rest.isEmpty) {
      print('Error: No input file specified');
      print('Use --help for usage information');
      return;
    }

    final inputPath = results.rest.first;
    final outputPath = results['output'] as String?;
    final includePaths = (results['include'] as List<String>?) ?? [];

    if (results['verbose'] == true) {
      print('Converting $inputPath...');
    }

    final converter = SV2ROHD();
    final result = converter.convert(
      inputPath,
      outputPath: outputPath,
    );

    if (outputPath == null) {
      print(result);
    } else {
      print('Output written to $outputPath');
    }

    if (converter.hasErrors) {
      print('Errors: ${converter.diagnosticSummary}');
    }
  } catch (e) {
    print('Error: $e');
  }
}