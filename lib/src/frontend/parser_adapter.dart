// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

import 'package:antlr4/antlr4.dart';
import 'package:sv2rohd/generated/grammar/SystemVerilogLexer.dart';
import 'package:sv2rohd/generated/grammar/SystemVerilogParser.dart';

import '../common/common.dart';
import 'lexer_adapter.dart';

/// Adapts the ANTLR4 parser for SystemVerilog.
class ParserAdapter {
  final String sourceName;
  final String sourceText;
  final List<Token> tokens;
  final DiagnosticCollector diagnostics;

  ParserAdapter({
    required this.sourceName,
    required this.sourceText,
    required this.tokens,
    required this.diagnostics,
  });

  /// Parses the source and returns the parse tree.
  Source_textContext? parse() {
    final tokenSource = ListTokenSource(tokens, sourceName)..i = 0;
    final tokenStream = CommonTokenStream(tokenSource);
    final parser = SystemVerilogParser(tokenStream);
    parser.removeErrorListeners();
    parser.addErrorListener(ParserErrorListener(diagnostics));
    return parser.source_text();
  }

  /// Parses a module declaration.
  Module_declarationContext? parseModule() {
    final tree = parse();
    if (tree == null) return null;
    if (tree.descriptions().isNotEmpty) {
      final description = tree.description(0);
      return description?.module_declaration();
    }
    return null;
  }

  /// Parses an expression.
  dynamic parseExpression(String expression) {
    final input = InputStream.fromString(expression);
    final lexer = SystemVerilogLexer(input);
    lexer.removeErrorListeners();
    lexer.addErrorListener(LexerErrorListener(diagnostics));

    final stream = CommonTokenStream(lexer);
    final parser = SystemVerilogParser(stream);
    parser.removeErrorListeners();
    parser.addErrorListener(ParserErrorListener(diagnostics));
    return parser.expression(0);
  }
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
