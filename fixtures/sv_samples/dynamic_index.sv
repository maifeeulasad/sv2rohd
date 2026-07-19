// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// Indexes an unpacked-array signal with a runtime signal (not a
// parameter/genvar), which sv2rohd cannot currently lower to valid Dart.
// Used to exercise the dynamic-index diagnostic (GEN0025).

module dynamic_index (
  input  logic       clk,
  input  logic [1:0] addr,
  output logic [7:0] q
);

  logic [7:0] mem [0:3];

  always_ff @(posedge clk) begin
    q <= mem[addr];
  end

endmodule
