

/*
 * Class:        TCES 330 Spring 2026
 * Names:        Riley Hopper & Jaiden Stipp
 * Date:         May 13, 2026
 * Assignment:   Project Phase 2
 */

/**
 * Integrates the 8x16 register file with the 16-bit ALU.
 * A mux on the ALU's A input allows external data to be loaded into the
 * register file when loadSel is asserted, bypassing the register file read.
 * The ALU result fans out to both the register file write port and output Q.
 *
 * @input  clk      Clock signal, register writes occur on rising edge.
 * @input  dataIn   16-bit external data input for loading values into registers.
 * @input  loadSel  Mux select: 1 routes dataIn to ALU A input, 0 routes rdDataA.
 * @input  write    Write enable for the register file.
 * @input  wrAddr   3-bit write address, selects destination register.
 * @input  rdAddrA  3-bit read address for ALU operand A.
 * @input  rdAddrB  3-bit read address for ALU operand B.
 * @input  Sel      3-bit ALU operation select.
 * @output Q        16-bit ALU result output.
 */
module regALU(
    input clk, 
    input [15:0] dataIn,
    input loadSel,
    input write, 
    input [2:0] wrAddr, 
    input [2:0] rdAddrA, 
    input [2:0] rdAddrB, 
    input [2:0] Sel,
    output logic [15:0] Q
);

    logic [15:0] rdDataA; // A-side read data
    logic [15:0] rdDataB; 
    logic [15:0] wrData; // write data 

    logic [15:0] aluA;

    assign aluA = loadSel ? dataIn : rdDataA;

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

    ALU alu(
        .A(aluA), 
        .B(rdDataB), 
        .Sel(Sel), 
        .Q(wrData)
    );


    assign Q = wrData;



endmodule


module regALU_tb;
    logic        clk;
    logic        write;
    logic        loadSel;
    logic [15:0] dataIn;
    logic [2:0]  wrAddr;
    logic [2:0]  rdAddrA;
    logic [2:0]  rdAddrB;
    logic [2:0]  Sel;
    logic [15:0] Q;

    regALU dut(
        .clk(clk),
        .write(write),
        .loadSel(loadSel),
        .dataIn(dataIn),
        .wrAddr(wrAddr),
        .rdAddrA(rdAddrA),
        .rdAddrB(rdAddrB),
        .Sel(Sel),
        .Q(Q)
    );

    always begin
        clk = 0; #10;
        clk = 1; #10;
    end

    initial begin



        $display("Loading data into the reg file:");
        write = 1;
        loadSel = 1;
        Sel = 3'b011;

        for (int i = 0; i < 8; i = i + 1) begin
            dataIn = $random;
            wrAddr = i;
            #20;
        end
        write = 0;
        loadSel = 0;

        for (int i = 0; i < 8; i = i + 1) begin
            rdAddrA = i;
            #20;
            $display("RegisterA[%b] = %b", i[2:0], Q);
        end


        $display("Testing ALU operations:");
        for (int i = 0; i < 8; i = i + 1) begin
            Sel = i[2:0];
            rdAddrA = $random;
            rdAddrB = $random;
            #20;

            $display("Sel=%b | A=reg[%b]=%b  B=reg[%b]=%b => Q=%b",
                Sel, rdAddrA, dut.rdDataA, rdAddrB, dut.rdDataB, Q);

        end





        $stop;
    end

endmodule