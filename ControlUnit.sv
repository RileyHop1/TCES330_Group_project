/*
 * Class:        TCES 330 Spring 2026
 * Names:        Riley Hopper & Jaiden Stipp
 * Date:         June 3, 2026
 * Assignment:   Project
 */

module ControlUnit(
    input clk, rst,
    output [2:0] ALU_s0,
    output [7:0] D_Addr,
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
    logic IRLd_bus, PCClr_bus, PCUp_bus;
    logic [6:0] PCreg;
    logic [15:0] databus, instbus;
    ControllerStateMachine FSM (
        .Clk(clk), 
        .Instruction(instbus), 
        .Rst(rst), 
        .ALUSelect(ALU_s0), 
        .CurrentStateOut(OutState),
        .DAddr(D_Addr),
        .DWrite(D_Wr),
        .IRLd(IRLd_bus),
        .NextStateOut(NextState),
        .PCClr(PCClr_bus),
        .PCUp(PCUp_bus),
        .RFAReadAddr(RF_Ra_addr),
        .RFBReadAddr(RF_Rb_addr),
        .RFSelect(RF_s),
        .RFWriteAddr(RF_W_addr),
        .RFWriteEnable(RF_W_en)
    );

    IR instrucReg (
        .Clk(clk), 
        .Load(IRLd_bus), 
        .Data(databus), 
        .Instruction(instbus)
    );
    PC ctr (
        .Clk(clk),
        .Clr(PCClr_bus),
        .Up(PCUp_bus),
        .Addr(PCreg)
    );
    InstMemory Imem (
        .clock(clk), 
        .address(PCreg), 
        .q(databus)
    );
    assign PC_Out = PCreg;
    assign IR_Out = instbus;
endmodule