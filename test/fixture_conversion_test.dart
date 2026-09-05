import 'dart:io';

import 'package:test/test.dart';
import 'package:sv2rohd/sv2rohd.dart';

void main() {
  group('fixture conversion', () {
    late Directory tempDir;

    setUp(() {
      tempDir = Directory.systemTemp.createTempSync('sv2rohd-fixtures-');
    });

    tearDown(() {
      if (tempDir.existsSync()) {
        tempDir.deleteSync(recursive: true);
      }
    });

    test('adder emits module header and sequential body', () {
      final converter = SV2ROHD();
      final outputFile = File('${tempDir.path}/adder.dart');

      final output = converter.convert(
        'fixtures/sv_samples/adder.sv',
        outputPath: outputFile.path,
      );

      expect(outputFile.existsSync(), isTrue);
      expect(output, contains('class Adder extends Module'));
      expect(output, contains("addInput('clk', clkSource"));
      expect(output, contains("addOutput('sum'"));
      expect(output, contains('{int width = 8}'));
      expect(output, contains("addInput('a', aSource, width: width)"));
      expect(output, contains("addOutput('sum', width: width + 1)"));
      expect(output, contains('Sequential(clk'));
      expect(output, contains('If(~rstN'));
      // SystemVerilog context rules extend a and b to the width of sum so
      // the carry bit is preserved.
      expect(
        output,
        contains('sum < (a.zeroExtend(sum.width) + b.zeroExtend(sum.width))'),
      );
      expect(output, contains('ready < 1'));
    });

    test('alu emits combinational case logic and elaborated generates', () {
      final converter = SV2ROHD();
      final outputFile = File('${tempDir.path}/alu.dart');

      final output = converter.convert(
        'fixtures/sv_samples/alu.sv',
        outputPath: outputFile.path,
      );

      expect(outputFile.existsSync(), isTrue);
      expect(output, contains('class Alu extends Module'));
      expect(output, contains('late final List<Logic> stage'));
      expect(output, contains('late final Logic validPipe'));
      expect(output, contains('{int width = 8, int depth = 4}'));
      expect(output, contains('Combinational(['));
      expect(output, contains('Case(op'));
      // All seven operations of the case statement are converted.
      expect(output, contains('result < (a + b)'));
      expect(output, contains('result < (a - b)'));
      expect(output, contains('result < (a & b)'));
      expect(output, contains('result < (a | b)'));
      expect(output, contains('result < (a ^ b)'));
      expect(output, contains('result < (a << 1)'));
      expect(output, contains('result < (a >>> 1)'));
      // The for-generate is elaborated into a Dart loop over the parameter.
      expect(output, contains('for (var i = 0; i < depth; i++)'));
      expect(output, contains('stage[i] < stage[i - 1]'));
      // The if-generate becomes a Dart if on the parameter.
      expect(output, contains('if (width > 16)'));
      expect(output, contains('overflow <= Const(0'));
    });

    test('multiplier emits sequential logic and product assignment', () {
      final converter = SV2ROHD();
      final outputFile = File('${tempDir.path}/multiplier.dart');

      final output = converter.convert(
        'fixtures/sv_samples/multiplier.sv',
        outputPath: outputFile.path,
      );

      expect(outputFile.existsSync(), isTrue);
      expect(output, contains('class Multiplier extends Module'));
      expect(output, contains('late final Logic counter'));
      expect(output, contains('late final Logic partial'));
      expect(output, contains('late final Logic resultReg'));
      expect(output, contains('Sequential(clk'));
      expect(output, contains('If(~rstN'));
      expect(output, contains('product <= resultReg;'));
    });

    test(
        'async_reset uses Sequential reset/resetValues sugar and warns '
        'about the async-reset limitation', () {
      final converter = SV2ROHD();
      final outputFile = File('${tempDir.path}/async_reset.dart');

      final output = converter.convert(
        'fixtures/sv_samples/async_reset.sv',
        outputPath: outputFile.path,
      );

      expect(outputFile.existsSync(), isTrue);
      expect(output, contains('class AsyncResetReg extends Module'));
      expect(output, contains('Sequential(clk, ['));
      expect(output, contains('q < d'));
      expect(output, contains('], reset: ~rstN, resetValues: {'));
      expect(output, contains('q: 0,'));

      // The installed ROHD version has no async-trigger primitive, so this
      // must always be flagged rather than silently modeled as synchronous.
      expect(
        converter.diagnostics.warnings.map((d) => d.code),
        contains('GEN0026'),
      );
      expect(
        converter.diagnostics.warnings
            .map((d) => d.message)
            .any((m) => m.contains('synchronous-equivalent')),
        isTrue,
      );
    });

    test(
        'casez_wildcard preserves wildcard bits instead of collapsing them '
        'to 0', () {
      final converter = SV2ROHD();
      final outputFile = File('${tempDir.path}/casez_wildcard.dart');

      final output = converter.convert(
        'fixtures/sv_samples/casez_wildcard.sv',
        outputPath: outputFile.path,
      );

      expect(outputFile.existsSync(), isTrue);
      expect(output, contains('CaseZ(bits, ['));
      expect(output, contains("Const(LogicValue.ofString('1zzz'))"));
      expect(output, contains("Const(LogicValue.ofString('01zz'))"));
      expect(output, contains("Const(LogicValue.ofString('001z'))"));
      // The one case item with no wildcard digits keeps the plain form.
      expect(output, contains('Const(1, width: bits.width)'));
    });

    test('keyword_names escapes Dart-reserved identifiers but keeps SV names',
        () {
      final converter = SV2ROHD();
      final outputFile = File('${tempDir.path}/keyword_names.dart');

      final output = converter.convert(
        'fixtures/sv_samples/keyword_names.sv',
        outputPath: outputFile.path,
      );

      expect(outputFile.existsSync(), isTrue);
      // Dart identifiers are escaped...
      expect(output, contains('late final Logic in_;'));
      expect(output, contains('late final Logic is_;'));
      expect(output, contains('late final Logic switch_;'));
      expect(
          output, contains('KeywordNames(Logic in_Source, Logic is_Source)'));
      // ...but the ROHD-level SV port/signal names are preserved verbatim.
      expect(output, contains("addInput('in', in_Source"));
      expect(output, contains("addInput('is', is_Source"));
      expect(output, contains("Logic(name: 'switch'"));
      expect(converter.hasErrors, isFalse);
    });

    test('matrix_regs emits nested lists for a 2D unpacked array', () {
      final converter = SV2ROHD();
      final outputFile = File('${tempDir.path}/matrix_regs.dart');

      final output = converter.convert(
        'fixtures/sv_samples/matrix_regs.sv',
        outputPath: outputFile.path,
      );

      expect(outputFile.existsSync(), isTrue);
      expect(output, contains('late final List<List<Logic>> cells;'));
      // One List.generate per dimension, with a per-element flattened name.
      expect(
        output,
        contains('cells = List.generate(rows, (i0) => '
            'List.generate(cols, (i1) => '
            "Logic(name: 'cells_\${i0}_\${i1}', width: width)));"),
      );
      // Two-level constant indexing in the generated logic.
      expect(output, contains('cells[r][c] < d'));
      expect(output, contains('q <= cells[0][0]'));
      expect(converter.hasErrors, isFalse);
    });

    test('case_generate lowers to an if/else chain over the parameter', () {
      final converter = SV2ROHD();
      final outputFile = File('${tempDir.path}/case_generate.dart');

      final output = converter.convert(
        'fixtures/sv_samples/case_generate.sv',
        outputPath: outputFile.path,
      );

      expect(outputFile.existsSync(), isTrue);
      expect(output, contains('if (mode == 0) {'));
      expect(output, contains('} else if (mode == 1) {'));
      // A multi-value item becomes an OR of equality checks.
      expect(output, contains('} else if (mode == 2 || mode == 3) {'));
      // The default branch becomes the trailing else.
      expect(output, contains('} else {'));
      expect(output, contains('y <= (a + b)'));
      expect(output, contains('y <= a;'));
      expect(converter.hasErrors, isFalse);
    });

    test('fsm converts a typedef-enum state machine', () {
      final converter = SV2ROHD();
      final outputFile = File('${tempDir.path}/fsm.dart');

      final output = converter.convert(
        'fixtures/sv_samples/fsm.sv',
        outputPath: outputFile.path,
      );

      expect(outputFile.existsSync(), isTrue);
      // Enum members become local int constants...
      expect(output, contains('final idle = 0;'));
      expect(output, contains('final run = 1;'));
      expect(output, contains('final done = 2;'));
      // ...and the enum-typed signals become 2-bit logic.
      expect(output, contains("state = Logic(name: 'state', width: 2)"));
      expect(
          output, contains("nextState = Logic(name: 'next_state', width: 2)"));
      // Case items and comparisons reference the member constants.
      expect(output, contains('Case(state, ['));
      expect(output, contains('CaseItem(Const(idle, width: state.width)'));
      expect(output, contains('active <= state.eq(run)'));
      // The ternary branches are sized to the assignment target.
      expect(
        output,
        contains('mux(go, Const(run, width: nextState.width), '
            'Const(idle, width: nextState.width))'),
      );
      expect(converter.hasErrors, isFalse);
    });

    test('functions are inlined at their call sites', () {
      final converter = SV2ROHD();
      final outputFile = File('${tempDir.path}/functions.dart');

      final output = converter.convert(
        'fixtures/sv_samples/functions.sv',
        outputPath: outputFile.path,
      );

      expect(outputFile.existsSync(), isTrue);
      // No residual function-call syntax survives inlining.
      expect(output, isNot(contains('add_sat(')));
      expect(output, isNot(contains('max2(')));
      expect(output, isNot(contains('blend(')));
      expect(output, isNot(contains('parity(')));
      // if/else function -> ternary; reduction -> .xor(); nested -> inlined.
      expect(output, contains('maxVal <= (mux(a.gt(b), a, b));'));
      expect(output, contains('par <= a.xor();'));
      expect(output,
          contains('mux(sel, (mux((a + b).gt(a), (a + b), a)), (a + b))'));
      expect(converter.hasErrors, isFalse);
    });

    test('signed comparisons use the two-complement mux identity', () {
      final converter = SV2ROHD();
      final outputFile = File('${tempDir.path}/signed_cmp.dart');

      final output = converter.convert(
        'fixtures/sv_samples/signed_cmp.sv',
        outputPath: outputFile.path,
      );

      expect(outputFile.existsSync(), isTrue);
      // a < b (signed) -> mux on the sign bits, else unsigned lt.
      expect(output, contains('aLtB <= mux(a[-1].neq(b[-1]), a[-1], a.lt(b))'));
      // a >= b (signed) -> ~(a < b signed).
      expect(
          output, contains('aGeB <= ~mux(a[-1].neq(b[-1]), a[-1], a.lt(b))'));
      // a > 0 (signed): the literal is sized to a's 8-bit width.
      expect(output, contains('Const(0, width: 8)'));
      expect(converter.hasErrors, isFalse);
    });

    test('assertions/properties are skipped but the real logic converts', () {
      final converter = SV2ROHD();
      final outputFile = File('${tempDir.path}/with_assertions.dart');

      final output = converter.convert(
        'fixtures/sv_samples/with_assertions.sv',
        outputPath: outputFile.path,
      );

      expect(outputFile.existsSync(), isTrue);
      // The surrounding logic survives the assertion skipping.
      expect(output, contains('class WithAssertions extends Module'));
      expect(output, contains('sum < (a + b)'));
      // No assertion/property residue leaks into the output (the `|->`
      // implication and `endproperty` only appear in the skipped SVA).
      expect(output, isNot(contains('|->')));
      expect(output, isNot(contains('endproperty')));
      // Clean diagnostics, no hard errors.
      expect(converter.hasErrors, isFalse);
      final warnings = converter.diagnostics.warnings.map((d) => d.message);
      expect(warnings.any((m) => m.contains('property declarations')), isTrue);
      expect(
        warnings.where((m) => m.contains('assertions are not supported')),
        hasLength(2),
      );
    });

    test('hierarchy emits both modules and resolved instantiations', () {
      final converter = SV2ROHD();
      final outputFile = File('${tempDir.path}/hierarchy.dart');

      final output = converter.convert(
        'fixtures/sv_samples/hierarchy.sv',
        outputPath: outputFile.path,
      );

      expect(outputFile.existsSync(), isTrue);
      expect(output, contains('class FullAdder extends Module'));
      expect(output, contains('class HalfAdder extends Module'));
      // Named connections are resolved to positional constructor arguments.
      expect(output, contains('final ha1 = HalfAdder(a, b);'));
      expect(output, contains('final ha2 = HalfAdder(s1, cin);'));
      // Instance outputs are wired back to the connected signals.
      expect(output, contains('s1 <= ha1.s;'));
      expect(output, contains('sum <= ha2.s;'));
      expect(output, contains('cout <= (c1 | c2);'));
    });

    test('bit-select LHS lowers to whole-signal withSet (issue #31)', () {
      final converter = SV2ROHD();
      final outputFile = File('${tempDir.path}/arbiter.dart');

      final output = converter.convert(
        'fixtures/sv_samples/arbiter.sv',
        outputPath: outputFile.path,
      );

      expect(converter.hasErrors, isFalse, reason: converter.diagnosticSummary);
      // A bit-select LHS `grant[i] = 1'b1` must NOT become `grant[i] < …`
      // (ROHD rejects a bit-select as an unassignable target); it is lowered
      // to a whole-signal `withSet` that replaces bit `i`.
      expect(output, contains('grant < grant.withSet(i, Const(1, width: 1))'));
      expect(output, isNot(contains('grant[i] <')));
      // The procedural for-loop index is treated as an elaboration-time int,
      // so no spurious "not a parameter or genvar" warning fires.
      expect(
        converter.diagnostics.warnings.map((d) => d.code),
        isNot(contains('GEN0002')),
      );
    });

    test('part-select LHS lowers to withSet with the right width (issue #31)',
        () {
      final converter = SV2ROHD();
      final outputFile = File('${tempDir.path}/partsel_write.dart');

      final output = converter.convert(
        'fixtures/sv_samples/partsel_write.sv',
        outputPath: outputFile.path,
      );

      expect(converter.hasErrors, isFalse, reason: converter.diagnosticSummary);
      // `y[7:4] = 4'hA` -> withSet at the lsb with a width-4 update.
      expect(
        output,
        contains('y < y.withSet(4, Const(10, width: (7) - (4) + 1))'),
      );
      // `y[0] = 1'b1` -> withSet at bit 0 with a width-1 update.
      expect(output, contains('y < y.withSet(0, Const(1, width: 1))'));
    });

    test('\$clog2 emits a self-contained log2Ceil helper', () {
      final converter = SV2ROHD();
      final outputFile = File('${tempDir.path}/onehot.dart');

      final output = converter.convert(
        'fixtures/sv_samples/onehot.sv',
        outputPath: outputFile.path,
      );

      expect(converter.hasErrors, isFalse, reason: converter.diagnosticSummary);
      // ROHD has no top-level log2Ceil, so the file defines its own.
      expect(
        output,
        contains('int log2Ceil(int x) => x <= 1 ? 0 : (x - 1).bitLength;'),
      );
      expect(output, contains('log2Ceil(dw)'));
      // A part-select of the int loop variable is integer bit math, not slice.
      expect(output, isNot(contains('i.slice(')));
    });

    test('module name colliding with a ROHD type is escaped', () {
      final converter = SV2ROHD();
      final outputFile = File('${tempDir.path}/pipeline.dart');

      final output = converter.convert(
        'fixtures/sv_samples/pipeline.sv',
        outputPath: outputFile.path,
      );

      expect(converter.hasErrors, isFalse, reason: converter.diagnosticSummary);
      // `Pipeline` clashes with ROHD's exported `Pipeline`, so the Dart class
      // is escaped; the SystemVerilog module name is preserved.
      expect(output, contains('class Pipeline_ extends Module'));
      expect(output, contains("super(name: 'pipeline')"));
    });

    test('indexed part-select and precedence are lowered correctly', () {
      final converter = SV2ROHD();
      final outputFile = File('${tempDir.path}/muxhot.dart');

      final output = converter.convert(
        'fixtures/sv_samples/muxhot.sv',
        outputPath: outputFile.path,
      );

      expect(converter.hasErrors, isFalse, reason: converter.diagnosticSummary);
      // `in[((i+1)*DW-1) -: DW]` -> descending slice with `(i + 1)` preserved.
      expect(
        output,
        contains(
            'in_.slice((i + 1) * dw - 1, (i + 1) * dw - 1 - (dw - 1))'),
      );
    });

    test('typed/ranged parameter does not drop the port list (#35)', () {
      final converter = SV2ROHD();
      final outputFile = File('${tempDir.path}/parametric_fsm.dart');

      final output = converter.convert(
        'fixtures/sv_samples/parametric_fsm.sv',
        outputPath: outputFile.path,
      );

      // `parameter [31:0] SEED = ...` must not swallow the ANSI port list.
      expect(converter.hasErrors, isFalse, reason: converter.diagnosticSummary);
      expect(output, contains('class ParametricFsmBenchmark extends Module'));
      expect(output, contains("clk = addInput('clk', clkSource, width: 1)"));
      expect(output, contains("in_ = addInput('in', in_Source, width: dw)"));
      expect(output, contains("out = addOutput('out', width: dw)"));
      // The ranged parameter is a normal int constructor arg.
      expect(output, contains('int seed = 2779096485'));
    });

    test('dynamic-bound part-select is a clean diagnostic, not broken code',
        () {
      final converter = SV2ROHD();
      final outputFile = File('${tempDir.path}/mux.dart');

      final output = converter.convert(
        'fixtures/sv_samples/mux.sv',
        outputPath: outputFile.path,
      );

      // `data[sel*DW +: DW]` has runtime bounds; ROHD slice needs constants.
      expect(converter.hasErrors, isTrue);
      expect(
        converter.diagnostics.errors.map((d) => d.code),
        contains('GEN0027'),
      );
      // No invalid `.slice(<Logic>)` is emitted.
      expect(output, isNot(contains('.slice(sel')));
    });
  });
}
