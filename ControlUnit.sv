module ControlUnit(
    input Clk, rst,
    output [2:0] ALU_s0;
    output [7:0] D_addr,
    output D_Wr,
    output [15:0] IR_Out,
    output [3:0] NextState,
    output [3:0] OutState,
    output [6:0] PC_Out,
    output [3:0] RF_Ra_addr,
    output [3:0] RF_Rb_addr,
    output [3:0] RF_W_addr,
    output RF_W_en,
    output RF_s
);
    
endmodule