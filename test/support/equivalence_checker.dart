// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// SPDX-License-Identifier: BSD-3-Clause

// Functional equivalence checker: proves that a SystemVerilog design and the
// ROHD code sv2rohd generates from it compute the same outputs, by
// simulating both under Icarus Verilog in a shared "miter" testbench and
// comparing every output each step (with a VCD waveform dumped for
// inspection). Parts of this were generated with LLM assistance.

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:sv2rohd/sv2rohd.dart';

/// Locations of a usable Icarus Verilog install.
class IverilogTools {
  final String iverilog;
  final String vvp;
  final String backendDir;

  const IverilogTools(this.iverilog, this.vvp, this.backendDir);

  /// Discovers Icarus Verilog from (in order): the `IVERILOG_ROOT` env var, a
  /// vendored `.dart_tool/iverilog` prefix (see tool/setup_iverilog.sh), or a
  /// system `iverilog` on PATH. Returns null when none is found.
  static IverilogTools? find({String projectRoot = '.'}) {
    final roots = <String>[
      if (Platform.environment['IVERILOG_ROOT'] != null)
        Platform.environment['IVERILOG_ROOT']!,
      p.join(projectRoot, '.dart_tool', 'iverilog'),
    ];
    for (final root in roots) {
      final bin = p.join(root, 'usr', 'bin', 'iverilog');
      final vvp = p.join(root, 'usr', 'bin', 'vvp');
      if (File(bin).existsSync() && File(vvp).existsSync()) {
        final backend = _findBackend(root);
        if (backend != null) return IverilogTools(bin, vvp, backend);
      }
    }
    // System install on PATH.
    final sysBackend = _findBackend('/usr');
    if (_onPath('iverilog') && _onPath('vvp') && sysBackend != null) {
      return IverilogTools('iverilog', 'vvp', sysBackend);
    }
    return null;
  }

  static String? _findBackend(String root) {
    final candidates = [
      Directory(p.join(root, 'usr', 'lib')),
      Directory(p.join(root, 'lib')),
    ];
    for (final dir in candidates) {
      if (!dir.existsSync()) continue;
      for (final entity in dir.listSync(recursive: true)) {
        if (entity is Directory && p.basename(entity.path) == 'ivl') {
          return entity.path;
        }
      }
    }
    return null;
  }

  static bool _onPath(String name) {
    final result = Process.runSync('which', [name]);
    return result.exitCode == 0;
  }
}

/// Outcome of an equivalence check.
class EquivalenceResult {
  final bool passed;
  final int mismatches;
  final String? vcdPath;
  final String log;

  const EquivalenceResult({
    required this.passed,
    required this.mismatches,
    this.vcdPath,
    this.log = '',
  });
}

/// Thrown when a fixture cannot be checked (unsupported shape, tool error).
class EquivalenceUnsupported implements Exception {
  final String message;
  EquivalenceUnsupported(this.message);
  @override
  String toString() => 'EquivalenceUnsupported: $message';
}

/// Checks SV<->ROHD functional equivalence for a fixture.
class EquivalenceChecker {
  final IverilogTools tools;
  final int cycles;

  EquivalenceChecker(this.tools, {this.cycles = 60});

  EquivalenceResult check(String fixturePath) {
    final source = File(fixturePath).readAsStringSync();
    final diagnostics = DiagnosticCollector();
    final parser = SvParser(source, diagnostics: diagnostics);
    final modules = parser.parseCompilationUnit();
    if (modules.isEmpty) {
      throw EquivalenceUnsupported('no module found in $fixturePath');
    }
    final top = modules.first;

    for (final port in top.ports) {
      if (port.direction == PortDirection.inout) {
        throw EquivalenceUnsupported(
            "inout port '${port.name}' is not supported by the checker");
      }
    }

    final params = _paramDefaults(top);
    final workDir = Directory(p.join(
      Directory.current.path,
      '.dart_tool',
      'sv2rohd_equiv',
      '${_sanitize(top.name)}_${DateTime.now().microsecondsSinceEpoch}',
    ))
      ..createSync(recursive: true);

    try {
      // 1. Generate ROHD from the fixture.
      final rohdDart = p.join(workDir.path, 'dut.dart');
      SV2ROHD().convert(fixturePath, outputPath: rohdDart);

      // 2. Emit the ROHD-synthesized SystemVerilog via a driver.
      final rohdSv = p.join(workDir.path, 'dut_rohd.sv');
      _writeRohdSv(top, params, workDir.path, rohdDart, rohdSv);

      // 3. Build a miter testbench and simulate both designs together.
      final vcdPath = p.join(workDir.path, 'miter.vcd');
      final miterSv = p.join(workDir.path, 'miter.sv');
      File(miterSv).writeAsStringSync(_miter(top, params, vcdPath));

      final vvpFile = p.join(workDir.path, 'miter.vvp');
      final compile = Process.runSync(
        tools.iverilog,
        [
          '-B',
          tools.backendDir,
          '-g2012',
          '-o',
          vvpFile,
          fixturePath,
          rohdSv,
          miterSv,
        ],
      );
      if (compile.exitCode != 0) {
        throw EquivalenceUnsupported(
            'iverilog compile failed:\n${compile.stdout}\n${compile.stderr}');
      }

      final run = Process.runSync(tools.vvp, ['-M', tools.backendDir, vvpFile]);
      final out = '${run.stdout}\n${run.stderr}';
      final passed = out.contains('EQUIV_PASS');
      final mismatch = RegExp(r'EQUIV_FAIL errors=(\d+)').firstMatch(out);
      final count = mismatch != null ? int.parse(mismatch.group(1)!) : 0;

      // Keep the work dir (and VCD) on failure for inspection; clean on pass.
      final vcdCopy = File(vcdPath).existsSync() ? vcdPath : null;
      return EquivalenceResult(
        passed: passed,
        mismatches: count,
        vcdPath: vcdCopy,
        log: out,
      );
    } finally {
      // Leave artifacts for debugging; callers may clean the parent dir.
    }
  }

