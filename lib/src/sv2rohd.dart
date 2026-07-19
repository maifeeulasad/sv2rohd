// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as p;
import 'common/common.dart';
import 'codegen/naming_strategy.dart';
import 'config/config.dart';
import 'frontend/frontend.dart';
import 'ir/ir.dart';
import 'codegen/rohd_generator.dart';

/// Tool version, kept in sync with pubspec.yaml.
const String sv2rohdVersion = '0.1.0';

/// Main entry point for sv2rohd.
class SV2ROHD {
  final DiagnosticCollector diagnostics;
  final NamingStrategy namingStrategy;
  final List<IncludePath> includePaths;

  /// Creates a new SV2ROHD converter.
  SV2ROHD({
    DiagnosticCollector? diagnostics,
    NamingStrategy? namingStrategy,
    List<IncludePath>? includePaths,
  })  : diagnostics = diagnostics ?? DiagnosticCollector(),
        namingStrategy = namingStrategy ?? NamingStrategy(),
        includePaths = includePaths ?? const [];

  /// Converts a SystemVerilog file to ROHD Dart code.
  ///
  /// All modules found in the file are emitted into a single Dart source
  /// file so that instantiations can resolve each other.
  String convert(String sourcePath, {String? outputPath}) {
    final source = _readFile(sourcePath);

    final frontend = Frontend(
      diagnostics: diagnostics,
      includePaths: includePaths,
    );
    final parsed = frontend.parseSource(source, sourceName: sourcePath);

    final builder = IrBuilder(
      diagnostics: diagnostics,
      namingStrategy: namingStrategy,
    );
    final modules = builder.buildModules(parsed);

    final generator = RohdGenerator(
      options: GeneratorOptions(namingStrategy: namingStrategy),
      diagnostics: diagnostics,
    );
    final output = modules.isEmpty
        ? generator.generate(ModuleDeclaration(
            location: parsed.sourceText.getLocation(0),
            name: p.basenameWithoutExtension(sourcePath),
          ))
        : generator.generateAll(modules);

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
    ..addOption('output', abbr: 'o', help: 'Output file or directory path')
    ..addOption('config', abbr: 'c', help: 'YAML configuration file')
    ..addMultiOption('include', abbr: 'I', help: 'Include search path')
    ..addFlag('verbose', abbr: 'v', help: 'Verbose output', negatable: false)
    ..addFlag('version', help: 'Show version', negatable: false)
    ..addFlag('help', abbr: 'h', help: 'Show help', negatable: false);

  try {
    final results = parser.parse(arguments);

    if (results['help'] == true) {
      print('''
SV2ROHD - SystemVerilog to ROHD Converter

Usage: sv2rohd [options] <input_file>

Options:
  -i, --input <file>      Input SystemVerilog file
  -o, --output <path>     Output file or directory path
  -c, --config <file>     YAML configuration file
  -I, --include <path>    Include search path (repeatable)
  -v, --verbose           Verbose output
      --version           Show version
  -h, --help              Show this help message
''');
      return;
    }

    if (results['version'] == true) {
      print('sv2rohd $sv2rohdVersion');
      return;
    }

    Sv2RohdConfig config = const Sv2RohdConfig();
    final configPath = results['config'] as String?;
    if (configPath != null) {
      config = Sv2RohdConfig.fromFile(configPath);
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
      exitCode = 64;
      return;
    }

    String? outputPath = results['output'] as String?;
    final includePaths = <IncludePath>[
      for (final path in (results['include'] as List<String>? ?? const []))
        IncludePath(path),
      for (final path in config.parsing.includePaths) IncludePath(path),
    ];

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

    final converter = SV2ROHD(includePaths: includePaths);
    final result = converter.convert(
      inputPath,
      outputPath: outputPath,
    );

    if (outputPath == null) {
      print(result);
    } else {
      print('Output written to $outputPath');
    }

    final verbose = results['verbose'] == true;
    for (final diagnostic in converter.diagnostics.diagnostics) {
      if (diagnostic.isInfo && !verbose) continue;
      print(diagnostic.formatted);
    }

    if (converter.hasErrors) {
      print('Conversion finished with ${converter.diagnosticSummary}');
      exitCode = 1;
    } else if (converter.diagnostics.hasWarnings) {
      print('Conversion finished with ${converter.diagnosticSummary}');
    }
  } catch (e) {
    print('Error: $e');
    exitCode = 1;
  }
}
