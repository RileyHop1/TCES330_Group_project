/*
 * Class:        TCES 330 Spring 2026
 * Names:        Riley Hopper & Jaiden Stipp
 * Date:         June 3, 2026
 * Assignment:   Project
 */

/**
 * Control unit: the fetch/decode half of the processor. Wraps the FSM,
 * instruction register, program counter, and instruction memory (ROM). Emits
 * the datapath control signals and exposes PC/IR/state for observing.
 *
 * @inputclk System clock.
 * @input rst Reset (active high) — restarts the FSM.
 * @output ALU_s0 3-bit ALU operation select.
 * @output D_Addr 8-bit data-memory address.
 * @output D_Wr Data-memory write enable.
 * @output IR_Out Current instruction (IR contents).
 * @output NextState FSM next state (observe).
 * @output OutState FSM current state (observe).
 * @output PC_Out Program counter value.
 * @output RF_Ra_addr Register-file read address A.
 * @output RF_Rb_addr Register-file read address B.
 * @output RF_W_addr Register-file write address.
 * @output RF_W_en Register-file write enable.
 * @output RF_s Write-back mux select (ALU vs RAM).
 */
module ControlUnit(
    input clk, rst,
    input [3:0] Flags,
    output logic [2:0] ALU_s0,
    output logic [7:0] D_Addr,
    output logic D_Wr,
    output logic [15:0] IR_Out,
    output logic [3:0] NextState,
    output logic [3:0] OutState,
    output logic [6:0] PC_Out,
    output logic [3:0] RF_Ra_addr,
    output logic [3:0] RF_Rb_addr,
    output logic [3:0] RF_W_addr,
    output logic RF_W_en,
    output logic RF_s
);
    logic IRLd_bus, PCClr_bus, PCUp_bus, PCLd_bus;
    logic [6:0] PCreg, PC_Din_bus;
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
        .RFWriteEnable(RF_W_en),
        .PC_Din(PC_Din_bus),
        .PCLd(PCLd_bus),
        .Flags(Flags)
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
        .Ld(PCLd_bus),
        .Din(PC_Din_bus),
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



module ControlUnit_tb;
    logic clk, rst;
    logic RF_W_en, RF_s;
    logic D_Wr;
    logic [2:0] ALU_s0;
    logic [7:0] D_Addr;
    logic [15:0] IR_Out;
    logic [3:0] NextState, OutState;
    logic [6:0] PC_Out;
    logic [3:0] RF_Ra_addr, RF_Rb_addr, RF_W_addr;

    ControlUnit dut (
        .clk(clk), 
        .rst(rst),
        .ALU_s0(ALU_s0), 
        .D_Addr(D_Addr), 
        .D_Wr(D_Wr),
        .IR_Out(IR_Out), 
        .NextState(NextState), 
        .OutState(OutState),
        .PC_Out(PC_Out), 
        .RF_Ra_addr(RF_Ra_addr), 
        .RF_Rb_addr(RF_Rb_addr),
        .RF_W_addr(RF_W_addr), 
        .RF_W_en(RF_W_en), .RF_s(RF_s)
    );

    initial clk = 0;
    always #10 clk = ~clk;

    initial begin
        rst = 1; @(posedge clk); #1;
        assert(OutState == 4'd0)
            else $error("after reset: expected INIT(0), got %0d", OutState);

        rst = 0;
        for (int i = 0; i < 40; i = i + 1) begin
            @(posedge clk); #1;
            $display("#%0t PC=%0d IR=%h State=%0d Next=%0d RF_W_en=%b D_Wr=%b",
                     $time, PC_Out, IR_Out, OutState, NextState, RF_W_en, D_Wr);
            if (IR_Out == 16'h5000) begin
                $display("ControlUnit_tb: reached HALT");
                break;
            end
        end

        assert(IR_Out == 16'h5000)
            else $error("CU never reached HALT in 40 cycles");

        $display("ControlUnit_tb: passed");
        $stop;
    end
endmodule
