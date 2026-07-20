// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as p;
import 'common/common.dart';
import 'codegen/naming_strategy.dart';
import 'codegen/testbench_scaffold.dart';
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
  /// file so that instantiations can resolve each other. When
  /// [generateTestbench] is true and [outputPath] is given, a runnable ROHD
  /// testbench scaffold is written alongside it (as `<base>_test.dart`) for
  /// the first module.
  String convert(
    String sourcePath, {
    String? outputPath,
    bool generateTestbench = false,
  }) {
    final source = _readFile(sourcePath);
    final modules = _parseModules(source, sourcePath);
    final output = _generate(modules, source, sourcePath);

    if (outputPath != null) {
      _writeFile(outputPath, output);
      if (generateTestbench && modules.isNotEmpty) {
        final tbPath = p.join(
          p.dirname(outputPath),
          '${p.basenameWithoutExtension(outputPath)}_test.dart',
        );
        final scaffold = TestbenchScaffold(namingStrategy: namingStrategy)
            .generate(modules.first, dutImport: p.basename(outputPath));
        _writeFile(tbPath, scaffold);
      }
    }
    return output;
  }

  /// Converts SystemVerilog [source] text directly to ROHD Dart code,
  /// without touching the filesystem.
  String convertSource(String source, {String sourceName = 'source.sv'}) {
    final modules = _parseModules(source, sourceName);
    return _generate(modules, source, sourceName);
  }

  /// Generates a runnable ROHD testbench scaffold for the first module in
  /// [source]. [dutImport] is the import path of the generated module file.
  String? generateTestbenchSource(
    String source, {
    String sourceName = 'source.sv',
    required String dutImport,
  }) {
    final modules = _parseModules(source, sourceName);
    if (modules.isEmpty) return null;
    return TestbenchScaffold(namingStrategy: namingStrategy)
        .generate(modules.first, dutImport: dutImport);
  }

  List<ModuleDeclaration> _parseModules(String source, String sourceName) {
    final frontend = Frontend(
      diagnostics: diagnostics,
      includePaths: includePaths,
    );
    final parsed = frontend.parseSource(source, sourceName: sourceName);
    final builder = IrBuilder(
      diagnostics: diagnostics,
      namingStrategy: namingStrategy,
    );
    return builder.buildModules(parsed);
  }

  String _generate(
    List<ModuleDeclaration> modules,
    String source,
    String sourceName,
  ) {
    final generator = RohdGenerator(
      options: GeneratorOptions(namingStrategy: namingStrategy),
      diagnostics: diagnostics,
    );
    return modules.isEmpty
        ? generator.generate(ModuleDeclaration(
            location: SourceLocation.start(sourceName),
            name: p.basenameWithoutExtension(sourceName),
          ))
        : generator.generateAll(modules);
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
    ..addFlag('testbench',
        abbr: 't',
        help: 'Also emit a ROHD testbench scaffold (<base>_test.dart)',
        negatable: false)
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
  -t, --testbench         Also emit a ROHD testbench scaffold
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
    // When no -o is given but a config file explicitly sets a (non-default)
    // output directory, write there instead of stdout. output_dir is always
    // treated as a directory.
    var outputIsDir = false;
    if (outputPath == null &&
        configPath != null &&
        config.output.outputDir != const OutputConfig().outputDir) {
      outputPath = config.output.outputDir;
      outputIsDir = true;
    }
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
      if (outputIsDir ||
          outDir.existsSync() ||
          outputPath.endsWith(p.separator) ||
          outputPath.endsWith('/')) {
        final base = p.basenameWithoutExtension(inputPath);
        outputPath = p.join(outputPath, '$base.dart');
      }
    }

    final generateTestbench =
        results['testbench'] == true || config.codegen.generateTests;
    final converter = SV2ROHD(includePaths: includePaths);
    final result = converter.convert(
      inputPath,
      outputPath: outputPath,
      generateTestbench: generateTestbench,
    );

    if (outputPath == null) {
      print(result);
      if (generateTestbench) {
        print('Note: --testbench needs -o to write the scaffold file.');
      }
    } else {
      print('Output written to $outputPath');
      if (generateTestbench) {
        final tbPath = p.join(
          p.dirname(outputPath),
          '${p.basenameWithoutExtension(outputPath)}_test.dart',
        );
        print('Testbench scaffold written to $tbPath');
      }
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
      if (config.analysis.warningsAsErrors) {
        print('Treating warnings as errors (analysis.warnings_as_errors).');
        exitCode = 1;
      }
    }
  } catch (e) {
    print('Error: $e');
    exitCode = 1;
  }
}
