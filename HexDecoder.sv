/*
 * Class:        TCES 330 Spring 2026
 * Names:        Riley Hopper & Jaiden Stipp
 * Date:         June 3, 2026
 * Assignment:   Project
 */

/**
 * Seven-segment decoder for the DE2-115 HEX displays.

 * @input  in  4-bit value (0x0-0xF) to display.
 * @output out 7-bit segment drive {g,f,e,d,c,b,a}, active low.
 */
module HexDecoder (
    input  logic [3:0] in,
    output logic [6:0] out
);

    always_comb begin
        case (in)
            4'h0: out = 7'b1000000; 
            4'h1: out = 7'b1111001; 
            4'h2: out = 7'b0100100; 
            4'h3: out = 7'b0110000; 
            4'h4: out = 7'b0011001; 
            4'h5: out = 7'b0010010; 
            4'h6: out = 7'b0000010; 
            4'h7: out = 7'b1111000; 
            4'h8: out = 7'b0000000; 
            4'h9: out = 7'b0010000; 
            4'ha: out = 7'b0001000; // A
            4'hb: out = 7'b0000011; // b
            4'hc: out = 7'b1000110; // C
            4'hd: out = 7'b0100001; // d
            4'he: out = 7'b0000110; // E
            4'hf: out = 7'b0001110; // F
            default: out = 7'b1111111; // Blank if undefined
        endcase
    end

endmodule