// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:test/test.dart';

import 'package:sv2rohd/sv2rohd.dart';

class _Fixture {
  final String name;
  final String path;

  const _Fixture(this.name, this.path);
}

void main() {
  group('roundtrip pipeline', () {
    final fixtures = <_Fixture>[
      const _Fixture('adder', 'fixtures/sv_samples/adder.sv'),
      const _Fixture('alu', 'fixtures/sv_samples/alu.sv'),
      const _Fixture('multiplier', 'fixtures/sv_samples/multiplier.sv'),
      const _Fixture('hierarchy', 'fixtures/sv_samples/hierarchy.sv'),
      const _Fixture('async_reset', 'fixtures/sv_samples/async_reset.sv'),
      const _Fixture('casez_wildcard', 'fixtures/sv_samples/casez_wildcard.sv'),
      const _Fixture('keyword_names', 'fixtures/sv_samples/keyword_names.sv'),
      const _Fixture('matrix_regs', 'fixtures/sv_samples/matrix_regs.sv'),
      const _Fixture('case_generate', 'fixtures/sv_samples/case_generate.sv'),
      const _Fixture('fsm', 'fixtures/sv_samples/fsm.sv'),
      const _Fixture('functions', 'fixtures/sv_samples/functions.sv'),
      const _Fixture('signed_cmp', 'fixtures/sv_samples/signed_cmp.sv'),
      const _Fixture('arbiter', 'fixtures/sv_samples/arbiter.sv'),
      const _Fixture('bin2prio', 'fixtures/sv_samples/bin2prio.sv'),
      const _Fixture('add', 'fixtures/sv_samples/add.sv'),
      const _Fixture('mul', 'fixtures/sv_samples/mul.sv'),
      const _Fixture('muladd', 'fixtures/sv_samples/muladd.sv'),
      const _Fixture('partsel_write', 'fixtures/sv_samples/partsel_write.sv'),
      const _Fixture('dffasync', 'fixtures/sv_samples/dffasync.sv'),
      const _Fixture('dffsync', 'fixtures/sv_samples/dffsync.sv'),
      const _Fixture('muxcase', 'fixtures/sv_samples/muxcase.sv'),
      const _Fixture('muxhot', 'fixtures/sv_samples/muxhot.sv'),
      const _Fixture('muxpri', 'fixtures/sv_samples/muxpri.sv'),
      const _Fixture('onehot', 'fixtures/sv_samples/onehot.sv'),
      const _Fixture('parametric_fsm', 'fixtures/sv_samples/parametric_fsm.sv'),
      const _Fixture('pipeline', 'fixtures/sv_samples/pipeline.sv'),
      const _Fixture('shiftreg', 'fixtures/sv_samples/shiftreg.sv'),
      const _Fixture('tff', 'fixtures/sv_samples/tff.sv'),
      const _Fixture('tmr', 'fixtures/sv_samples/tmr.sv'),
    ];

    for (final fixture in fixtures) {
      test('${fixture.name} sv->rohd->sv', () async {
        final runDir = _createRunDir(fixture.name);
        addTearDown(() {
          if (runDir.existsSync()) {
            runDir.deleteSync(recursive: true);
          }
        });

        final namingStrategy = const NamingStrategy();
        final diagnostics = DiagnosticCollector();
        final frontend = Frontend(diagnostics: diagnostics);
        final parsed = frontend.parseFile(fixture.path);
        final builder = IrBuilder(
          diagnostics: diagnostics,
          namingStrategy: namingStrategy,
        );
        final module = builder.buildModule(parsed);

        final rohdPath = p.join(runDir.path, '${fixture.name}.dart');
        final converter = SV2ROHD(
          diagnostics: diagnostics,
          namingStrategy: namingStrategy,
        );
        converter.convert(fixture.path, outputPath: rohdPath);
        expect(converter.hasErrors, isFalse,
            reason: converter.diagnosticSummary);

        final driverPath = p.join(runDir.path, '${fixture.name}_driver.dart');
        final driverSource = _buildDriver(
          module,
          namingStrategy,
          p.basename(rohdPath),
        );
        File(driverPath).writeAsStringSync(driverSource);

        final driverRelative =
            p.relative(driverPath, from: Directory.current.path);
        final result = await Process.run(
          'dart',
          ['run', driverRelative],
          workingDirectory: Directory.current.path,
        );

        expect(
          result.exitCode,
          0,
          reason: result.stderr.toString(),
        );

        final generatedSv = result.stdout.toString();
        _assertSimilarity(module, generatedSv);
      });
    }
  });
}

