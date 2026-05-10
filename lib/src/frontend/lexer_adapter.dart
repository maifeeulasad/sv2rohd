// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

import 'package:antlr4/antlr4.dart';

import '../common/common.dart';
import 'source_text.dart';

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
class LexerErrorListener extends BaseErrorListener {
  final DiagnosticCollector diagnostics;

  LexerErrorListener(this.diagnostics);

  @override
  void syntaxError(
    Recognizer recognizer,
    Object? offendingSymbol,
    int? line,
    int? charPositionInLine,
    String msg,
    RecognitionException? e,
  ) {
    diagnostics.error(
      'Lexer error at line ${line ?? 0}:${charPositionInLine ?? 0}: $msg',
      code: 'LEX0001',
    );
  }
}
