/*
TCES 330
Project Phase 1
ALU module and Testbench
Jaiden Stipp & Riley Hopper
*/
module ALU #(parameter BITLEN=16)(
    input [BITLEN-1:0] A, B,
    input [2:0] Sel,
    output logic [BITLEN-1:0] Q
);
    always_comb 
        
        case (Sel)

            3'b000: Q = 0;     // Zero
            3'b001: Q = A + B; // Addition
            3'b010: Q = A - B; // Subtraction
            3'b011: Q = A;     // Passing A through ALU
            3'b100: Q = A ^ B; // XOR
            3'b101: Q = A & B; // AND
            3'b110: Q = A | B; // OR
            3'b111: Q = A + 1; // Incrementing
            default: Q = {BITLEN{1'bx}};
        endcase

endmodule



module ALU_tb;
    logic [15:0] A, B, Q;
    logic [3:0] Sel;
    logic [15:0] expected;
    logic [4:0] pass, fail;
    ALU dut(.A(A), .B(B), .Sel(Sel), .Q(Q));

    initial begin
        // Main Tests

        for (int i = 0; i < 20; i = i + 1) begin
            A   = $urandom & 16'hFFFF;
            B   = $urandom & 16'hFFFF;
            Sel = $urandom_range(0,7);
            $display("Sel=%0d | A=0x%04h B=0x%04h | Q=0x%04h", Sel, A, B, Q);
            #10;
        end

        A = 16'hFFFF; B = 16'hFFFF; Sel = 4'b0000; #10;
        $display("ZERO | Sel=0 | Q=0x%04h (expect 0x0000)", Q);

        A = 16'hAAAA; B = 16'hAAAA; Sel = 4'b0100; #10;
        $display("XOR same | Sel=4 | Q=0x%04h (expect 0x0000)", Q);

        A = 16'hBEEF; B = 16'h1234; Sel = 4'b0011; #10;
        $display("PASS A | Sel=3 | Q=0x%04h (expect 0xBEEF)", Q);


        A = 16'hFFFF; B = 16'h0001; Sel = 4'b0001; #10;
        $display("ADD wrap | Sel=1 | Q=0x%04h (expect 0x0000)", Q);

        $stop;
    end
endmodule