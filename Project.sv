module Project(
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
	
	logic sys_reset;
   assign sys_reset = KEY[1];
	
	Processor CPU (
		.Clk(KEY[2]),
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