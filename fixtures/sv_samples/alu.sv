// Copyright (C) 2026
// ALU with generate blocks

module alu #(
  parameter WIDTH = 8,
  parameter DEPTH = 4
) (
  input  logic              clk,
  input  logic              rst_n,
  input  logic [WIDTH-1:0]  a,
  input  logic [WIDTH-1:0]  b,
  input  logic [2:0]        op,
  output logic [WIDTH-1:0]   result,
  output logic              overflow
);

  // Generate pipeline stages
  logic [WIDTH-1:0] stage [0:DEPTH-1];
  logic [DEPTH-1:0] valid_pipe;

  always_ff @(posedge clk) begin
    if (!rst_n) begin
      valid_pipe <= '0;
    end else begin
      valid_pipe <= {valid_pipe[DEPTH-2:0], 1'b1};
    end
  end

  // Combinational operations
  always_comb begin
    case (op)
      3'd0: result = a + b;           // ADD
      3'd1: result = a - b;           // SUB
      3'd2: result = a & b;           // AND
      3'd3: result = a | b;           // OR
      3'd4: result = a ^ b;           // XOR
      3'd5: result = a << 1;          // SLL
      3'd6: result = a >> 1;          // SRL
      default: result = '0;
    endcase
  end

  // For-generate for pipeline
  generate
    for (genvar i = 0; i < DEPTH; i++) begin : pipe_stage
      if (i == 0) begin : first
        always_ff @(posedge clk) begin
          if (!rst_n) stage[i] <= '0;
          else stage[i] <= result;
        end
      end else begin : rest
        always_ff @(posedge clk) begin
          if (!rst_n) stage[i] <= '0;
          else stage[i] <= stage[i-1];
        end
      end
    end
  endgenerate

  // Conditional generate based on width
  generate
    if (WIDTH > 16) begin : wide_alert
      assign overflow = |result[WIDTH-1:WIDTH-2];
    end else begin : normal_alert
      assign overflow = 1'b0;
    end
  endgenerate

endmodule
