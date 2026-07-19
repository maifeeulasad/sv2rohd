// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// Ports and signals named after Dart reserved words that are still valid
// SystemVerilog identifiers (`in`, `is`, `switch`), to verify the generated
// Dart identifiers are escaped so the output compiles and builds in ROHD.

module keyword_names (
  input  logic [3:0] in,
  input  logic       is,
  output logic [3:0] out,
  output logic       ready
);

  logic [3:0] switch;

  always_comb begin
    switch = in;
    out = switch;
    ready = is;
  end

endmodule
