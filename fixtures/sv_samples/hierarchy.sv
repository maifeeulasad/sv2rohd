// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// Full adder built from two half adders, for testing module instantiation.

module full_adder (
  input  logic a,
  input  logic b,
  input  logic cin,
  output logic sum,
  output logic cout
);

  logic s1, c1, c2;

  half_adder ha1 (.x(a), .y(b), .s(s1), .c(c1));
  half_adder ha2 (.x(s1), .y(cin), .s(sum), .c(c2));

  assign cout = c1 | c2;

endmodule

module half_adder (
  input  logic x,
  input  logic y,
  output logic s,
  output logic c
);

  assign s = x ^ y;
  assign c = x & y;

endmodule
