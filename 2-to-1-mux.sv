/*
 * Class:        TCES 330 Spring 2026
 * Names:        Riley Hopper & Jaiden Stipp
 * Date:         June 3, 2026
 * Assignment:   Project
 */

/**
 * Parameterized 2-to-1 multiplexer.
 * Routes one of two WIDTH-bit inputs to the output based on the select signal.
 *
 * @param  WIDTH  Bit width of the data inputs and output (default 16).
 *
 * @input  sel    Select signal: 1 routes in1 to out, 0 routes in0 to out.
 * @input  in0    WIDTH-bit input selected when sel = 0.
 * @input  in1    WIDTH-bit input selected when sel = 1.
 * @output out    WIDTH-bit selected output.
 */
module two_to_one_mux #(
    parameter int WIDTH = 16
)(
    input  logic sel,
    input  logic [WIDTH-1:0] in0,
    input  logic [WIDTH-1:0] in1,
    output logic [WIDTH-1:0] out
);

    assign out = sel ? in1 : in0;

endmodule


module two_to_one_mux_tb;
    localparam int WIDTH = 16;

    logic sel;
    logic [WIDTH-1:0] in0, in1;
    logic [WIDTH-1:0] out;

    two_to_one_mux #(.WIDTH(WIDTH)) dut (
        .sel(sel), .in0(in0), .in1(in1), .out(out)
    );

    initial begin
        sel = 0; in0 = 16'hAAAA; in1 = 16'h5555; #10;
        assert(out == 16'hAAAA)
            else $error("sel=0 failed: expected hAAAA, got %h", out);

        sel = 1; #10;
        assert(out == 16'h5555)
            else $error("sel=1 failed: expected h5555, got %h", out);

        sel = 0; in0 = 16'd100; in1 = 16'd200; #10;
        assert(out == 16'd100)
            else $error("sel=0 failed: expected 100, got %0d", out);

        sel = 1; #10;
        assert(out == 16'd200)
            else $error("sel=1 failed: expected 200, got %0d", out);

        $stop;
    end

endmodule