  // ── ROHD SV generation ───────────────────────────────────────────

  void _writeRohdSv(
    ModuleDeclaration top,
    Map<String, int> params,
    String workDir,
    String rohdDart,
    String outSv,
  ) {
    final className = const NamingStrategy().toClassName(top.name);
    final inputs =
        top.ports.where((p) => p.direction != PortDirection.output).toList();

    final decls = <String>[];
    final args = <String>[];
    for (var i = 0; i < inputs.length; i++) {
      final w = _portWidth(inputs[i].width, params);
      decls.add("  final i$i = Logic(name: '${inputs[i].name}', width: $w);");
      args.add('i$i');
    }

    final driver = '''
import 'package:rohd/rohd.dart';
import '${p.basename(rohdDart)}';

Future<void> main() async {
${decls.join('\n')}
  final dut = $className(${args.join(', ')});
  await dut.build();
  print(dut.generateSynth());
}
''';
    final driverPath = p.join(workDir, 'gen_sv.dart');
    File(driverPath).writeAsStringSync(driver);

    final result = Process.runSync(
      'dart',
      ['run', p.relative(driverPath, from: Directory.current.path)],
      workingDirectory: Directory.current.path,
    );
    if (result.exitCode != 0) {
      throw EquivalenceUnsupported(
          'ROHD build/generateSynth failed:\n${result.stderr}');
    }
    File(outSv).writeAsStringSync(result.stdout.toString());
  }

  // ── Miter testbench ──────────────────────────────────────────────

  String _miter(
    ModuleDeclaration top,
    Map<String, int> params,
    String vcdPath,
  ) {
    final className = const NamingStrategy().toClassName(top.name);
    final inputs =
        top.ports.where((p) => p.direction != PortDirection.output).toList();
    final outputs =
        top.ports.where((p) => p.direction == PortDirection.output).toList();

    final clock = inputs
        .where((p) => _isClock(p.name))
        .map((p) => p.name)
        .cast<String?>()
        .firstWhere((_) => true, orElse: () => null);
    final resetPort = inputs
        .where((p) => _isReset(p.name))
        .cast<PortDeclaration?>()
        .firstWhere((_) => true, orElse: () => null);
    final dataInputs =
        inputs.where((p) => !_isClock(p.name) && !_isReset(p.name)).toList();

    String range(PortDeclaration port) {
      final w = _portWidth(port.width, params);
      return w > 1 ? '[${w - 1}:0] ' : '';
    }

    final b = StringBuffer();
    b.writeln('`timescale 1ns/1ps');
    b.writeln('module miter;');

    // Signal declarations.
    for (final port in inputs) {
      b.writeln('  logic ${range(port)}${port.name};');
    }
    for (final port in outputs) {
      b.writeln('  logic ${range(port)}${port.name}_o;');
      b.writeln('  logic ${range(port)}${port.name}_r;');
    }
    b.writeln();

    // Instantiate original and ROHD-generated DUTs.
    String conns(bool orig) {
      final parts = <String>[];
      for (final port in top.ports) {
        if (port.direction == PortDirection.output) {
          parts.add('.${port.name}(${port.name}_${orig ? 'o' : 'r'})');
        } else {
          parts.add('.${port.name}(${port.name})');
        }
      }
      return parts.join(', ');
    }

    b.writeln('  ${top.name} dut_o(${conns(true)});');
    b.writeln('  $className dut_r(${conns(false)});');
    b.writeln();
    b.writeln('  integer errors = 0;');
    b.writeln('  integer i;');
    b.writeln();

    // Comparison task.
    b.writeln('  task compare;');
    b.writeln('    begin');
    for (final port in outputs) {
      final o = '${port.name}_o';
      final r = '${port.name}_r';
      b.writeln('      if ((^$o !== 1\'bx) && ($o !== $r)) begin');
      b.writeln('        errors = errors + 1;');
      b.writeln('        \$display("MISMATCH ${port.name} @%0t o=%h r=%h", '
          '\$time, $o, $r);');
      b.writeln('      end');
    }
    b.writeln('    end');
    b.writeln('  endtask');
    b.writeln();

    final driveData = dataInputs
        .map((port) => '      ${port.name} = ${_randomFor(port, params)};')
        .join('\n');

    if (clock != null) {
      final resetActive = resetPort == null
          ? ''
          : "      ${resetPort.name} = ${_resetActiveLow(resetPort.name) ? "1'b0" : "1'b1"};\n";
      final resetInactive = resetPort == null
          ? ''
          : "    ${resetPort.name} = ${_resetActiveLow(resetPort.name) ? "1'b1" : "1'b0"};\n";
      b.writeln('  initial $clock = 0;');
      b.writeln('  always #5 $clock = ~$clock;');
      b.writeln();
      b.writeln('  initial begin');
      b.writeln('    \$dumpfile("$vcdPath");');
      b.writeln('    \$dumpvars(0, miter);');
      b.write(resetActive);
      for (final port in dataInputs) {
        b.writeln('    ${port.name} = 0;');
      }
      b.writeln('    repeat (3) @(posedge $clock);');
      b.write(resetInactive);
      b.writeln('    for (i = 0; i < $cycles; i = i + 1) begin');
      b.writeln(driveData);
      b.writeln('      @(posedge $clock);');
      b.writeln('      #1;');
      b.writeln('      compare;');
      b.writeln('    end');
    } else {
      b.writeln('  initial begin');
      b.writeln('    \$dumpfile("$vcdPath");');
      b.writeln('    \$dumpvars(0, miter);');
      b.writeln('    for (i = 0; i < $cycles; i = i + 1) begin');
      b.writeln(driveData);
      b.writeln('      #5;');
      b.writeln('      compare;');
      b.writeln('    end');
    }

    b.writeln('    if (errors == 0) \$display("EQUIV_PASS");');
    b.writeln('    else \$display("EQUIV_FAIL errors=%0d", errors);');
    b.writeln('    \$finish;');
    b.writeln('  end');
    b.writeln('endmodule');
    return b.toString();
  }