Directory _createRunDir(String name) {
  final root = Directory(p.join(
    Directory.current.path,
    '.dart_tool',
    'sv2rohd_roundtrip',
  ));
  if (!root.existsSync()) {
    root.createSync(recursive: true);
  }
  final dir = Directory(p.join(
    root.path,
    '${name}_${DateTime.now().microsecondsSinceEpoch}',
  ));
  dir.createSync(recursive: true);
  return dir;
}

String _buildDriver(
  ModuleDeclaration module,
  NamingStrategy namingStrategy,
  String rohdFile,
) {
  final className = namingStrategy.toClassName(module.name);
  final inputs =
      module.ports.where((p) => p.direction != PortDirection.output).toList();

  // The driver instantiates the module with its default parameters, so port
  // source widths must be evaluated with those same defaults (not a hardcoded
  // guess) — otherwise a parameterized port like `[N-1:0]` with `N=16` gets a
  // mismatched source width.
  final params = _paramDefaults(module);

  final inputDecls = inputs.map((port) {
    final name = namingStrategy.toCamelCase(port.name);
    final width = _widthFromVector(port.width, params);
    return "  final $name = Logic(name: '$name', width: $width);";
  }).join('\n');

  final args = inputs.map((p) => namingStrategy.toCamelCase(p.name)).join(', ');

  return '''import 'package:rohd/rohd.dart';
import '$rohdFile';

Future<void> main() async {
$inputDecls
  final dut = $className($args);
  await dut.build();
  print(dut.generateSynth());
}
''';
}

/// Evaluates each module parameter's default value into an int environment
/// keyed by the SystemVerilog parameter name, so parameterized port widths can
/// be computed the same way the generated module computes them.
Map<String, int> _paramDefaults(ModuleDeclaration module) {
  final env = <String, int>{};
  for (final param in module.parameters) {
    final value = param.defaultValue;
    if (value == null) continue;
    final evaluated = _evalInt(value, env);
    if (evaluated != null) env[param.name] = evaluated;
  }
  return env;
}

int _widthFromVector(VectorWidth? width, Map<String, int> params) {
  if (width == null) return 1;
  final msb = width.msb == null ? null : _evalInt(width.msb!, params);
  final lsb = width.lsb == null ? null : _evalInt(width.lsb!, params);
  if (msb != null && lsb != null) {
    return (msb - lsb).abs() + 1;
  }
  // Parameterized width we couldn't evaluate; fall back to a small default.
  return 8;
}

/// Minimal constant-expression evaluator for elaboration-time width math
/// (literals, parameters, and the operators SystemVerilog widths use).
int? _evalInt(IrExpression expr, Map<String, int> env) {
  if (expr is LiteralExpression) {
    final value = expr.value;
    return value is int ? value : null;
  }
  if (expr is IdentifierExpression) {
    return env[expr.identifier];
  }
  if (expr is UnaryExpression) {
    final operand = _evalInt(expr.operand, env);
    if (operand == null) return null;
    return switch (expr.operator) {
      UnaryOperator.plus => operand,
      UnaryOperator.minus => -operand,
      UnaryOperator.bitwiseNot => ~operand,
      _ => null,
    };
  }
  if (expr is BinaryExpression) {
    final l = _evalInt(expr.left, env);
    final r = _evalInt(expr.right, env);
    if (l == null || r == null) return null;
    return switch (expr.operator) {
      BinaryOperator.add => l + r,
      BinaryOperator.subtract => l - r,
      BinaryOperator.multiply => l * r,
      BinaryOperator.divide => r == 0 ? null : l ~/ r,
      BinaryOperator.modulo => r == 0 ? null : l % r,
      BinaryOperator.shiftLeft => l << r,
      BinaryOperator.shiftRight => l >> r,
      _ => null,
    };
  }
  if (expr is FunctionCallExpression && expr.functionName == r'$clog2') {
    if (expr.arguments.isEmpty) return null;
    final arg = _evalInt(expr.arguments.first, env);
    if (arg == null || arg <= 1) return arg == null ? null : 0;
    return (arg - 1).bitLength;
  }
  return null;
}

void _assertSimilarity(ModuleDeclaration module, String sv) {
  final className = const NamingStrategy().toClassName(module.name);
  final moduleNamePattern = RegExp(
    'module\\s+(${RegExp.escape(module.name)}|${RegExp.escape(className)})\\b',
    caseSensitive: false,
  );
  expect(moduleNamePattern.hasMatch(sv), isTrue);

  for (final port in module.ports) {
    final portPattern = RegExp('\\b${RegExp.escape(port.name)}\\b');
    expect(portPattern.hasMatch(sv), isTrue);
  }

  if (_hasSequential(module)) {
    expect(sv.contains('always_ff'), isTrue);
  }

  if (_hasCombinational(module)) {
    expect(sv.contains('always_comb'), isTrue);
  }

  if (_hasCase(module)) {
    // Generated SV may render as `case`, `casez`, or `casex`.
    expect(RegExp('\\bcase[zx]?\\b').hasMatch(sv), isTrue);
  }
}

