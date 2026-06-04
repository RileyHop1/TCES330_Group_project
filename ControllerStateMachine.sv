module ControllerStateMachine (
    input Clk,
    input Rst,
    input [15:0] Instruction,

    output [2:0] ALUSelect,
    output [3:0] CurrentStateOut
    output [7:0] DAddr,
    output DWrite,
    output IRLd,
    output [3:0] NextStateOut,
    output PCClr,
    output PCUp,
    output [3:0] RFAReadAddr,
    output [3:0] RFBReadAddr,
    output RFSelect,
    output [3:0] RFWriteAddr,
    output RFWriteEnable
);
    typedef enum logic [3:0] {
        INIT = 4'd0,
        FETCH = 4'd1,
        DECODE = 4'd2,
        EXECUTE_ADD = 4'd3,
        EXECUTE_SUB = 4'd4,
        EXECUTE_LOAD_REQ  = 4'd5,
        EXECUTE_LOAD_WAIT = 4'd6,
        EXECUTE_STORE = 4'd7,
        EXECUTE_NOOP = 4'd8,
        EXECUTE_HALT = 4'd9
    } states;

    typedef enum logic [3:0] {
        NOOP = 4'b0000;
        STORE = 4'b0001;
        LOAD = 4'b0010;
        ADD = 4'b0011;
        SUBTRACT = 4'b0100;
        HALT = 4'b0101;
    } opcodes;

    states CurrentState, NextState;

    assign CurrentStateOut = CurrentState;
    assign NextStateOut = NextState;

    always_ff @(posedge Clk or posedge Rst) begin
        if (Rst) begin
            CurrentState <= INIT;
        end else begin 
            CurrentState <= NextState;
        end
    end

    always_comb begin
        NextState = CurrentState;
        ALUSelect = 0;
        DAddr = 0;
        DWrite = 0;
        IRLd = 0;
        PCClr = 0;
        PcUp = 0;
        RFAReadAddr = 0;
        RFBReadAddr = 0;
        RFSelect = 0;
        RFWriteAddr = 0;
        RFWriteEnable = 0;

        case (CurrentState)
            INIT: begin
                PCClr = 1;
                NextState = FETCH;
            end
            FETCH: begin
                PCUp = 1;
                IRLd = 1;
            end
            DECODE: begin
                case (Instruction[15:12])
                    NOOP: begin
                        NextState = EXECUTE_NOOP;
                    end
                    STORE: begin
                        NextState = EXECUTE_STORE;
                    end
                    LOAD: begin
                        NextState = EXECUTE_LOAD_REQ;
                    end
                    ADD: begin
                        NextState = EXECUTE_ADD;
                    end
                    SUBTRACT: begin
                        NextState = EXECUTE_SUB;
                    end
                    HALT: begin
                        NextState = EXECUTE_HALT;
                    end
                endcase
            end
            EXECUTE_NOOP: begin
                NextState = FETCH;
            end
            EXECUTE_STORE: begin
                DAddr = Instruction[7:0];
                DWrite = 1;
                RFAReadAddr = Instruction[11:8];

                NextState = FETCH;
            end
            EXECUTE_LOAD_REQ: begin
                DAddr = Instruction[11:4]; // First Load Collects the data address, then it writes it to the Register File in the second Load

                NextState = EXECUTE_LOAD_WAIT;
            end
            EXECUTE_LOAD_WAIT: begin
                RFSelect = 1;
                RFWriteEnable = 1;
                RFWriteAddr = Instruction[3:0];
                
                NextState = FETCH;
            end
            EXECUTE_ADD: begin
                RFWriteAddr = Instruction[3:0];
                RFWriteEnable = 1;
                RFSelect = 0;
                RFAReadAddr = Instruction[11:8];
                RFBReadAddr = Instruction[7:4];
                ALUSelect = 3'b001;

                NextState = FETCH;
            end
            EXECUTE_SUB: begin
                RFWriteAddr = Instruction[3:0];
                RFWriteEnable = 1;
                RFSelect = 0;
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