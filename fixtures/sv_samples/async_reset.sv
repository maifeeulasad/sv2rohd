// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// A register with a genuine asynchronous, active-low reset: `rst_n` appears
// as its own edge (negedge) in the sensitivity list alongside the clock,
// distinct from the common synchronous-reset style used by the other
// fixtures (where reset is only checked inside the clocked body).

module async_reset_reg (
  input  logic       clk,
  input  logic       rst_n,
  input  logic [7:0] d,
  output logic [7:0] q
);

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      q <= 8'h00;
    end else begin
      q <= d;
    end
  end

endmodule
