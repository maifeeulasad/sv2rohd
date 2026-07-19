// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// A 2D array of registers, to exercise multi-dimensional unpacked arrays
// (nested List<List<Logic>>) and multi-level constant indexing inside a
// nested for-generate.

module matrix_regs #(
  parameter ROWS = 2,
  parameter COLS = 3,
  parameter WIDTH = 8
) (
  input  logic             clk,
  input  logic [WIDTH-1:0] d,
  output logic [WIDTH-1:0] q
);

  logic [WIDTH-1:0] cells [0:ROWS-1][0:COLS-1];

  genvar r, c;
  generate
    for (r = 0; r < ROWS; r++) begin : row
      for (c = 0; c < COLS; c++) begin : col
        always_ff @(posedge clk) begin
          cells[r][c] <= d;
        end
      end
    end
  endgenerate

  assign q = cells[0][0];

endmodule
