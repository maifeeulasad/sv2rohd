// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// A configurable operator selected at elaboration time via a case-generate,
// to exercise case-generate parsing and its lowering to a Dart if/else chain.

module config_op #(
  parameter MODE = 0
) (
  input  logic [7:0] a,
  input  logic [7:0] b,
  output logic [7:0] y
);

  generate
    case (MODE)
      0: begin : add_mode
        assign y = a + b;
      end
      1: begin : sub_mode
        assign y = a - b;
      end
      2, 3: begin : and_mode
        assign y = a & b;
      end
      default: begin : passthrough
        assign y = a;
      end
    endcase
  endgenerate

endmodule
