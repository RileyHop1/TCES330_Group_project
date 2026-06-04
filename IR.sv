/*
 * Class:        TCES 330 Spring 2026
 * Names:        Riley Hopper & Jaiden Stipp
 * Date:         June 3, 2026
 * Assignment:   Project
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