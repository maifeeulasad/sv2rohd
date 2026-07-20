# sv2rohd

Convert SystemVerilog hardware designs to [ROHD](https://github.com/intel/rohd) Dart code.

`sv2rohd` parses the synthesizable subset of SystemVerilog and emits idiomatic
ROHD `Module` classes — parameters become constructor arguments, generate
blocks become Dart `for`/`if` elaboration, and unpacked arrays become
`List<Logic>`. The generated code builds with ROHD and can be simulated or
converted back to SystemVerilog with `generateSynth()`.

> **Note:** Some parts of this codebase were generated with LLM assistance and
> reviewed by the maintainer.

## Example

Input (`adder.sv`):

```systemverilog
module adder #(
  parameter WIDTH = 8
) (
  input  logic             clk,
  input  logic             rst_n,
  input  logic [WIDTH-1:0] a,
  input  logic [WIDTH-1:0] b,
  input  logic             valid,
  output logic [WIDTH:0]   sum,
  output logic             ready
);

  always_ff @(posedge clk) begin
    if (!rst_n) begin
      sum   <= '0;
      ready <= 1'b0;
    end else if (valid) begin
      sum   <= a + b;
      ready <= 1'b1;
    end
  end

endmodule
```

Output (`adder.dart`):

```dart
import 'package:rohd/rohd.dart';

class Adder extends Module {
  late final Logic clk;
  late final Logic rstN;
  late final Logic a;
  late final Logic b;
  late final Logic valid;
  late final Logic sum;
  late final Logic ready;

  Adder(Logic clkSource, Logic rstNSource, Logic aSource, Logic bSource,
      Logic validSource,
      {int width = 8})
      : super(name: 'adder') {
    // Ports
    clk = addInput('clk', clkSource, width: 1);
    rstN = addInput('rst_n', rstNSource, width: 1);
    a = addInput('a', aSource, width: width);
    b = addInput('b', bSource, width: width);
    valid = addInput('valid', validSource, width: 1);
    sum = addOutput('sum', width: width + 1);
    ready = addOutput('ready', width: 1);

    Sequential(clk, [
      If(~rstN, then: [
        sum < 0,
        ready < 0,
      ], orElse: [
        If(valid, then: [
          sum < (a.zeroExtend(sum.width) + b.zeroExtend(sum.width)),
          ready < 1,
        ]),
      ]),
    ]);
  }
}
```

Note how `[WIDTH-1:0]` becomes `width: width`, `[WIDTH:0]` becomes
`width: width + 1`, and the operands of `a + b` are zero-extended so the carry
bit is preserved, matching SystemVerilog assignment-context width rules.

## Installation

Requires the [Dart SDK](https://dart.dev/get-dart) (>= 3.0).

```bash
git clone https://github.com/maifeeulasad/sv2rohd.git
cd sv2rohd
make setup        # dart pub get
```

## Usage

```bash
# Convert a file, print to stdout
dart run sv2rohd -i design.sv

# Write to a file or directory
dart run sv2rohd -i design.sv -o lib/generated/
dart run sv2rohd -i design.sv -o lib/generated/design.dart

# With a YAML configuration file
dart run sv2rohd -c sv2rohd.yaml -i design.sv -o out/

# Other flags
dart run sv2rohd --help
dart run sv2rohd --version
```

Files containing multiple modules are emitted as a single Dart file so module
instantiations resolve each other; named port connections are mapped onto the
generated constructors and instance outputs are wired back with `<=`.

## Supported SystemVerilog subset

| Construct | Translation |
|---|---|
| `module` with parameters and ANSI ports | `Module` subclass; parameters become named `int` constructor arguments |
| Parameterized widths (`[WIDTH-1:0]`, `[2*W-1:0]`) | Dart integer width expressions |
| `logic`/`wire`/`reg`/`bit` declarations | `Logic(...)` signals |
| Unpacked arrays, incl. multi-dim (`logic [7:0] m [0:A][0:B]`) | nested `List<Logic>` via `List.generate` |
| `typedef enum`/inline `enum` (FSM states) | member `int` constants + width-typed `Logic` signals |
| `generate` with `case` | elaborated Dart `if`/`else` chain over the parameter |
| `function` (combinational) | inlined at call sites (body reduced to an expression) |
| `always_ff @(posedge clk)` | `Sequential(clk, [...])` (one per block) |
| `always_comb`, `always @*` | `Combinational([...])` |
| `assign` | continuous assignment via `<=` |
| `if`/`else`, `case`/`casez` (+`default`) | `If(...)`, `Case(...)`/`CaseZ(...)` |
| Blocking / non-blocking assignments | `Conditional` assignments (`<`) |
| `generate` with `for`/`if` (genvars) | elaborated Dart `for`/`if` at construction time |
| Module instantiation (named/positional, `#(...)` overrides) | constructor calls with resolved connections |
| Concatenation `{a, b}` | `[a, b].swizzle()` |
| Replication `{N{x}}` | `x.replicate(n)` |
| Part select `x[msb:lsb]`, bit select `x[i]` | `x.slice(msb, lsb)`, `x[i]` |
| Reductions `&x |x ^x ~&x ~|x ~^x` | `.and()`, `.or()`, `.xor()` (+ `~`) |
| Literals: `8'hFF`, `3'd5`, `'0`, `'1` | sized `Const`s / context-sized ints |
| Size casts `WIDTH'(expr)` | context-determined widths |
| `$clog2`, `$bits`, `$signed`/`$unsigned` | `log2Ceil`, `.width`, pass-through |

Width mismatches between assignment sides are resolved symbolically: when the
target is wider, operands are zero-extended (preserving carries); when
narrower, the value is truncated with `getRange` — mirroring SystemVerilog
context-determined width semantics.

Combinational `function`s are inlined at their call sites: the body is reduced
to a single value expression (straight-line assignments, `if`/`else` and `case`
become nested ternaries, `return`), and the call arguments are substituted for
the parameters. A function body that can't be reduced (e.g. contains a loop)
produces a diagnostic instead of silently wrong output.

Not supported (skipped with diagnostics): interfaces, classes, tasks, functions
with loops, `initial` blocks (use ROHD `Simulator` for testbenches), dynamic
part selects, and x/z four-state literals outside casez/casex (converted to 0
with a warning).

## How it works

```
SystemVerilog ──▶ Preprocessor ──▶ SvScanner ──▶ SvParser ──▶ IR ──▶ RohdGenerator ──▶ ROHD Dart
                  (`include, `define)  (tokens)    (recursive     │
                                                    descent)      ├─ WidthAnalyzer (symbolic widths)
                                                                  ├─ ExpressionGenerator
                                                                  └─ StatementGenerator
```

- **`lib/src/frontend/`** — preprocessor, scanner, and the hand-written
  recursive-descent parser (`sv_parser.dart`).
- **`lib/src/ir/`** — the intermediate representation (modules, statements,
  expressions) with a visitor interface.
- **`lib/src/analysis/`** — symbol tables, type and expression analysis.
- **`lib/src/codegen/`** — ROHD code generation, including the symbolic
  `WidthAnalyzer` that turns parameterized widths into Dart expressions and
  decides when zero-extension/truncation is needed.

sv2rohd builds against the **local ROHD checkout** (the latest, and the
direction ROHD is heading), wired via `dependency_overrides` in `pubspec.yaml`.
Clone it as a sibling directory before running anything:

```bash
make download-rohd   # git clone ... ../rohd
make setup           # dart pub get
```

```bash
make test        # run all tests
make roundtrip   # SV -> ROHD -> build -> SV roundtrip tests
make equiv       # SV<->ROHD functional equivalence (installs Icarus Verilog)
make lint        # dart analyze --fatal-infos
make format      # dart format
make ci          # format check + analyze + test
make run-fixtures  # convert all fixture designs into ./output
```

The roundtrip tests convert each fixture to ROHD, compile and run the result
against ROHD, regenerate SystemVerilog with `generateSynth()`, and check the
output for the expected ports and `always_ff`/`always_comb`/`case` structure.

### Functional equivalence checking

`make equiv` proves that the original SystemVerilog and the ROHD sv2rohd
generates from it compute **the same outputs**, not just that both build:

1. `original.sv` → sv2rohd → ROHD Dart → `generateSynth()` → `rohd_generated.sv`.
2. A generated **miter** testbench instantiates *both* the original module and
   the ROHD-generated one, drives them with identical randomized stimulus
   (clock + reset + data, derived from the module's ports), and compares every
   output each cycle — dumping a VCD waveform for inspection on any mismatch.
3. Both designs are simulated together under [Icarus Verilog](https://steveicarus.github.io/iverilog/);
   any divergence fails the check.

`tool/setup_iverilog.sh` vendors Icarus Verilog into `.dart_tool/iverilog`
without root (it extracts the `.deb`); alternatively set `IVERILOG_ROOT` to an
existing install. When neither is present the equivalence tests skip cleanly.
All bundled fixtures pass equivalence across parameterized widths, generate
blocks, enums/FSMs, inlined functions, `casez` wildcards, multi-dimensional
arrays, and module hierarchy.

## License

BSD-3-Clause — see [LICENSE](LICENSE).
