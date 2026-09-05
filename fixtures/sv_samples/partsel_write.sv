// Exercises procedural assignment to a bit-select and a part-select LHS
// (issue #31): both are lowered to whole-signal `withSet` conditionals because
// ROHD treats a bit/part-select result as read-only.
module partsel_write (
    input  logic [7:0] a,
    input  logic       sel,
    input  logic [1:0] idx_ignored, // kept to vary the port set a little
    output logic [7:0] y
);

  always @(*) begin
    y = a;
    if (sel) begin
      y[7:4] = 4'hA; // part-select LHS, constant bounds
      y[0]   = 1'b1; // bit-select LHS, constant index
    end
  end

endmodule
