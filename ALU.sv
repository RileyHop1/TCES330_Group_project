/*
 * Class:        TCES 330 Spring 2026
 * Names:        Riley Hopper & Jaiden Stipp
 * Date:         June 3, 2026
 * Assignment:   Project Phase 1
 */

/**
 * Combinational ALU. Sel chooses one of 8 operations:
 * 0 zero, 1 A+B, 2 A-B, 3 pass A, 4 XOR, 5 AND, 6 OR, 7 A+1.
 *
 * @param  BITLEN  Bit width of operands and result (default 16).
 *
 * @input  A First operand.
 * @input  B Second operand.
 * @input  Sel 3-bit operation select.
 * @output Q Operation result.
 */
module ALU #(parameter BITLEN=16)(
    input [BITLEN-1:0] A, B,
    input [2:0] Sel,
    output logic [BITLEN-1:0] Q,
    output logic [3:0] Flags
);
    logic Co, V, N, Z;
    
    always_comb begin
        Co = 0;
        case (Sel)

            3'b000: Q = 0;     // Zero
            3'b001: {Co, Q} = {1'b0, A} + {1'b0, B}; // Addition
            3'b010: {Co, Q} = {1'b0, A} - {1'b0, B}; // Subtraction
            3'b011: Q = A;     // Passing A through ALU
            3'b100: Q = A ^ B; // XOR
            3'b101: Q = A & B; // AND
            3'b110: Q = A | B; // OR
            3'b111: Q = A + 1; // Incrementing
            default: Q = {BITLEN{1'bx}};

            
        endcase
        V = Co ^ A[BITLEN-1] ^ B[BITLEN-1] ^ Q[BITLEN-1];
        N = Q[BITLEN-1];
        Z = ~|Q;
    end
    assign Flags = {Co, V, N, Z};
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