bool _hasSequential(ModuleDeclaration module) {
  for (final item in module.items) {
    if (item is AlwaysBlock && item.kind == BlockKind.alwaysFf) {
      return true;
    }
    if (item is IrStatement && _containsNonBlocking(item)) {
      return true;
    }
  }
  return false;
}

bool _hasCombinational(ModuleDeclaration module) {
  for (final item in module.items) {
    if (item is AlwaysBlock && item.kind == BlockKind.alwaysComb) {
      return true;
    }
    if (item is IrStatement && !_containsNonBlocking(item)) {
      if (_containsBlocking(item)) {
        return true;
      }
    }
  }
  return false;
}

bool _hasCase(ModuleDeclaration module) {
  for (final item in module.items) {
    if (item is CaseStatement) {
      return true;
    }
    if (item is AlwaysBlock && _containsCase(item.body)) {
      return true;
    }
    if (item is IrStatement && _containsCase(item)) {
      return true;
    }
  }
  return false;
}

bool _containsNonBlocking(IrStatement stmt) {
  if (stmt is AssignmentStatement) {
    return stmt.type == AssignmentType.nonBlocking;
  }
  if (stmt is NonBlockingAssignmentStatement) {
    return true;
  }
  if (stmt is IfStatement) {
    return _containsNonBlocking(stmt.thenBranch) ||
        (stmt.elseBranch != null && _containsNonBlocking(stmt.elseBranch!));
  }
  if (stmt is CaseStatement) {
    for (final item in stmt.items) {
      if (item.statement != null && _containsNonBlocking(item.statement!)) {
        return true;
      }
    }
    if (stmt.defaultCase != null) {
      return _containsNonBlocking(stmt.defaultCase!);
    }
  }
  if (stmt is SequentialBlock) {
    for (final s in stmt.statements) {
      if (_containsNonBlocking(s)) {
        return true;
      }
    }
  }
  if (stmt is ForLoopStatement) {
    return _containsNonBlocking(stmt.body) ||
        (stmt.initialization != null &&
            _containsNonBlocking(stmt.initialization!)) ||
        (stmt.step != null && _containsNonBlocking(stmt.step!));
  }
  if (stmt is WhileLoopStatement) {
    return _containsNonBlocking(stmt.body);
  }
  return false;
}

bool _containsBlocking(IrStatement stmt) {
  if (stmt is AssignmentStatement) {
    return stmt.type == AssignmentType.blocking;
  }
  if (stmt is BlockingAssignmentStatement) {
    return true;
  }
  if (stmt is IfStatement) {
    return _containsBlocking(stmt.thenBranch) ||
        (stmt.elseBranch != null && _containsBlocking(stmt.elseBranch!));
  }
  if (stmt is CaseStatement) {
    for (final item in stmt.items) {
      if (item.statement != null && _containsBlocking(item.statement!)) {
        return true;
      }
    }
    if (stmt.defaultCase != null) {
      return _containsBlocking(stmt.defaultCase!);
    }
  }
  if (stmt is SequentialBlock) {
    for (final s in stmt.statements) {
      if (_containsBlocking(s)) {
        return true;
      }
    }
  }
  if (stmt is ForLoopStatement) {
    return _containsBlocking(stmt.body) ||
        (stmt.initialization != null &&
            _containsBlocking(stmt.initialization!)) ||
        (stmt.step != null && _containsBlocking(stmt.step!));
  }
  if (stmt is WhileLoopStatement) {
    return _containsBlocking(stmt.body);
  }
  return false;
}

bool _containsCase(IrStatement stmt) {
  if (stmt is CaseStatement) {
    return true;
  }
  if (stmt is IfStatement) {
    return _containsCase(stmt.thenBranch) ||
        (stmt.elseBranch != null && _containsCase(stmt.elseBranch!));
  }
  if (stmt is SequentialBlock) {
    for (final s in stmt.statements) {
      if (_containsCase(s)) {
        return true;
      }
    }
  }
  if (stmt is ForLoopStatement) {
    return _containsCase(stmt.body);
  }
  if (stmt is WhileLoopStatement) {
    return _containsCase(stmt.body);
  }
  return false;
}
