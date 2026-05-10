// Copyright (C) 2026
// Basic adder module for testing

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
