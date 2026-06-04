/*
 * Class:        TCES 330 Spring 2026
 * Names:        Riley Hopper & Jaiden Stipp
 * Date:         May 13, 2026
 * Assignment:   Project Phase 2
 */

/**
 * 8x16 register file with synchronous write and dual asynchronous read ports.
 * Designed as a component for the RegALU integration module.
 *
 * @input  clk      Clock signal, writes occur on rising edge.
 * @input  write    Write enable, register is updated only when asserted.
 * @input  wrAddr   3-bit write address, selects one of 8 registers.
 * @input  wrData   16-bit data to write to the selected register.
 * @input  rdAddrA  3-bit read address for port A.
 * @input  rdAddrB  3-bit read address for port B.
 * @output rdDataA  16-bit combinational read output for port A.
 * @output rdDataB  16-bit combinational read output for port B.
 */
module regfile8x16a(
    input clk, // system clock
    input write, // write enable
    input [2:0] wrAddr, // write address
    input [15:0] wrData, // write data
    input [2:0] rdAddrA, // A-side read address
    output [15:0] rdDataA, // A-side read data
    input [2:0] rdAddrB, // B-side read address
    output [15:0] rdDataB 
); // B-sdie read data
    logic [15:0] regfile [0:7]; // 8 registers, each 16-bit


    assign rdDataA = regfile[rdAddrA];
    assign rdDataB = regfile[rdAddrB];

    always_ff @(posedge clk) begin
        if (write) begin
            regfile[wrAddr] <= wrData;
        end
        
    end


endmodule





module regfile8x16a_tb;
    logic clk; // system clock
    logic write; // write enable
    logic [2:0] wrAddr; // write address
    logic [15:0] wrData; // write data
    logic [2:0] rdAddrA; // A-side read address
    logic [15:0] rdDataA; // A-side read data
    logic [2:0] rdAddrB; // B-side read address
    logic [15:0] rdDataB; 


    regfile8x16a File(
        .clk(clk),
        .write(write),
        .wrAddr(wrAddr),
        .wrData(wrData),
        .rdAddrA(rdAddrA),
        .rdAddrB(rdAddrB),
        .rdDataA(rdDataA),
        .rdDataB(rdDataB)
    );


    always begin
        clk = 0; #10;
        clk = 1; #10;
    end



    initial begin

        write = 1;
        $display("Write = 1");
        #20;
        for (int i = 0; i < 8; i = i + 1) begin
            wrAddr = i;
            wrData = $random;
            #20;
        end

        for (int i = 0; i < 8; i = i + 1) begin
            rdAddrA = i;#20;
            $display("RegisterA[%b] = %b", i[2:0], rdDataA);
        end

        write = 0;
        $display("Write = 0");
        #20;
        for (int i = 0; i < 8; i = i + 1) begin
            wrAddr = i;
            wrData = $random;
            #20;
        end

        for (int i = 0; i < 8; i = i + 1) begin
            rdAddrB = i;#20;
            $display("RegisterB[%b] = %b", i[2:0], rdDataB);
        end






        $stop;
    end



endmodule