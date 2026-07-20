// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// A module carrying SystemVerilog assertions (immediate, concurrent, and a
// named property) alongside real logic. The assertions must be skipped
// cleanly with diagnostics while the surrounding logic still converts.

module with_assertions (
  input  logic       clk,
  input  logic       rst_n,
  input  logic [7:0] a,
  input  logic [7:0] b,
  output logic [7:0] sum
);

  // Immediate assertion.
  always_comb begin
    sum = a + b;
  end

  // A named property and a concurrent assertion referencing it.
  property no_overflow_when_reset;
    @(posedge clk) (!rst_n) |-> (sum == 8'h00);
  endproperty

  assert_reset: assert property (no_overflow_when_reset);

  // A bare concurrent assertion.
  assert property (@(posedge clk) a >= 8'h00);

endmodule
