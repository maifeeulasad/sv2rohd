// Copyright (C) 2026
// Multiplier module with instantiation

module multiplier #(
  parameter WIDTH = 8
) (
  input  logic             clk,
  input  logic             rst_n,
  input  logic [WIDTH-1:0] a,
  input  logic [WIDTH-1:0] b,
  output logic [2*WIDTH-1:0] product
);

  // Sequential multiplier
  logic [WIDTH-1:0] counter;
  logic [2*WIDTH-1:0] partial;
  logic [2*WIDTH-1:0] result_reg;

  always_ff @(posedge clk) begin
    if (!rst_n) begin
      counter    <= '0;
      partial    <= '0;
      result_reg <= '0;
    end else begin
      if (counter == '0) begin
        partial <= {{WIDTH{a[WIDTH-1]}}, a} * {{WIDTH{b[WIDTH-1]}}, b};
        counter <= WIDTH'(1);
      end else if (counter < WIDTH) begin
        partial <= partial << 1;
        counter <= counter + 1'b1;
      end else begin
        result_reg <= partial;
        counter    <= '0;
      end
    end
  end

  assign product = result_reg;

endmodule
