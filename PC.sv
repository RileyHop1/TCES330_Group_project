/*
 * Class:        TCES 330 Spring 2026
 * Names:        Riley Hopper & Jaiden Stipp
 * Date:         June 3, 2026
 * Assignment:   Project
 */

module PC (
    input Clk,
    input Clr,
    input Up,
    output logic [6:0] Addr
);

    always_ff @(posedge Clk) begin
        if (Clr) begin
            Addr <= 7'b0000000;
        end else if (Up) begin
            Addr <= Addr + 1;
        end
    end
endmodule