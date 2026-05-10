// Copyright (C) 2026
// SPDX-License-Identifier: BSD-3-Clause

import 'package:antlr4/antlr4.dart';
import '../common/common.dart';
import 'lexer_adapter.dart';

/// Adapts the ANTLR4 parser for SystemVerilog.
class ParserAdapter {
  final String sourceName;
  final List<Token> tokens;
  final DiagnosticCollector diagnostics;
  late final SystemVerilogParser parser;

  ParserAdapter({
    required this.sourceName,
    required this.tokens,
    required this.diagnostics,
  }) {
    _initParser();
  }

  void _initParser() {
    final tokenStream = CommonTokenStream(CommonToken.fromTokens(tokens));
    parser = SystemVerilogParser(tokenStream);

    parser.addErrorListener(ParserErrorListener(diagnostics));
    parser.buildParseTree = true;
  }

  /// Parses the source and returns the parse tree.
  CompilationUnitContext parse() {
    return parser.compilationUnit();
  }

  /// Parses a module declaration.
  module_declarationContext? parseModule() {
    final tree = parse();
    return tree.module_declaration(0);
  }

  /// Parses an expression.
  expressionContext? parseExpression(String expression) {
    final inputStream = CharStreams.fromString(expression, name: 'expr');
    final lexer = SystemVerilogLexer(inputStream);
    lexer.addErrorListener(LexerErrorListener(diagnostics));

    final tokenStream = CommonTokenStream(CommonToken.fromTokens(lexer.getAllTokens()));
    final exprParser = SystemVerilogParser(tokenStream);

    return exprParser.expression();
  }
}

/// Error listener for parser errors.
class ParserErrorListener implements ANTLRErrorListener {
  final DiagnosticCollector diagnostics;

  ParserErrorListener(this.diagnostics);

  @override
  void syntaxError(
    Recognizer<object, object?> recognizer,
    Object? offendingSymbol,
    int line,
    int charPositionInLine,
    String msg,
    RecognitionException<Object?>? e,
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
    Recognizer<object, object?> recognizer,
    ParserRuleContext? ctx,
    int startIndex,
    int stopIndex,
    BitSet? ambigAlts,
    ATNConfigSet? configs,
  ) {
    diagnostics.warning(
      'Ambiguous parse at $startIndex-$stopIndex',
      code: 'PARS0002',
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