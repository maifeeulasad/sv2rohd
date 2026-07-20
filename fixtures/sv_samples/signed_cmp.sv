// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// Signed comparisons and a signed constant compare, to verify two's-
// complement ordering (negative < positive) is preserved. With unsigned
// comparison these would give the wrong answer for negative operands.

module signed_cmp (
  input  logic signed [7:0] a,
  input  logic signed [7:0] b,
  output logic              a_lt_b,
  output logic              a_ge_b,
  output logic              a_gt_zero
);

  assign a_lt_b    = (a < b);
  assign a_ge_b    = (a >= b);
  assign a_gt_zero = (a > 8'sd0);

endmodule
