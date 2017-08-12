`timescale 1ns/1ps

module IF_ID_Reg(
	clk,
	reset,
	//Flush the regisiter, and generate a nop.
	Flush,
	PC_plus_4_in,
	Instrcution,
	RegWr,

	PC_plus_4_out,
	OpCode,
	Funct,
	Rs,
	Rt,
	Rd,
	Shamt,
	//Immediate
	Imme,
	JumpAddr
	);

input clk;
input reset;
input Flush;
input [31:0] PC_plus_4_in;
input [31:0] Instrcution;
input RegWr;

output reg [31:0] PC_plus_4_out;
output [5:0] OpCode;
output [5:0] Funct;
output [4:0] Rs;
output [4:0] Rt;
output [4:0] Rd;
output [4:0] Shamt;
output [15:0] Imme;
output [25:0] JumpAddr;

//For dealing reset, Flush
reg [31:0] Instrc_out;

assign OpCode = Instrc_out[31:26];

assign Funct = Instrc_out[5:0];

assign Rs = Instrc_out[25:21];

assign Rt = Instrc_out[20:16];

assign Rd = Instrc_out[15:11];

assign Shamt = Instrc_out[10:6];

assign Imme = Instrc_out[15:0];

assign JumpAddr = Instrc_out[25:0];

always @(posedge clk or negedge reset) 
begin
	if (~reset)
	begin
		PC_plus_4_out <= 32'h0;
		Instrc_out <= 32'h0;
	end
	else
	begin
		if(Flush)
		begin
			PC_plus_4_out <= PC_plus_4_in;
			Instrc_out <= 32'h0;
		end

		else if(RegWr)
		begin
			PC_plus_4_out <= PC_plus_4_in;
			Instrc_out <= Instrcution;
		end
	end
end


endmodule