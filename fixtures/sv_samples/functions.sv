// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// Combinational helper functions, to exercise function inlining: a simple
// single-return function, one with a local temp and a nested call, and one
// using if/else (which becomes a ternary when inlined).

module alu_fn (
  input  logic [7:0] a,
  input  logic [7:0] b,
  input  logic       sel,
  output logic [7:0] max_val,
  output logic [7:0] combined,
  output logic       par
);

  // Single-expression function.
  function automatic logic [7:0] add_sat(logic [7:0] x, logic [7:0] y);
    return x + y;
  endfunction

  // if/else -> ternary when inlined.
  function automatic logic [7:0] max2(logic [7:0] x, logic [7:0] y);
    if (x > y) return x;
    else return y;
  endfunction

  // Local temp + a nested call to another function.
  function automatic logic [7:0] blend(logic [7:0] x, logic [7:0] y);
    logic [7:0] t;
    t = add_sat(x, y);
    return max2(t, x);
  endfunction

  // Reduction via a local, exercising bit operations.
  function automatic logic parity(logic [7:0] x);
    return ^x;
  endfunction

  assign max_val = max2(a, b);
  assign combined = sel ? blend(a, b) : add_sat(a, b);
  assign par = parity(a);

endmodule
