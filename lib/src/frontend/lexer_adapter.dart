// Copyright (C) 2026
// SPDX-License-Identifier: BSD-3-Clause

import 'package:antlr4/antlr4.dart';

/// Represents preprocessed source text with source mapping.
class SourceText {
  final String sourceName;
  final String text;
  final SourceMap sourceMap;

  const SourceText(
    this.sourceName,
    this.text, {
    this.sourceMap = const _EmptySourceMap(),
  });

  /// Returns the length of the source text.
  int get length => text.length;

  /// Returns the source location for a given offset.
  SourceLocation getLocation(int offset) {
    if (offset < 0 || offset > text.length) {
      return SourceLocation(sourceName, 0, 0, offset);
    }

    int line = 1;
    int column = 1;
    int currentOffset = 0;

    for (int i = 0; i < text.length && currentOffset < offset; i++) {
      if (text[i] == '\n') {
        line++;
        column = 1;
      } else {
        column++;
      }
      currentOffset++;
    }

    return SourceLocation(sourceName, line, column, offset);
  }
}

class _EmptySourceMap implements SourceMap {
  const _EmptySourceMap();

  @override
  void addMapping(int preprocessedOffset, int originalOffset) {}

  @override
  int? toOriginalOffset(int preprocessedOffset) => preprocessedOffset;

  @override
  List<int> get preprocessedOffsets => [];

  @override
  void clear() {}

  @override
  int get length => 0;

  @override
  bool get isEmpty => true;
}

/// Adapts the ANTLR4 lexer for SystemVerilog.
class LexerAdapter {
  final String sourceName;
  final String source;
  final DiagnosticCollector diagnostics;
  final List<Token> _tokens = [];
  int _position = 0;

  LexerAdapter({
    required this.sourceName,
    required this.source,
    required this.diagnostics,
  });

  /// Tokenizes the source text.
  List<Token> tokenize() {
    final inputStream = CharStreams.fromString(source, name: sourceName);
    final lexer = SystemVerilogLexer(inputStream);

    lexer.addErrorListener(LexerErrorListener(diagnostics));
    _tokens.addAll(lexer.getAllTokens());

    // Sort tokens by start position
    _tokens.sort((a, b) => a.tokenIndex.compareTo(b.tokenIndex));

    return _tokens;
  }

  /// Gets the token at a specific offset.
  Token? getTokenAt(int offset) {
    for (final token in _tokens) {
      if (token.startIndex <= offset && offset <= token.stopIndex) {
        return token;
      }
    }
    return null;
  }

  /// Gets all tokens within a range.
  List<Token> getTokensInRange(int start, int end) {
    return _tokens
        .where((t) => t.startIndex >= start && t.stopIndex <= end)
        .toList();
  }
}

/// Error listener for lexer errors.
class LexerErrorListener implements ANTLRErrorListener {
  final DiagnosticCollector diagnostics;

  LexerErrorListener(this.diagnostics);

  @override
  void syntaxError(
    Recognizer<object, object?> recognizer,
    Object? offendingSymbol,
    int line,
    int charPositionInLine,
    String msg,
    RecognitionException<Object?>? e,
  ) {
    diagnostics.error(
      'Lexer error at line $line:$charPositionInLine: $msg',
      code: 'LEX0001',
    );
  }

  @override
  void reportAmbiguity(
    Recognizer<object, object?> recognizer,
    ParserRuleContext? ctx,
    int startIndex,
    int stopIndex,
    BitSet? ambigAlts,
    ATNConfigSet? configs,
  ) {
    // Report ambiguity as warning
    diagnostics.warning(
      'Ambiguous token at $startIndex-$stopIndex',
      code: 'LEX0002',
    );
  }

  @override
  void reportAttemptingFullContext(
    Recognizer<object, object?> recognizer,
    PredictionContext? ctx,
    int startIndex,
    int stopIndex,
    BitSet? configs,
  ) {
    // Full context attempt - informational only
  }

  @override
  void reportContextSensitivity(
    Recognizer<object, object?> recognizer,
    PredictionContext? ctx,
    int startIndex,
    int stopIndex,
    int survivingConfigs,
  ) {
    // Context sensitivity - informational only
  }
}