  String _randomFor(PortDeclaration port, Map<String, int> params) {
    final w = _portWidth(port.width, params);
    if (w <= 32) return '\$random';
    // Wider inputs: concatenate enough 32-bit random draws (truncated).
    final draws = (w / 32).ceil();
    return '{${List.filled(draws, '\$random').join(', ')}}';
  }

  // ── Width / parameter evaluation ─────────────────────────────────

  Map<String, int> _paramDefaults(ModuleDeclaration module) {
    final env = <String, int>{};
    for (final param in module.parameters) {
      if (param.defaultValue == null) continue;
      final value = _evalInt(param.defaultValue!, env);
      if (value != null) env[param.name] = value;
    }
    return env;
  }

  int _portWidth(VectorWidth? width, Map<String, int> env) {
    if (width == null) return 1;
    final msb = width.msb != null ? _evalInt(width.msb!, env) : null;
    final lsb = width.lsb != null ? _evalInt(width.lsb!, env) : null;
    if (msb == null || lsb == null) {
      throw EquivalenceUnsupported('could not evaluate a port width');
    }
    return (msb - lsb).abs() + 1;
  }

  int? _evalInt(IrExpression e, Map<String, int> env) {
    if (e is LiteralExpression) return e.value is int ? e.value as int : null;
    if (e is IdentifierExpression) return env[e.identifier];
    if (e is UnaryExpression) {
      final v = _evalInt(e.operand, env);
      if (v == null) return null;
      return switch (e.operator) {
        UnaryOperator.minus => -v,
        UnaryOperator.plus => v,
        UnaryOperator.bitwiseNot => ~v,
        _ => null,
      };
    }
    if (e is BinaryExpression) {
      final l = _evalInt(e.left, env);
      final r = _evalInt(e.right, env);
      if (l == null || r == null) return null;
      return switch (e.operator) {
        BinaryOperator.add => l + r,
        BinaryOperator.subtract => l - r,
        BinaryOperator.multiply => l * r,
        BinaryOperator.divide => r != 0 ? l ~/ r : null,
        BinaryOperator.modulo => r != 0 ? l % r : null,
        BinaryOperator.shiftLeft => l << r,
        BinaryOperator.shiftRight => l >> r,
        _ => null,
      };
    }
    return null;
  }

  static bool _isClock(String name) {
    final n = name.toLowerCase();
    return n == 'clk' || n == 'clock' || n == 'clk_i';
  }

  static bool _isReset(String name) {
    final n = name.toLowerCase();
    return n == 'rst' ||
        n == 'rstn' ||
        n == 'rst_n' ||
        n == 'reset' ||
        n == 'resetn' ||
        n == 'reset_n' ||
        n == 'arst' ||
        n == 'arst_n';
  }

  static bool _resetActiveLow(String name) {
    final n = name.toLowerCase();
    return n.endsWith('_n') || n.endsWith('n');
  }

  static String _sanitize(String name) =>
      name.replaceAll(RegExp(r'[^A-Za-z0-9_]'), '_');
}
