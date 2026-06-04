module PC (
    input Clk,
    input Clr,
    input Up,
    output logic [6:0] Addr
);
    initial begin
        Addr = 0;
    end

    always_ff @(posedge Clk) begin
        if (Clr) begin
            Addr <= 0;
        end else if (Up) begin
            Addr <= Addr + 1;
        end
    end
endmodule