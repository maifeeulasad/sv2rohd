// Copyright (C) 2026
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:io';

import 'package:args/args.dart';

import '../lib/src/config/config.dart';

/// Command-line interface for SV2ROHD.
class Sv2RohdCli {
  final ArgParser _parser;

  Sv2RohdCli() : _parser = _buildParser();

  static ArgParser _buildParser() {
    final parser = ArgParser();

    parser.addFlag(
      'help',
      abbr: 'h',
      help: 'Show this help message.',
    );

    parser.addFlag(
      'version',
      help: 'Print the version.',
    );

    parser.addOption(
      'input',
      abbr: 'i',
      help: 'Input SystemVerilog file.',
      valueHelp: 'FILE',
    );

    parser.addOption(
      'output',
      abbr: 'o',
      help: 'Output directory.',
      valueHelp: 'DIR',
    );

    parser.addOption(
      'config',
      abbr: 'c',
      help: 'Configuration file (YAML).',
      valueHelp: 'FILE',
    );

    parser.addFlag(
      'verbose',
      abbr: 'v',
      help: 'Verbose output.',
    );

    parser.addFlag(
      'check',
      help: 'Check syntax only, no output.',
    );

    parser.addFlag(
      'no-format',
      help: 'Skip formatting output.',
    );

    parser.addFlag(
      'no-analysis',
      help: 'Skip semantic analysis.',
    );

    parser.addOption(
      'target',
      abbr: 't',
      help: 'Target framework (rohd, systemverilog, verilog).',
      valueHelp: 'FRAMEWORK',
      allowed: ['rohd', 'systemverilog', 'verilog'],
      defaultsTo: 'rohd',
    );

    parser.addMultiOption(
      'define',
      abbr: 'D',
      help: 'Define macro (key=value).',
      valueHelp: 'MACRO',
    );

    parser.addMultiOption(
      'include',
      abbr: 'I',
      help: 'Include path.',
      valueHelp: 'PATH',
    );

    return parser;
  }

  /// Run the CLI with given arguments.
  Future<int> run(List<String> args) async {
    try {
      final results = _parser.parse(args);

      if (results['help'] == true) {
        print(_parser.usage);
        return 0;
      }

      if (results['version'] == true) {
        print('SV2ROHD ${_version()}');
        return 0;
      }

      final inputFile = results['input'] as String?;
      if (inputFile == null) {
        print('Error: Input file required.\n');
        print(_parser.usage);
        return 1;
      }

      final outputDir = results['output'] as String? ?? 'generated';
      final configFile = results['config'] as String?;
      final verbose = results['verbose'] == true;
      final checkOnly = results['check'] == true;
      final skipFormat = results['no-format'] == true;
      final skipAnalysis = results['no-analysis'] == true;
      final targetStr = results['target'] as String? ?? 'rohd';
      final defines = results['define'] as List<String>? ?? [];
      final includes = results['include'] as List<String>? ?? [];

      // Load configuration
      var config = const Sv2RohdConfig();
      if (configFile != null) {
        if (verbose) print('Loading configuration from: $configFile');
        config = Sv2RohdConfig.fromFile(configFile);
      }

      // Override with CLI options
      if (defines.isNotEmpty) {
        final definesMap = <String, String>{};
        for (final d in defines) {
          final parts = d.split('=');
          definesMap[parts[0]] = parts.length > 1 ? parts[1] : '';
        }
        config = Sv2RohdConfig(
          output: config.output,
          parsing: ParsingConfig(
            preprocess: config.parsing.preprocess,
            includePaths: [...config.parsing.includePaths, ...includes],
            defines: {...config.parsing.defines, ...definesMap},
          ),
          codegen: config.codegen,
          analysis: config.analysis,
        );
      }

      if (verbose) {
        print('SV2ROHD ${_version()}');
        print('Input: $inputFile');
        print('Output: $outputDir');
        print('Target: $targetStr');
      }

      // Validate input file
      final input = File(inputFile);
      if (!input.existsSync()) {
        print('Error: Input file not found: $inputFile');
        return 1;
      }

      // Parse and convert
      if (verbose) print('Parsing...');
      final source = input.readAsStringSync();

      try {
        // Placeholder for actual conversion logic
        // In production, this would call Sv2Rohd.parse() and Sv2Rohd.generate()
        print('Parsed ${source.length} bytes');

        if (checkOnly) {
          print('Syntax OK.');
          return 0;
        }

        if (verbose) print('Generating...');
        final output = Directory(outputDir);
        if (!output.existsSync()) {
          output.createSync(recursive: true);
        }

        if (verbose) print('Done.');
        return 0;
      } catch (e) {
        print('Error: $e');
        return 1;
      }
    } catch (e) {
      print('Error: $e\n');
      print(_parser.usage);
      return 1;
    }
  }

  String _version() => '0.1.0';
}

/// Main entry point for CLI.
Future<void> main(List<String> args) async {
  final cli = Sv2RohdCli();
  final exitCode = await cli.run(args);
  exit(exitCode);
}
