// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// Deliberately leaves an instance input unconnected, to exercise the
// unconnected-port diagnostic (GEN0024).

module leaf (
  input  logic a,
  input  logic b,
  output logic y
);
  assign y = a & b;
endmodule

module top (
  input  logic a,
  output logic y
);
  leaf u_leaf (.a(a), .y(y));
endmodule
