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