module Processor (
    input Clk, ResetN;
    output [15:0] IR_Out;// Instruction register
    output [7:0] PC_Out; // Program counter
    output [3:0] State; // FSM current state
    output [3:0] NextState; // FSM next state (or 0 if you don’t use one)
    output [15:0] ALU_A; // ALU A-Side Input
    output [15:0] ALU_B; // ALU B-Side Input
    output [15:0] ALU_Out; // ALU current output
);

endmodule