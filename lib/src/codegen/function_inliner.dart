// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

// Inlines SystemVerilog function calls. ROHD has no hardware-function
// construct, so each call is replaced by the function's body reduced to a
// single value expression, with the call arguments substituted for the
// parameters. Parts of this implementation were generated with LLM
// assistance and reviewed by the maintainer.

import '../analysis/symbol.dart';
import '../common/common.dart';
import '../ir/ir.dart';

/// A function reduced to a single value expression (in terms of its
/// parameters and any module-level signals it reads), ready to be inlined.
class _ReducedFunction {
  final List<String> paramNames;
  final VectorWidth? returnWidth;

  /// The function's value, or null when the body could not be reduced.
  final IrExpression? result;

  _ReducedFunction(this.paramNames, this.returnWidth, this.result);

  bool get isInlinable => result != null;
}

/// Reduces function bodies and inlines calls to them.
///
/// Supported bodies: straight-line blocking assignments, `if`/`else` and
/// `case` (merged into nested ternaries), and `return`. Bodies with loops or
/// other constructs are reported as un-inlinable, and calls to them surface a
/// diagnostic rather than silently producing wrong output.
class FunctionInliner {
  final DiagnosticCollector? diagnostics;
  final Map<String, FunctionDeclaration> _functions = {};
  final Map<String, _ReducedFunction> _reduced = {};
  final Set<String> _reducing = {};

  FunctionInliner(List<FunctionDeclaration> functions, {this.diagnostics}) {
    for (final f in functions) {
      _functions[f.name] = f;
    }
    for (final f in functions) {
      _reduceFunction(f.name);
    }
  }

  bool isFunction(String name) => _functions.containsKey(name);

  /// Return-value width of a user function, for width analysis.
  VectorWidth? returnWidthOf(String name) => _reduced[name]?.returnWidth;

  /// Produces the inlined expression for `name(args)`, or null when the
  /// function is unknown or its body could not be reduced.
  IrExpression? inline(String name, List<IrExpression> args) {
    final fn = _reduced[name];
    if (fn == null || fn.result == null) return null;
    final env = <String, IrExpression>{};
    for (var i = 0; i < fn.paramNames.length && i < args.length; i++) {
      env[fn.paramNames[i]] = args[i];
    }
    return _subst(fn.result!, env);
  }

  // ── Reduction ────────────────────────────────────────────────────

  _ReducedFunction _reduceFunction(String name) {
    final existing = _reduced[name];
    if (existing != null) return existing;

    final decl = _functions[name]!;
    final paramNames = [
      for (final p in decl.ports)
        if (p.direction == PortDirection.input) p.name,
    ];

    if (_reducing.contains(name)) {
      // Recursive functions are not synthesizable / inlinable.
      diagnostics?.error(
        "function '$name' is recursive and cannot be inlined",
        code: 'GEN0031',
      );
      final r = _ReducedFunction(paramNames, decl.returnWidth, null);
      _reduced[name] = r;
      return r;
    }
    _reducing.add(name);

    final env = <String, IrExpression>{};
    final ok = _applyAll(decl.body, env, name);
    final result = ok ? env[name] : null;

    _reducing.remove(name);

    if (result == null) {
      diagnostics?.warning(
        "function '$name' has a body that cannot be inlined (only straight-"
        'line assignments, if/else, case, and return are supported); calls '
        'to it will not be converted',
        code: 'GEN0030',
      );
    }

    final reduced = _ReducedFunction(paramNames, decl.returnWidth, result);
    _reduced[name] = reduced;
    return reduced;
  }

  /// Applies a statement list to [env] in order, returning false if any
  /// statement is unsupported. The function's value ends up in `env[fname]`.
  bool _applyAll(
    List<IrStatement> stmts,
    Map<String, IrExpression> env,
    String fname,
  ) {
    for (final s in stmts) {
      if (!_apply(s, env, fname)) return false;
    }
    return true;
  }

  bool _apply(
    IrStatement s,
    Map<String, IrExpression> env,
    String fname,
  ) {
    if (s is EmptyStatement) return true;

    if (s is AssignmentStatement) {
      if (s.target is! IdentifierExpression) return false;
      final target = (s.target as IdentifierExpression).identifier;
      env[target] = _subst(s.value, env);
      return true;
    }
    if (s is BlockingAssignmentStatement) {
      if (s.target is! IdentifierExpression) return false;
      env[(s.target as IdentifierExpression).identifier] = _subst(s.value, env);
      return true;
    }
    if (s is NonBlockingAssignmentStatement) {
      if (s.target is! IdentifierExpression) return false;
      env[(s.target as IdentifierExpression).identifier] = _subst(s.value, env);
      return true;
    }

    if (s is ReturnStatement) {
      if (s.value != null) env[fname] = _subst(s.value!, env);
      return true;
    }

    if (s is SequentialBlock) {
      return _applyAll(s.statements, env, fname);
    }

    if (s is IfStatement) {
      final cond = _subst(s.condition, env);
      final thenEnv = Map<String, IrExpression>.of(env);
      if (!_apply(s.thenBranch, thenEnv, fname)) return false;
      final elseEnv = Map<String, IrExpression>.of(env);
      if (s.elseBranch != null && !_apply(s.elseBranch!, elseEnv, fname)) {
        return false;
      }
      return _merge(env, [cond], [thenEnv], elseEnv, fname);
    }

    if (s is CaseStatement) {
      final selector = _subst(s.expression, env);
      final conditions = <IrExpression>[];
      final branchEnvs = <Map<String, IrExpression>>[];
      for (final item in s.items) {
        conditions.add(_matchCondition(selector, item.values, env));
        final itemEnv = Map<String, IrExpression>.of(env);
        if (item.statement != null &&
            !_apply(item.statement!, itemEnv, fname)) {
          return false;
        }
        branchEnvs.add(itemEnv);
      }
      final defaultEnv = Map<String, IrExpression>.of(env);
      if (s.defaultCase != null && !_apply(s.defaultCase!, defaultEnv, fname)) {
        return false;
      }
      return _merge(env, conditions, branchEnvs, defaultEnv, fname);
    }

    // Loops and everything else are unsupported for inlining.
    return false;
  }

