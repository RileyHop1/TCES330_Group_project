/*
 * Class:        TCES 330 Spring 2026
 * Names:        Riley Hopper & Jaiden Stipp
 * Date:         June 3, 2026
 * Assignment:   Project
 */

/**
 * Datapath for the multicycle programmable processor.
 *
 * @param  DATA_WIDTH   Bit width of data buses and ALU (default 16).
 * @param  ADDR_WIDTH   Bit width of the RAM address bus (default 8 → 256 words).
 *
 * @input  clk          Clock signal. 
 * @input  D_wr         RAM write enable: 1 writes rd_data_a to D_addr.
 * @input  RF_s         Write-back mux select: 0 = ALU result, 1 = RAM read data.
 * @input  RF_W_en      Register file write enable.
 * @input  RF_W_addr    4-bit register file write address (selects 1 of 16 registers).
 * @input  RF_Ra_addr   4-bit register file read address for ALU operand A.
 * @input  RF_Rb_addr   4-bit register file read address for ALU operand B.
 * @input  Alu_s0       3-bit ALU operation select.
 * @input  D_addr       ADDR_WIDTH-bit RAM address for data memory reads/writes.
 */
module DataPath #(
    parameter int DATA_WIDTH = 16,
    parameter int ADDR_WIDTH = 8
)(
    input  logic clk,
    input  logic D_wr,
    input  logic RF_s,
    input  logic RF_W_en,
    input  logic [3:0] RF_W_addr,
    input  logic [3:0] RF_Ra_addr,
    input  logic [3:0] RF_Rb_addr,
    input  logic [2:0] Alu_s0,
    input  logic [ADDR_WIDTH-1:0] D_addr
);

    logic [DATA_WIDTH-1:0] mux_out;
    logic [DATA_WIDTH-1:0] alu_out;
    logic [DATA_WIDTH-1:0] rd_data_a;
    logic [DATA_WIDTH-1:0] rd_data_b;
    logic [DATA_WIDTH-1:0] ram_data_out;

    RAM #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) DataMemory (
        .clk(clk),
        .we(D_wr),
        .addr(D_addr),
        .data_in(rd_data_a),
        .data_out(ram_data_out)
    );

    two_to_one_mux #(.WIDTH(DATA_WIDTH)) mux (
        .sel(RF_s),
        .in0(alu_out),
        .in1(ram_data_out),
        .out(mux_out)
    );

    // Register file
    regfile8x16a regfile (
        .clk(clk),
        .write(RF_W_en),
        .wrAddr(RF_W_addr),
        .wrData(mux_out),
        .rdAddrA(RF_Ra_addr),
        .rdAddrB(RF_Rb_addr),
        .rdDataA(rd_data_a),
        .rdDataB(rd_data_b)
    );

    // ALU
    ALU #(.BITLEN(DATA_WIDTH)) alu (
        .A(rd_data_a),
        .B(rd_data_b),
        .Sel(Alu_s0),
        .Q(alu_out)
    );

endmodule
