// Copyright (C) 2026
// SPDX-License-Identifier: BSD-3-Clause

import 'symbol.dart';

/// Represents a scope in the symbol table.
class Scope {
  final String name;
  final ScopeKind kind;
  final Map<String, List<Symbol>> symbols = {};
  final Scope? parent;

  Scope({
    required this.name,
    required this.kind,
    this.parent,
  });

  bool containsSymbol(String name) => symbols.containsKey(name);

  List<Symbol>? lookup(String name) => symbols[name];

  void define(String name, Symbol symbol) {
    symbols.putIfAbsent(name, () => []).add(symbol);
  }

  @override
  String toString() => 'Scope($kind: $name)';
}

/// Kind of scope.
enum ScopeKind {
  global,
  module,
  generate,
  function,
  task,
  procedural,
}

/// Manages symbol tables and scopes.
class SymbolTable {
  final Map<String, List<Symbol>> _symbols = {};
  final List<Scope> _scopeStack = [];

  void define(String name, Symbol symbol) {
    _symbols.putIfAbsent(name, () => []).add(symbol);
  }

  List<Symbol>? lookup(String name) => _symbols[name];

  void pushScope(String name, ScopeKind kind) {
    final scope = Scope(name: name, kind: kind, parent: currentScope);
    _scopeStack.add(scope);
  }

  Scope? popScope() {
    if (_scopeStack.isNotEmpty) {
      return _scopeStack.removeLast();
    }
    return null;
  }

  Scope? get currentScope =>
      _scopeStack.isNotEmpty ? _scopeStack.last : null;

  List<Symbol> lookupRecursive(String name) {
    // Look in current scope
    final symbols = _symbols[name];
    if (symbols != null && symbols.isNotEmpty) {
      return symbols;
    }

    // Look in parent scopes
    for (final scope in _scopeStack.reversed) {
      final parentSymbols = scope.symbols[name];
      if (parentSymbols != null && parentSymbols.isNotEmpty) {
        return parentSymbols;
      }
    }

    return [];
  }

  List<Symbol> getAllSymbols() {
    final result = <Symbol>[];
    for (final symbols in _symbols.values) {
      result.addAll(symbols);
    }
    return result;
  }
}
