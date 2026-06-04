/*
 * Class:        TCES 330 Spring 2026
 * Names:        Riley Hopper & Jaiden Stipp
 * Date:         June 3, 2026
 * Assignment:   Project
 */

/**
 * Controller FSM. Each clock it advances INIT -> FETCH -> DECODE -> an execute
 * state for the decoded opcode (NOOP/STORE/LOAD/ADD/SUB/HALT), driving the
 * datapath plus PC/IR control signals for that step.
 *
 * @input Clk System clock.
 * @input Rst Asynchronous reset to INIT (active high).
 * @input Instruction Current instruction from the IR (opcode + operands).
 * @output ALUSelect 3-bit ALU operation select.
 * @output CurrentStateOut Current FSM state.
 * @output NextStateOut Next FSM state.
 * @output DAddr Data-memory address (LOAD/STORE).
 * @output DWrite Data-memory write enable.
 * @output IRLd Instruction-register load enable.
 * @output PCClr Program-counter clear.
 * @output PCUp Program-counter increment.
 * @output RFAReadAddr Register-file read address A.
 * @output RFBReadAddr Register-file read address B.
 * @output RFSelect Write-back mux select.
 * @output RFWriteAddr Register-file write address.
 * @output RFWriteEnable Register-file write enable.
 */
module ControllerStateMachine (
    input  logic Clk,
    input  logic Rst,
    input  logic [15:0] Instruction,

    output logic RFWriteEnable,
    output logic DWrite,
    output logic IRLd,
    output logic PCClr,
    output logic PCUp,
    output logic RFSelect,
    output logic [2:0] ALUSelect,
    output logic [3:0] CurrentStateOut,
    output logic [7:0] DAddr,
    output logic [3:0] NextStateOut,
    output logic [3:0] RFAReadAddr,
    output logic [3:0] RFBReadAddr,
    output logic [3:0]  RFWriteAddr
);
    typedef enum logic [3:0] {
        INIT = 4'd0,
        FETCH = 4'd1,
        DECODE = 4'd2,
        EXECUTE_ADD = 4'd3,
        EXECUTE_SUB = 4'd4,
        EXECUTE_LOAD_REQ = 4'd5,
        EXECUTE_LOAD_WAIT = 4'd6,
        EXECUTE_STORE = 4'd7,
        EXECUTE_NOOP = 4'd8,
        EXECUTE_HALT = 4'd9
    } states;

    typedef enum logic [3:0] {
        NOOP = 4'b0000,
        STORE = 4'b0001,
        LOAD = 4'b0010,
        ADD = 4'b0011,
        SUBTRACT = 4'b0100,
        HALT = 4'b0101
    } opcodes;

    states CurrentState, NextState;

    assign CurrentStateOut = CurrentState;
    assign NextStateOut = NextState;

    always_ff @(posedge Clk or posedge Rst) begin
        if (Rst)
            CurrentState <= INIT;
        else
            CurrentState <= NextState;
    end

    always_comb begin
        NextState = CurrentState;
        ALUSelect = 3'b000;
        DAddr = 8'b0;
        DWrite = 1'b0;
        IRLd = 1'b0;
        PCClr = 1'b0;
        PCUp = 1'b0;
        RFAReadAddr = 4'b0;
        RFBReadAddr = 4'b0;
        RFSelect = 1'b0;
        RFWriteAddr = 4'b0;
        RFWriteEnable = 1'b0;

        case (CurrentState)
            INIT: begin
                PCClr = 1'b1;
                NextState = FETCH;
            end
            FETCH: begin
                PCUp = 1'b1;
                IRLd = 1'b1;
                NextState = DECODE;
            end
            DECODE: begin
                case (Instruction[15:12])
                    NOOP: NextState = EXECUTE_NOOP;
                    STORE: NextState = EXECUTE_STORE;
                    LOAD: NextState = EXECUTE_LOAD_REQ;
                    ADD: NextState = EXECUTE_ADD;
                    SUBTRACT: NextState = EXECUTE_SUB;
                    HALT:     NextState = EXECUTE_HALT;
                    default:  NextState = FETCH;
                endcase
            end
            EXECUTE_NOOP: begin
                NextState = FETCH;
            end
            EXECUTE_STORE: begin
                DAddr = Instruction[7:0];
                DWrite = 1'b1;
                RFAReadAddr = Instruction[11:8];
                NextState = FETCH;
            end
            EXECUTE_LOAD_REQ: begin
                DAddr = Instruction[11:4];
                NextState = EXECUTE_LOAD_WAIT;
            end
            EXECUTE_LOAD_WAIT: begin
                RFSelect = 1'b1;
                RFWriteEnable = 1'b1;
                RFWriteAddr = Instruction[3:0];
                NextState = FETCH;
            end
            EXECUTE_ADD: begin
                RFWriteAddr = Instruction[3:0];
                RFWriteEnable = 1'b1;
                RFSelect = 1'b0;
                RFAReadAddr = Instruction[11:8];
                RFBReadAddr = Instruction[7:4];
                ALUSelect = 3'b001;
                NextState = FETCH;
            end
            EXECUTE_SUB: begin
                RFWriteAddr = Instruction[3:0];
                RFWriteEnable = 1'b1;
                RFSelect = 1'b0;
                RFAReadAddr = Instruction[11:8];
                RFBReadAddr = Instruction[7:4];
                ALUSelect = 3'b010;
                NextState = FETCH;
            end
            EXECUTE_HALT: begin
                NextState = EXECUTE_HALT;
            end
            default: begin
                NextState = INIT;
            end
        endcase
    end

endmodule
