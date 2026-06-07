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
 * @input  clk Clock signal. 
 * @input  D_wr RAM write enable: 1 writes rd_data_a to D_addr.
 * @input  RF_s Write-back mux select: 0 = ALU result, 1 = RAM read data.
 * @input  RF_W_en Register file write enable.
 * @input  RF_W_addr 4-bit register file write address (selects 1 of 16 registers).
 * @input  RF_Ra_addr 4-bit register file read address for ALU operand A.
 * @input  RF_Rb_addr 4-bit register file read address for ALU operand B.
 * @input  Alu_s0 3-bit ALU operation select.
 * @input  D_addr ADDR_WIDTH-bit RAM address for data memory reads/writes.
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
    input  logic [ADDR_WIDTH-1:0] D_addr,
    output logic [DATA_WIDTH-1:0] ALU_A,
    output logic [DATA_WIDTH-1:0] ALU_B,
    output logic [DATA_WIDTH-1:0] ALU_Out,
    output logic [3:0] Flags
);

    logic [DATA_WIDTH-1:0] mux_out;
    logic [DATA_WIDTH-1:0] alu_out;
    logic [DATA_WIDTH-1:0] rd_data_a;
    logic [DATA_WIDTH-1:0] rd_data_b;
    logic [DATA_WIDTH-1:0] ram_data_out;
    

    RAM DataMemory (
        .clock(clk),
        .wren(D_wr),
        .address(D_addr),
        .data(rd_data_a),
        .q(ram_data_out)
    );

    two_to_one_mux #(.WIDTH(DATA_WIDTH)) mux (
        .sel(RF_s),
        .in0(alu_out),
        .in1(ram_data_out),
        .out(mux_out)
    );

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

    ALU #(.BITLEN(DATA_WIDTH)) alu (
        .A(rd_data_a),
        .B(rd_data_b),
        .Sel(Alu_s0),
        .Q(alu_out),
        .Flags(Flags)
    );

    assign ALU_A   = rd_data_a;
    assign ALU_B   = rd_data_b;
    assign ALU_Out = alu_out;

endmodule


module DataPath_tb;
    localparam int DATA_WIDTH = 16;
    localparam int ADDR_WIDTH = 8;

    logic clk;
    logic D_wr;
    logic RF_s;
    logic RF_W_en;
    logic [3:0] RF_W_addr;
    logic [3:0] RF_Ra_addr;
    logic [3:0] RF_Rb_addr;
    logic [2:0] Alu_s0;
    logic [ADDR_WIDTH-1:0] D_addr;

    DataPath #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) dut (
        .clk(clk),
        .D_wr(D_wr),
        .RF_s(RF_s),
        .RF_W_en(RF_W_en),
        .RF_W_addr(RF_W_addr),
        .RF_Ra_addr(RF_Ra_addr),
        .RF_Rb_addr(RF_Rb_addr),
        .Alu_s0(Alu_s0),
        .D_addr(D_addr)
    );

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        D_wr = 0; RF_s = 0; RF_W_en = 0;
        RF_W_addr = 0; RF_Ra_addr = 0; RF_Rb_addr = 0;
        Alu_s0 = 0; D_addr = 0;
        @(posedge clk);

        RF_W_addr = 4'd0; RF_Ra_addr = 4'd0; RF_Rb_addr = 4'd0;
        Alu_s0 = 3'b000; RF_s = 0; RF_W_en = 1; D_wr = 0;
        @(posedge clk); #1;
        assert(dut.regfile.regfile[0] == 16'd0)
            else $error("zero reg[0]: expected 0, got %0d", dut.regfile.regfile[0]);

        RF_W_addr = 4'd0; RF_Ra_addr = 4'd0; RF_Rb_addr = 4'd0;
        Alu_s0 = 3'b111; RF_s = 0; RF_W_en = 1; D_wr = 0;
        @(posedge clk); #1;
        assert(dut.regfile.regfile[0] == 16'd1)
            else $error("inc reg[0]: expected 1, got %0d", dut.regfile.regfile[0]);

        RF_W_addr = 4'd0; RF_Ra_addr = 4'd0; RF_Rb_addr = 4'd0;
        Alu_s0 = 3'b111; RF_s = 0; RF_W_en = 1; D_wr = 0;
        @(posedge clk); #1;
        assert(dut.regfile.regfile[0] == 16'd2)
            else $error("inc reg[0]: expected 2, got %0d", dut.regfile.regfile[0]);

        RF_W_addr = 4'd1; RF_Ra_addr = 4'd0; RF_Rb_addr = 4'd0;
        Alu_s0 = 3'b011; RF_s = 0; RF_W_en = 1; D_wr = 0;
        @(posedge clk); #1;
        assert(dut.regfile.regfile[1] == 16'd2)
            else $error("copy to reg[1]: expected 2, got %0d", dut.regfile.regfile[1]);

        RF_W_addr = 4'd2; RF_Ra_addr = 4'd0; RF_Rb_addr = 4'd1;
        Alu_s0 = 3'b001; RF_s = 0; RF_W_en = 1; D_wr = 0;
        @(posedge clk); #1;
        assert(dut.regfile.regfile[2] == 16'd4)
            else $error("add to reg[2]: expected 4, got %0d", dut.regfile.regfile[2]);

        RF_Ra_addr = 4'd0; D_addr = 8'd10; D_wr = 1; RF_W_en = 0;
        @(posedge clk); #1;
        D_wr = 0;

        assert(dut.DataMemory.mem[10] == 16'd2)
            else $error("RAM write: expected 2, got %0d", dut.DataMemory.mem[10]);

        D_addr = 8'd10; RF_s = 1; RF_W_en = 1; RF_W_addr = 4'd3;
        @(posedge clk); #1;
        assert(dut.regfile.regfile[3] == 16'd2)
            else $error("RAM load to reg[3]: expected 2, got %0d", dut.regfile.regfile[3]);

        $display("DataPath_tb: all tests passed");
        $stop;
    end

endmodule
