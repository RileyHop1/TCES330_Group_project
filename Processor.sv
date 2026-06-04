/*
 * Class:        TCES 330 Spring 2026
 * Names:        Riley Hopper & Jaiden Stipp
 * Date:         June 3, 2026
 * Assignment:   Project
 */

/**
 * Top-level processor: connects the ControlUnit (fetch/decode/control) to the
 * DataPath (execute). Exposes PC, IR, FSM state, and ALU buses as outputs for
 * the testbench to observe.
 *
 * @input  Clk System clock.
 * @input  ResetN Active-low reset (inverted into the control unit).
 * @output IR_Out Current instruction.
 * @output PC_Ou Program counter value.
 * @output State FSM current state.
 * @output NextState  FSM next state.
 * @output ALU_A ALU operand A.
 * @output ALU_B ALU operand B.
 * @output ALU_Out ALU result.
 */
module Processor (
    input  logic Clk,
    input  logic ResetN,
    output logic [15:0] IR_Out,
    output logic [6:0]  PC_Out,
    output logic [3:0]  State,
    output logic [3:0]  NextState,
    output logic [15:0] ALU_A,
    output logic [15:0] ALU_B,
    output logic [15:0] ALU_Out
);
    logic [2:0] alu_select_bus;
    logic [7:0] d_addr_bus;
    logic d_wr_bus;
    logic [3:0] rf_ra_addr_bus;
    logic [3:0] rf_rb_addr_bus;
    logic [3:0] rf_w_addr_bus;
    logic rf_w_en_bus;
    logic rf_s_bus;

    ControlUnit CU (
        .clk(Clk),
        .rst(~ResetN),
        .ALU_s0(alu_select_bus),
        .D_Addr(d_addr_bus),
        .D_Wr(d_wr_bus),
        .IR_Out(IR_Out),
        .NextState(NextState),
        .OutState(State),
        .PC_Out(PC_Out),
        .RF_Ra_addr(rf_ra_addr_bus),
        .RF_Rb_addr(rf_rb_addr_bus),
        .RF_W_addr(rf_w_addr_bus),
        .RF_W_en(rf_w_en_bus),
        .RF_s(rf_s_bus)
    );

    DataPath DP (
        .clk(Clk),
        .D_wr(d_wr_bus),
        .RF_s(rf_s_bus),
        .RF_W_en(rf_w_en_bus),
        .RF_W_addr(rf_w_addr_bus),
        .RF_Ra_addr(rf_ra_addr_bus),
        .RF_Rb_addr(rf_rb_addr_bus),
        .Alu_s0(alu_select_bus),
        .D_addr(d_addr_bus),
        .ALU_A(ALU_A),
        .ALU_B(ALU_B),
        .ALU_Out(ALU_Out)
    );

endmodule
