/*
 * Class:        TCES 330 Spring 2026
 * Names:        Riley Hopper & Jaiden Stipp
 * Date:         June 3, 2026
 * Assignment:   Project Phase 1
 */

/**
 * Combinational ALU. Sel chooses one of 8 operations:
 * 0 zero, 1 A+B, 2 A-B, 3 pass A, 4 XOR, 5 AND, 6 OR, 7 A+1.
 * Also derives a 4-bit flag bus from the result for conditional branches.
 *
 * @param  BITLEN  Bit width of operands and result (default 16).
 *
 * @input  A First operand.
 * @input  B Second operand.
 * @input  Sel 3-bit operation select.
 * @output Q Operation result.
 * @output Flags 4-bit flag bus {Carry, Overflow, Negative, Zero}: Carry is
 *         the carry-out for ADD / borrow-out for SUB (0 for other ops),
 *         Overflow is signed-overflow for ADD/SUB, Negative is Q's sign bit,
 *         and Zero is set when Q == 0.
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
    logic [2:0] Sel;
    logic [3:0] Flags;
    logic [15:0] expected;
    logic [4:0] pass, fail;
    ALU dut(.A(A), .B(B), .Sel(Sel), .Q(Q), .Flags(Flags));

    initial begin
        // Main Tests

        for (int i = 0; i < 20; i = i + 1) begin
            A   = $urandom & 16'hFFFF;
            B   = $urandom & 16'hFFFF;
            Sel = $urandom_range(0,7);
            $display("Sel=%0d | A=0x%04h B=0x%04h | Q=0x%04h Flags={Co=%b,V=%b,N=%b,Z=%b}",
                     Sel, A, B, Q, Flags[3], Flags[2], Flags[1], Flags[0]);
            #10;
        end

        A = 16'hFFFF; B = 16'hFFFF; Sel = 3'b000; #10;
        $display("ZERO | Sel=0 | Q=0x%04h Flags=%04b (expect Q=0x0000, Zero set)", Q, Flags);
        assert(Flags[0] == 1'b1)
            else $error("ZERO: expected Zero flag set, got Flags=%04b", Flags);

        A = 16'hAAAA; B = 16'hAAAA; Sel = 3'b100; #10;
        $display("XOR same | Sel=4 | Q=0x%04h Flags=%04b (expect Q=0x0000, Zero set)", Q, Flags);
        assert(Flags[0] == 1'b1)
            else $error("XOR same: expected Zero flag set, got Flags=%04b", Flags);

        A = 16'hBEEF; B = 16'h1234; Sel = 3'b011; #10;
        $display("PASS A | Sel=3 | Q=0x%04h Flags=%04b (expect Q=0xBEEF, Negative set)", Q, Flags);
        assert(Flags[1] == 1'b1)
            else $error("PASS A: expected Negative flag set, got Flags=%04b", Flags);


        A = 16'hFFFF; B = 16'h0001; Sel = 3'b001; #10;
        $display("ADD wrap | Sel=1 | Q=0x%04h Flags=%04b (expect Q=0x0000, Carry+Zero set)", Q, Flags);
        assert(Flags[3] == 1'b1 && Flags[0] == 1'b1)
            else $error("ADD wrap: expected Carry & Zero set, got Flags=%04b", Flags);

        $stop;
    end
endmodule