# LogikBench bidirectional coverage — WIP notes

Work-in-progress tooling and findings for running [LogikBench](https://github.com/zeroasiccorp/logikbench)
circuits through sv2rohd's bidirectional equivalence suite
(SV → ROHD → `generateSynth()` → SV → Icarus Verilog miter).

Tracking issue: **#32**. First bug filed: **#31**.

## How to run (on a machine with enough RAM — see warning)

```bash
# one circuit
dart run tool/logikbench_bidir.dart \
  ../logikbench/logikbench/benchmarks/basic/band/rtl/band.v

# a whole group, one top-level process per circuit (memory-safe pattern)
bash tool/logikbench_run_group.sh \
  ../logikbench/logikbench/benchmarks/basic results.txt
```

Categories per circuit: `PASS` / `FAIL(n)` / `UNSUPPORTED` / `ERROR`.

## ⚠ Memory warning
The equivalence check compiles the whole ROHD package and elaborates +
simulates each design. LogikBench uses large default parameters (e.g.
`DW=64`, `N=16`), so some circuits (e.g. `crossbar`) are very memory-hungry.
Running the suite on a default **7.4 GiB WSL2 VM exhausted RAM and crashed the
host**. Use ≥16 GB, or cap each process with `ulimit -v` /
`systemd-run --scope -p MemoryMax=…`.

## Findings — `basic` group (full sweep)

**20 / 24 circuits now pass** the bidirectional equivalence suite (up from 8).
The 12 newly-passing circuits are added as fixtures in
`test/equivalence_test.dart` and `test/roundtrip_pipeline_test.dart`.

| Result | Circuits |
|---|---|
| PASS | band, bin2gray, binv, bnand, bnor, bor, bxnor, bxor, **arbiter**, **bin2prio**, **dffasync**, **dffsync**, **muxcase**, **muxhot**, **muxpri**, **onehot**, **pipeline**, **shiftreg**, **tff**, **tmr** |
| UNSUPPORTED — needs `Combinational.ssa` | gray2bin, crossbar |
| UNSUPPORTED — technology library cell instantiation | icg (`la_clkicgand`), latch (`la_vlatq`) |
| UNSUPPORTED — dynamic-bound part-select (clean diagnostic) | mux |
| ERROR — parser: typed/ranged parameter (`parameter [31:0] SEED`) | fsm (`parametric_fsm_benchmark`) |

### Fixed while sweeping (all covered by tests)
- **#31 — bit/part-select LHS** (`grant[i] = 1'b1`): lowered to a whole-signal
  `sig < sig.withSet(i, v)` instead of the read-only `sig[i] < v`. Also covers
  part-select LHS and indexed part-select LHS (`+:`/`-:`). Fixes arbiter,
  bin2prio; enables onehot, muxhot, crossbar to convert.
- **`$clog2` in an int/width context** emitted `log2Ceil(...)`, but ROHD has no
  top-level `log2Ceil` (only `LogicValue.clog2()`), so *every* `$clog2` design
  produced non-compiling ROHD. sv2rohd now emits a self-contained `log2Ceil`
  helper. (No prior fixture used `$clog2`, so this was latent.)
- **Procedural `for`-loop index variables** are now int-domain (they elaborate
  to Dart `for (var i …)`), so bit-selects like `sig[i]` resolve correctly.
- **Bit/part-select of an int** (e.g. `i[$clog2(N)-1:0]` on a loop var) is now
  integer bit-math, not `Logic.slice` on an `int`.
- **Operator precedence** in elaboration-time expressions: `(i+1)*DW` was
  emitted as `i + 1 * dw` (wrong). `generateInt` is now precedence-aware.
- **`-:` indexed part-select** was lowered as if it were `+:`.
- **`+:`/`-:` part-select on an assignment LHS** hung the parser (infinite
  loop; this is what made `crossbar` exhaust the heap). Now parsed and lowered.
- **Class-name collisions** with ROHD-exported types (`Mux`, `Pipeline`, …) are
  escaped with a trailing underscore (the SV module name is preserved).
- **Dynamic-bound part-select** (`data[sel*DW +: DW]`) now emits a clean
  `GEN0027` diagnostic instead of invalid `.slice(<Logic>)`.
- Test harness: the equivalence checker and roundtrip driver now evaluate
  `$clog2` and default-parameter port widths.

### Remaining failure types (candidates for child issues under #32)
1. **Read-after-write in a combinational block needs `Combinational.ssa`**
   (`gray2bin`, `crossbar`). Blocking self-dependency such as
   `b[i] = b[i+1] ^ in[i]` reads a bit written earlier in the same pass; ROHD
   requires SSA form. sv2rohd emits plain `Combinational([...])`.
2. **Technology library-cell instantiation** (`icg` → `la_clkicgand`, `latch`
   → `la_vlatq`): the design instantiates a standard-cell primitive that has no
   ROHD definition; `latch` also needs a level-sensitive latch primitive.
3. **Parser: typed/ranged parameter** (`parameter [31:0] SEED = …`) in `fsm`
   causes the port list to be dropped (module ports not generated as fields).

## Next steps
1. Run the remaining groups (`arithmetic`, `memory`, …) with
   `logikbench_run_group.sh`; record results.
2. New PASS circuits → add as fixtures and wire into the test lists.
3. File one child issue per remaining failure type above, under #32.
