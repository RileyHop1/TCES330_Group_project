/*
 * Class:        TCES 330 Spring 2026
 * Names:        Riley Hopper & Jaiden Stipp
 * Date:         June 3, 2026
 * Assignment:   Project 
 */         




/**
 * Single-port synchronous-write, asynchronous-read RAM.
 * Writes are registered on the rising clock edge when write enable is asserted.
 * Reads are combinational — data_out reflects the addressed location immediately.
 *
 * @param  DATA_WIDTH   Width of each memory word in bits (default 16).
 * @param  ADDR_WIDTH   Width of the address bus; memory depth = 2^ADDR_WIDTH (default 8 → 256 words).
 *
 * @input  clk       Clock signal; writes occur on the rising edge.
 * @input  we        Write enable: 1 writes data_in to the addressed location.
 * @input  adder     ADDR_WIDTH-bit address selecting the target memory word.
 * @input  data_in   DATA_WIDTH-bit data to write when we is asserted.
 * @output data_out  DATA_WIDTH-bit data read from the addressed location (asynchronous).
 */

module RAM #(
    parameter int DATA_WIDTH = 16,
    parameter int ADDR_WIDTH =8
)(
    input logic clk,
    input logic we,
    input logic  [ADDR_WIDTH-1:0] adder,
    input logic [DATA_WIDTH-1:0] data_in,
    output logic [DATA_WIDTH-1:0] data_out
);

    logic [DATA_WIDTH-1:0] mem [0:(2**ADDR_WIDTH-1)];


    always_ff @(posedge clk) begin
        
        if(we)
            mem[adder] <=data_in;
    end



    assign data_out = mem[adder];









endmodule





module RAM_tb;
    localparam int DATA_WIDTH = 16;
    localparam int ADDR_WIDTH = 8;
 
    logic clk;
    logic we;
    logic [ADDR_WIDTH-1:0] adder;
    logic [DATA_WIDTH-1:0] data_in;
    logic [DATA_WIDTH-1:0] data_out;
 
    RAM #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH)) dut (
        .clk(clk), .we(we), .adder(adder),
        .data_in(data_in), .data_out(data_out)
    );
 

    initial clk = 0;
    always #5 clk = ~clk;

    initial begin

        we = 1; adder = 8'd4; data_in = 16'd12;
        @(posedge clk);


        adder = 8'd10; data_in = 16'd200;
        @(posedge clk);
    

        we = 0; adder = 8'd4; #1; 
        assert(data_out == 16'd12 )
            else $error("Register 4 was not correctly seededwith %d", 16'd12);

        
        we = 0; adder = 8'd10; #1; 
        assert(data_out == 16'd200 )
            else $error("Register 10 was not correctly seeded with %d", 16'd200 );

        we = 0; adder = 8'd4; data_in = 16'hFFFF;
        @(posedge clk);
        adder = 8'd4; #1;
        assert (data_out ==  16'd12)
            else $error("Register 4 was over written when it should not have.");

        adder = 8'd10; data_in = 16'd100;
        @(posedge clk);
        adder = 8'd10; #1;
        assert (data_out ==  16'd200)
            else $error("Register 10 was over written when it should not have.");



        $stop;
    end




endmodule