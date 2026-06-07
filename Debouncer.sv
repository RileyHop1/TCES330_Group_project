/*
 * Class:        TCES 330 Spring 2026
 * Names:        Riley Hopper & Jaiden Stipp
 * Date:         June 7, 2026
 * Assignment:   Project
 */

/**
 * Synchronizing button debouncer. Brings an asynchronous button input into
 * the Clk domain through a 2-flop synchronizer, then only updates Btn_out
 * once the synchronized signal has held steady for DEBOUNCE_CYCLES
 * consecutive cycles, suppressing the rapid 0/1 chatter of mechanical
 * contact bounce. Btn_out is a clean level (not a one-shot pulse): it makes
 * exactly one transition per press and one per release, so it is safe to use
 * directly as a manual clock or reset source.
 *
 * @param  DEBOUNCE_CYCLES Number of consecutive Clk cycles the input must
 *         stay constant before Btn_out follows it (default 500,000, which is
 *         ~10 ms at the DE2-115's 50 MHz CLOCK_50).
 *
 * @input  Clk    Stable sampling clock (e.g. CLOCK_50). Must NOT be derived
 *                from Btn_in — that is the chicken-and-egg problem this
 *                module exists to avoid.
 * @input  Btn_in Raw, asynchronous button/switch input (e.g. a KEY pin).
 * @output Btn_out Debounced, synchronized, glitch-free level.
 */
module Debouncer #(
    parameter DEBOUNCE_CYCLES = 500_000
)(
    input  logic Clk,
    input  logic Btn_in,
    output logic Btn_out
);
    localparam CounterWidth = $clog2(DEBOUNCE_CYCLES);

    logic sync_0, sync_1;
    logic [CounterWidth-1:0] count;

    always_ff @(posedge Clk) begin
        sync_0 <= Btn_in;
        sync_1 <= sync_0;
    end

    always_ff @(posedge Clk) begin
        if (sync_1 == Btn_out) begin
            count <= '0;
        end else if (count == CounterWidth'(DEBOUNCE_CYCLES - 1)) begin
            Btn_out <= sync_1;
            count   <= '0;
        end else begin
            count <= count + 1'b1;
        end
    end
endmodule
