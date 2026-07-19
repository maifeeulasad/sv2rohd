// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// Priority encoder using casez wildcard bits, to exercise proper
// wildcard-matching Const generation instead of collapsing x/z to 0.

module priority_encoder (
  input  logic [3:0] bits,
  output logic [1:0] pos,
  output logic       valid
);

  always_comb begin
    valid = 1'b1;
    casez (bits)
      4'b1???: pos = 2'd3;
      4'b01??: pos = 2'd2;
      4'b001?: pos = 2'd1;
      4'b0001: pos = 2'd0;
      default: begin
        pos = 2'd0;
        valid = 1'b0;
      end
    endcase
  end

endmodule
