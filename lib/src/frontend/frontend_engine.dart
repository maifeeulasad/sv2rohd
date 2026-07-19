// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:io';

import '../common/common.dart';
import 'source_text.dart';
import 'preprocessor.dart';

/// Main frontend component that orchestrates parsing.
///
/// Only runs the preprocessor: actual lexing/parsing of the preprocessed
/// text into IR is done by [SvParser] (see `sv_parser.dart`), which reads
/// [ParsedModule.sourceText] directly. An earlier ANTLR-generated grammar
/// used to run here too, but it never produced usable output and its parse
/// errors were pure noise; see the `lib/generated/grammar` sources if that
/// grammar is ever revived for something else.
class Frontend {
  final DiagnosticCollector diagnostics;
  final List<IncludePath> includePaths;
  final Map<String, String> predefinedMacros;

  /// Creates a new frontend.
  Frontend({
    required this.diagnostics,
    List<IncludePath>? includePaths,
    Map<String, String>? predefinedMacros,
  })  : includePaths = includePaths ?? const [],
        predefinedMacros = predefinedMacros ?? const {};

  /// Parses a source file and returns the compilation unit.
  ParsedModule parseFile(String path) {
    final source = _readFile(path);
    return parseSource(source, sourceName: path);
  }

  /// Preprocesses source text and wraps it for downstream parsing.
  ParsedModule parseSource(
    String source, {
    String? sourceName,
  }) {
    final preprocessor = Preprocessor(
      diagnostics: diagnostics,
      includePaths: includePaths,
      predefinedMacros: predefinedMacros,
    );
    final preprocessed =
        preprocessor.preprocess(source, sourceName: sourceName);

    return ParsedModule(sourceText: preprocessed);
  }

  /// Reads a file from the filesystem.
  String _readFile(String path) {
    final file = File(path);
    if (!file.existsSync()) {
      throw FileSystemException('File not found', path);
    }
    return file.readAsStringSync();
  }
}

/// Result of preprocessing a source file, ready for [SvParser].
class ParsedModule {
  final SourceText sourceText;

  const ParsedModule({required this.sourceText});
}
