// Scratch harness: run the sv2rohd bidirectional (SV->ROHD->SV) equivalence
// suite over a LogikBench group and categorize each circuit.
//
// Usage: dart run tool/logikbench_bidir.dart <group-dir>
//   e.g. dart run tool/logikbench_bidir.dart \
//          ../logikbench/logikbench/benchmarks/basic
//
// Prints one line per circuit (PASS / FAIL / UNSUPPORTED / ERROR) plus a
// summary. Not committed (tool/* is gitignored); this is analysis tooling.

import 'dart:io';

import 'package:path/path.dart' as p;

import '../test/support/equivalence_checker.dart';

void main(List<String> args) {
  if (args.isEmpty) {
    stderr.writeln('usage: dart run tool/logikbench_bidir.dart <group-dir>');
    exit(2);
  }
  final groupDir = args.first;
  final tools = IverilogTools.find(projectRoot: Directory.current.path);
  if (tools == null) {
    stderr.writeln('Icarus Verilog not found; run tool/setup_iverilog.sh');
    exit(2);
  }

  // Single-file mode: `dart run ... <path-to.v>` checks one circuit and exits.
  if (groupDir.endsWith('.v') || groupDir.endsWith('.sv')) {
    _runOne(File(groupDir), tools, p.basenameWithoutExtension(groupDir));
    return;
  }

  final circuits = Directory(groupDir)
      .listSync()
      .whereType<Directory>()
      .toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  var pass = 0, fail = 0, unsupported = 0, error = 0, skipped = 0;
  final failing = <String>[];

  for (final dir in circuits) {
    final name = p.basename(dir.path);
    final rtlDir = Directory(p.join(dir.path, 'rtl'));
    if (!rtlDir.existsSync()) {
      continue; // not a circuit dir (README, __init__, etc.)
    }
    final vFiles = rtlDir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.v') || f.path.endsWith('.sv'))
        .toList();
    if (vFiles.isEmpty) continue;

    // Prefer <name>.v as the top file; note multi-file designs.
    final primary = vFiles.firstWhere(
      (f) => p.basenameWithoutExtension(f.path) == name,
      orElse: () => vFiles.first,
    );
    final multi = vFiles.length > 1 ? ' [+${vFiles.length - 1} more .v]' : '';

    try {
      final checker = EquivalenceChecker(tools);
      final result = checker.check(primary.path);
      if (result.passed) {
        pass++;
        stdout.writeln('PASS         $name$multi');
      } else {
        fail++;
        failing.add(name);
        stdout.writeln('FAIL(${result.mismatches})     $name$multi');
      }
    } on EquivalenceUnsupported catch (e) {
      unsupported++;
      final msg = e.toString().replaceAll('\n', ' ');
      stdout.writeln(
          'UNSUPPORTED  $name$multi :: ${msg.substring(0, msg.length.clamp(0, 90))}');
    } catch (e) {
      error++;
      final msg = e.toString().replaceAll('\n', ' ');
      stdout.writeln(
          'ERROR        $name$multi :: ${msg.substring(0, msg.length.clamp(0, 90))}');
    }
  }

  stdout.writeln('');
  stdout.writeln('=== summary: ${p.basename(groupDir)} ===');
  stdout.writeln('PASS=$pass FAIL=$fail UNSUPPORTED=$unsupported '
      'ERROR=$error SKIPPED=$skipped');
  if (failing.isNotEmpty) stdout.writeln('failing: ${failing.join(', ')}');
}

void _runOne(File f, IverilogTools tools, String name) {
  try {
    final result = EquivalenceChecker(tools).check(f.path);
    stdout.writeln(result.passed
        ? 'PASS         $name'
        : 'FAIL(${result.mismatches})     $name');
  } on EquivalenceUnsupported catch (e) {
    stdout.writeln('UNSUPPORTED  $name :: ${e.toString().replaceAll('\n', ' ')}');
  } catch (e) {
    stdout.writeln('ERROR        $name :: ${e.toString().replaceAll('\n', ' ')}');
  } finally {
    final d = Directory('.dart_tool/sv2rohd_equiv');
    if (d.existsSync()) d.deleteSync(recursive: true);
  }
}