  /// Merges branch environments back into [env] as a priority chain of
  /// ternaries: `cond0 ? env0 : (cond1 ? env1 : ... : fallthrough)`. Returns
  /// false when a variable is assigned on some paths but has no value on the
  /// fall-through path (so the result would be undefined).
  bool _merge(
    Map<String, IrExpression> env,
    List<IrExpression> conditions,
    List<Map<String, IrExpression>> branchEnvs,
    Map<String, IrExpression> fallthroughEnv,
    String fname,
  ) {
    final vars = <String>{};
    for (final b in branchEnvs) {
      vars.addAll(b.keys);
    }
    vars.addAll(fallthroughEnv.keys);

    for (final v in vars) {
      final pre = env[v];
      final branchValues =
          branchEnvs.map((b) => b[v] ?? pre).toList(growable: false);
      final fallthrough = fallthroughEnv[v] ?? pre;

      // Unchanged on all paths: nothing to merge.
      final allSame = branchValues.every((val) => identical(val, pre)) &&
          identical(fallthrough, pre);
      if (allSame) continue;

      // Any path missing a value would make this variable undefined.
      if (fallthrough == null || branchValues.any((val) => val == null)) {
        return false;
      }

      var merged = fallthrough;
      for (var i = conditions.length - 1; i >= 0; i--) {
        merged = ConditionalExpression(
          location: conditions[i].location,
          condition: conditions[i],
          trueExpr: branchValues[i]!,
          falseExpr: merged,
        );
      }
      env[v] = merged;
    }
    return true;
  }

  IrExpression _matchCondition(
    IrExpression selector,
    List<IrExpression> values,
    Map<String, IrExpression> env,
  ) {
    IrExpression? condition;
    for (final value in values) {
      final eq = BinaryExpression(
        location: selector.location,
        left: selector,
        right: _subst(value, env),
        operator: BinaryOperator.equal,
      );
      condition = condition == null
          ? eq
          : BinaryExpression(
              location: selector.location,
              left: condition,
              right: eq,
              operator: BinaryOperator.logicalOr,
            );
    }
    return condition ??
        LiteralExpression(
          location: selector.location,
          kind: LiteralKind.integer,
          value: 0,
        );
  }

  // ── Substitution ─────────────────────────────────────────────────

  /// Clones [e], replacing identifiers found in [env] with their expressions
  /// and inlining any nested calls to other user functions.
  IrExpression _subst(IrExpression e, Map<String, IrExpression> env) {
    if (e is IdentifierExpression) {
      if (e.indices.isEmpty && env.containsKey(e.identifier)) {
        return env[e.identifier]!;
      }
      return e;
    }
    if (e is LiteralExpression) return e;
    if (e is BinaryExpression) {
      return BinaryExpression(
        location: e.location,
        left: _subst(e.left, env),
        right: _subst(e.right, env),
        operator: e.operator,
      );
    }
    if (e is UnaryExpression) {
      return UnaryExpression(
        location: e.location,
        operand: _subst(e.operand, env),
        operator: e.operator,
      );
    }
    if (e is ConditionalExpression) {
      return ConditionalExpression(
        location: e.location,
        condition: _subst(e.condition, env),
        trueExpr: _subst(e.trueExpr, env),
        falseExpr: _subst(e.falseExpr, env),
      );
    }
    if (e is ConcatenationExpression) {
      return ConcatenationExpression(
        location: e.location,
        expressions: [for (final x in e.expressions) _subst(x, env)],
      );
    }
    if (e is ReplicationExpression) {
      return ReplicationExpression(
        location: e.location,
        count: _subst(e.count, env),
        operand: _subst(e.operand, env),
      );
    }
    if (e is PartSelectExpression) {
      return PartSelectExpression(
        location: e.location,
        base: _subst(e.base, env),
        msb: _subst(e.msb, env),
        lsb: _subst(e.lsb, env),
      );
    }
    if (e is IndexedPartSelectExpression) {
      return IndexedPartSelectExpression(
        location: e.location,
        base: _subst(e.base, env),
        index: _subst(e.index, env),
      );
    }
    if (e is FunctionCallExpression) {
      final args = [for (final a in e.arguments) _subst(a, env)];
      if (isFunction(e.functionName)) {
        _reduceFunction(e.functionName);
        final inlined = inline(e.functionName, args);
        if (inlined != null) return inlined;
      }
      return FunctionCallExpression(
        location: e.location,
        functionName: e.functionName,
        arguments: args,
      );
    }
    return e;
  }
}
