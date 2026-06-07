/*
 * Class:        TCES 330 Spring 2026
 * Names:        Riley Hopper & Jaiden Stipp
 * Date:         June 3, 2026
 * Assignment:   Project
 */

/**
 * Program counter. Synchronous 7-bit counter: Clr forces 0, else Ld loads
 * Din, else Up increments, holds when none are asserted (priority
 * Clr > Ld > Up). Drives the instruction memory address.
 *
 * @input  Clk System clock.
 * @input  Clr Synchronous clear to 0.
 * @input  Up Increment enable.
 * @input  Ld Load enable: loads Din into Addr (JUMP/JNZ/JLT branch targets).
 * @input  Din 7-bit value loaded into Addr when Ld is asserted.
 * @output Addr 7-bit program counter / instruction address.
 */
module PC (
    input Clk,
    input Clr,
    input Up,
    input Ld,
    input [6:0] Din,
    output logic [6:0] Addr
);

    always_ff @(posedge Clk) begin
        if (Clr) begin
            Addr <= 7'b0000000;
        end else if (Ld) begin
            Addr <= Din;
        end else if (Up) begin
            Addr <= Addr + 1;
        end
    end
endmodule


module PC_tb;
    logic Clk;
    logic Clr;
    logic Up;
    logic Ld;
    logic [6:0] Din;
    logic [6:0] Addr;

    PC dut (
        .Clk(Clk),
        .Clr(Clr),
        .Up(Up),
        .Ld(Ld),
        .Din(Din),
        .Addr(Addr)
    );

    initial Clk = 0;
    always #5 Clk = ~Clk;

    initial begin

        Clr = 1; Up = 0; Ld = 0; Din = 7'd0;
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

        Up = 1; Ld = 1; Din = 7'd42;
        @(posedge Clk); #1;
        assert(Addr == 7'd42)
            else $error("load priority over up: expected 42, got %0d", Addr);

        Up = 0; Ld = 0;
        @(posedge Clk); #1;
        assert(Addr == 7'd42)
            else $error("hold after load: expected 42, got %0d", Addr);

        Clr = 1; Up = 1; Ld = 1; Din = 7'd5;
        @(posedge Clk); #1;
        assert(Addr == 7'd0)
            else $error("clear priority over load+up: expected 0, got %0d", Addr);

        $display("PC_tb: all tests passed");
        $stop;
    end

endmodule