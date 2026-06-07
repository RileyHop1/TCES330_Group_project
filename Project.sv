/*
 * Class:        TCES 330 Spring 2026
 * Names:        Riley Hopper & Jaiden Stipp
 * Date:         June 3, 2026
 * Assignment:   Project
 */

/*
 * Top-level board wrapper for the DE2-115. Instantiates the Processor and
 * routes its observable signals to the HEX displays. KEY[2] is the manual
 * clock, KEY[1] is reset, SW[17:15] selects which internal value is shown
 * on HEX7-HEX4 while HEX3-HEX0 always show the current instruction word.
 * Both KEY inputs are run through Debouncers before use, since raw input
 * otherwise register as multiple clock edges / reset glitches per press.
 *
 * @input  clk Main clock derived from the FPGA clk for the debouncer
 * @input  KEY  KEY[2] = manual clock, KEY[1] = active-low reset (both debounced).
 * @input  SW   SW[17:15] selects the value driven onto HEX7-HEX4.
 * @output HEX0-HEX7 Seven-segment display segment drives.
 */
module Project(
	input clk,
	input [2:1] KEY,
	input [17:15] SW,
	output logic [6:0] HEX7, HEX6, HEX5, HEX4, HEX3, HEX2, HEX1, HEX0
);
	logic [15:0] IROut;
   logic [3:0] NextState;
   logic [3:0] CurrentState;
   logic [15:0] ALUA;
   logic [15:0] ALUB;
   logic [15:0] ALUOut;
   logic [6:0] PCOut;

	logic key1_debounced, key2_debounced;

	Debouncer db_reset (.Clk(clk), .Btn_in(KEY[1]), .Btn_out(key1_debounced));
	Debouncer db_clock (.Clk(clk), .Btn_in(KEY[2]), .Btn_out(key2_debounced));

	logic sys_reset;
    assign sys_reset = key1_debounced;

	Processor CPU (
		.Clk(key2_debounced),
		.ResetN(sys_reset),
		.IR_Out(IROut),
		.NextState(NextState),
		.State(CurrentState),
		.ALU_A(ALUA),
		.ALU_B(ALUB),
		.ALU_Out(ALUOut),
		.PC_Out(PCOut)
	);
	
	logic [15:0] top_display_data;
	
	always_comb begin
		case (SW[17:15])
			3'b000: top_display_data = {1'b0, PCOut, 4'h0, CurrentState};
			3'b001: top_display_data = ALUA;
			3'b010: top_display_data = ALUB;
			3'b011: top_display_data = ALUOut;
			3'b100: top_display_data = {12'h000, NextState};
			default: top_display_data = 16'h0000;
		endcase
	end
	HexDecoder h0 (.in(IROut[3:0]), .out(HEX0));
    HexDecoder h1 (.in(IROut[7:4]), .out(HEX1));
    HexDecoder h2 (.in(IROut[11:8]), .out(HEX2));
    HexDecoder h3 (.in(IROut[15:12]), .out(HEX3));
	
	HexDecoder h4 (.in(top_display_data[3:0]), .out(HEX4));
    HexDecoder h5 (.in(top_display_data[7:4]), .out(HEX5));
    HexDecoder h6 (.in(top_display_data[11:8]), .out(HEX6));
    HexDecoder h7 (.in(top_display_data[15:12]), .out(HEX7));
endmodule