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

## Findings so far — `basic` group (partial; run stopped for memory)

| Result | Circuits |
|---|---|
| PASS (candidates to add as fixtures) | band, bin2gray, binv, bnand, bnor, bor, bxnor, bxor |
| FAIL — bit/part-select assignment (#31) | arbiter, bin2prio |
| not yet run | crossbar, dffasync, dffsync, fsm, gray2bin, icg, latch, mux, muxcase, muxhot, muxpri, onehot, pipeline, shiftreg, tff, tmr |

### #31 — assignment to a bit/part-select
sv2rohd emits `grant[i] < 1` for a SystemVerilog bit-select LHS (`grant[i] = 1'b1;`).
ROHD marks `grant[i]` as read-only → "has been marked as unassignable" at
construction. See issue #31 for repro and suggested fix.

## Next steps
1. Move to a higher-RAM machine.
2. Run each group with `logikbench_run_group.sh`; record results.
3. PASS circuits → copy RTL into `fixtures/sv_samples/` and add to the fixture
   lists in `test/equivalence_test.dart` and `test/roundtrip_pipeline_test.dart`.
4. FAIL circuits → group by failure type; file one child issue per type under #32.
