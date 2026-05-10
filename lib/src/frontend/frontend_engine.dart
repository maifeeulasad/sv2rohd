// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

import 'package:antlr4/antlr4.dart';
import '../common/common.dart';
import 'source_text.dart';
import 'preprocessor.dart';
import 'lexer_adapter.dart';
import 'parser_adapter.dart';

/// Main frontend component that orchestrates parsing.
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

  /// Parses source text and returns the compilation unit.
  ParsedModule parseSource(
    String source, {
    String? sourceName,
  }) {
    // Preprocess
    final preprocessor = Preprocessor(
      diagnostics: diagnostics,
      includePaths: includePaths,
      predefinedMacros: predefinedMacros,
    );
    final preprocessed = preprocessor.preprocess(source, sourceName: sourceName);

    // Tokenize
    final lexer = LexerAdapter(
      sourceName: sourceName ?? 'unknown',
      source: preprocessed.text,
      diagnostics: diagnostics,
    );
    final tokens = lexer.tokenize();

    // Parse
    final parser = ParserAdapter(
      sourceName: sourceName ?? 'unknown',
      tokens: tokens,
      diagnostics: diagnostics,
    );

    // Wrap the parse result
    return ParsedModule(
      sourceText: preprocessed,
      tokens: tokens,
      compilationUnit: parser.parse(),
    );
  }

  /// Reads a file from the filesystem.
  String _readFile(String path) {
    // This would use dart:io for actual file reading
    throw UnimplementedError('File reading not yet implemented');
  }
}

/// Result of parsing a module.
class ParsedModule {
  final SourceText sourceText;
  final List<Token> tokens;
  final dynamic compilationUnit;

  const ParsedModule({
    required this.sourceText,
    required this.tokens,
    required this.compilationUnit,
  });

  /// Returns true if parsing was successful (no errors).
  bool get isSuccess => true; // Would check for parser errors
}

/// Represents an include path.
class IncludePath {
  final String path;

  const IncludePath(this.path);
}