/*
 * Class:        TCES 330 Spring 2026
 * Names:        Riley Hopper & Jaiden Stipp
 * Date:         June 3, 2026
 * Assignment:   Project
 */

/**
 * Program counter. Synchronous 7-bit counter: Clr forces 0, else Up
 * increments, holds when both are low. Drives the instruction memory address.
 *
 * @input  Clk System clock.
 * @input  Clr Synchronous clear to 0.
 * @input  Up Increment enable.
 * @output Addr 7-bit program counter / instruction address.
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


module PC_tb;
    logic Clk;
    logic Clr;
    logic Up;
    logic [6:0] Addr;

    PC dut (
        .Clk(Clk),
        .Clr(Clr),
        .Up(Up),
        .Addr(Addr)
    );

    initial Clk = 0;
    always #5 Clk = ~Clk;

    initial begin
        
        Clr = 1; Up = 0;
        @(posedge Clk); #1;
        assert(Addr == 7'd0)
            else $error("clear: expected 0, got %0d", Addr);

        Clr = 0; Up = 1;
        @(posedge Clk); #1;
        assert(Addr == 7'd1)
            else $error("inc: expected 1, got %0d", Addr);

        @(posedge Clk); #1;
        assert(Addr == 7'd2)
            else $error("inc: expected 2, got %0d", Addr);

        Up = 0;
        @(posedge Clk); #1;
        assert(Addr == 7'd2)
            else $error("hold: expected 2, got %0d", Addr);

        Clr = 1; Up = 1;
        @(posedge Clk); #1;
        assert(Addr == 7'd0)
            else $error("clear priority: expected 0, got %0d", Addr);

        $display("PC_tb: all tests passed");
        $stop;
    end

endmodule