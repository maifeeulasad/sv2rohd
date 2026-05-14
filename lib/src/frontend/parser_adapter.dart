// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

import 'package:antlr4/antlr4.dart';
import '../common/common.dart';

/// Adapts the ANTLR4 parser for SystemVerilog.
class ParserAdapter {
  final String sourceName;
  final List<Token> tokens;
  final DiagnosticCollector diagnostics;

  ParserAdapter({
    required this.sourceName,
    required this.tokens,
    required this.diagnostics,
  });

  /// Parses the source and returns the parse tree.
  dynamic parse() => null;

  /// Parses a module declaration.
  dynamic parseModule() => null;

  /// Parses an expression.
  dynamic parseExpression(String expression) => null;
}

/// Error listener for parser errors.
class ParserErrorListener extends BaseErrorListener {
  final DiagnosticCollector diagnostics;

  ParserErrorListener(this.diagnostics);

  @override
  void syntaxError(
    Recognizer recognizer,
    Object? offendingSymbol,
    int? line,
    int charPositionInLine,
    String msg,
    RecognitionException? e,
  ) {
    final token = offendingSymbol as Token?;

    if (token != null) {
      diagnostics.error(
        'Syntax error at line $line:$charPositionInLine, near "${token.text}": $msg',
        code: 'PARS0001',
      );
    } else {
      diagnostics.error(
        'Syntax error at line $line:$charPositionInLine: $msg',
        code: 'PARS0001',
      );
    }
  }

  @override
  void reportAmbiguity(
    Parser recognizer,
    DFA dfa,
    int startIndex,
    int stopIndex,
    bool exact,
    dynamic ambigAlts,
    ATNConfigSet configs,
  ) {
    diagnostics.warning(
      'Ambiguous parse at $startIndex-$stopIndex',
      code: 'PARS0002',
    );
  }
}
