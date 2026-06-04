/*
 * Class:        TCES 330 Spring 2026
 * Names:        Riley Hopper & Jaiden Stipp
 * Date:         June 3, 2026
 * Assignment:   Project
 */

/**
 * Instruction register. Latches Data on the rising clock edge when Load is
 * asserted, holding the current instruction for the FSM to decode.
 *
 * @input  Clk System clock.
 * @input  Load Load enable: 1 captures Data on the rising edge.
 * @input  Data 16-bit instruction word from instruction memory.
 * @output Instruction 16-bit latched instruction.
 */
module IR (
    input Clk,
    input Load,
    input logic [15:0] Data,
    output logic [15:0] Instruction
);

    
    always_ff @(posedge Clk) begin
        if (Load) begin
            Instruction <= Data;
        end
    end

endmodule


module IR_tb;
    logic Clk;
    logic Load;
    logic [15:0] Data;
    logic [15:0] Instruction;

    IR dut (
        .Clk(Clk),
        .Load(Load),
        .Data(Data),
        .Instruction(Instruction)
    );

    initial Clk = 0;
    always #5 Clk = ~Clk;

    initial begin
        
        Load = 1; Data = 16'hABCD;
        @(posedge Clk); #1;
        assert(Instruction == 16'hABCD)
            else $error("load: expected hABCD, got %h", Instruction);

        Load = 0; Data = 16'h1234;
        @(posedge Clk); #1;
        assert(Instruction == 16'hABCD)
            else $error("hold: expected hABCD, got %h", Instruction);

        Load = 1; Data = 16'h5000;
        @(posedge Clk); #1;
        assert(Instruction == 16'h5000)
            else $error("reload: expected h5000, got %h", Instruction);

        $display("IR_tb: all tests passed");
        $stop;
    end

endmodule