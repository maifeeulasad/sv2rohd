// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as p;
import 'common/common.dart';
import 'codegen/naming_strategy.dart';
import 'frontend/frontend.dart';
import 'ir/ir.dart';
import 'codegen/rohd_generator.dart';

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

    // Translate to ROHD using the legacy translator expected by tests
    final translator = RohdTranslator(namingStrategy: namingStrategy);
    translator.visitModule(module);
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
    final file = File(path);
    if (!file.existsSync()) {
      throw FileSystemException('File not found', path);
    }
    return file.readAsStringSync();
  }

  void _writeFile(String path, String content) {
    final file = File(path);
    final parent = file.parent;
    if (!parent.existsSync()) parent.createSync(recursive: true);
    file.writeAsStringSync(content);
  }
}

/// Main CLI entry point.
void main(List<String> arguments) {
  final parser = ArgParser()
    ..addOption('input', abbr: 'i', help: 'Input SystemVerilog file')
    ..addOption('output', abbr: 'o', help: 'Output file path')
    ..addMultiOption('include', abbr: 'I', help: 'Include search path')
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

    String? inputPath;
    if ((results['input'] as String?) != null) {
      inputPath = results['input'] as String?;
    } else if (results.rest.isNotEmpty) {
      inputPath = results.rest.first;
    }

    if (inputPath == null) {
      print('Error: No input file specified');
      print('Use --help for usage information');
      return;
    }
    String? outputPath = results['output'] as String?;
    final includePaths = (results['include'] as List<String>?) ?? [];

    if (results['verbose'] == true) {
      print('Converting $inputPath...');
    }

    // If outputPath is an existing directory or ends with a separator,
    // write output to a file inside that directory using the input basename.
    if (outputPath != null) {
      final outDir = Directory(outputPath);
      if (outDir.existsSync() ||
          outputPath.endsWith(p.separator) ||
          outputPath.endsWith('/')) {
        final base = p.basenameWithoutExtension(inputPath);
        outputPath = p.join(outputPath, '$base.dart');
      }
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
