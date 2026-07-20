// Copyright (C) 2026, Maifee Ul Asad<maifeeulasad@gmail.com>, BSD-3-Clause
// A small Moore FSM using a typedef enum for its state, to exercise enum
// typedef parsing: members become int constants and the state signals
// become logic of the enum's width.

module fsm (
  input  logic clk,
  input  logic rst_n,
  input  logic go,
  output logic active
);

  typedef enum logic [1:0] {
    IDLE,
    RUN,
    DONE
  } state_t;

  state_t state, next_state;

  always_ff @(posedge clk) begin
    if (!rst_n) state <= IDLE;
    else state <= next_state;
  end

  always_comb begin
    case (state)
      IDLE: next_state = state_t'(go ? RUN : IDLE);
      RUN:  next_state = DONE;
      DONE: next_state = IDLE;
      default: next_state = IDLE;
    endcase
  end

  assign active = (state == RUN);

endmodule
