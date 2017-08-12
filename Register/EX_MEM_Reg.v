`timescale 1ns/1ps

module EX_MEM_Reg(
	clk,
	reset,

	RegDst_in, 
	RegWr_in,  
	MemWr_in, 
	MemRd_in, 
	MemToReg_in,

	PC_plus_4_in,
	//ALU result
	ALU_in,
	//sw data
	reg_data2_in,
	//Forwarding Dectecting
	Rt_in,
	Rd_in,

	RegDst_out,
	RegWr_out,
	MemWr_out,
	MemRd_out,
	MemToReg_out,

	PC_plus_4_out,
	ALU_out,
	reg_data2_out,
	Rt_out,
	Rd_out
	);

input clk;
input reset;
input [1:0] RegDst_in;
input RegWr_in;
input MemWr_in;
input MemRd_in; 
input [1:0] MemToReg_in;
input [31:0] PC_plus_4_in;
input [31:0] ALU_in;
input [31:0] reg_data2_in;
input [4:0] Rt_in;
input [4:0] Rd_in;

output reg [1:0] RegDst_out;
output reg RegWr_out;
output reg MemWr_out;
output reg MemRd_out;
output reg [1:0] MemToReg_out;
output reg [31:0] PC_plus_4_out;
output reg [31:0] ALU_out;
output reg [31:0] reg_data2_out;
output reg [4:0] Rt_out;
output reg [4:0] Rd_out;

always @(posedge clk or negedge reset) begin
	if (~reset)
	begin
		RegDst_out <= 2'b00;
		RegWr_out <= 0;
		MemWr_out <= 0;
		MemRd_out <= 0;
		MemToReg_out <= 2'b00;
		PC_plus_4_out <= 32'h00000000;
		ALU_out <= 32'h00000000;
		reg_data2_out <= 32'h00000000;
		Rt_out <= 5'b00000;
		Rd_out <= 5'b00000;
	end
	else
	begin
		RegDst_out <= RegDst_in;
		RegWr_out <= RegWr_in;
		MemWr_out <= MemWr_in;
		MemRd_out <= MemRd_in;
		MemToReg_out <= MemToReg_in;
		PC_plus_4_out <= PC_plus_4_in;
		ALU_out <= ALU_in;
		reg_data2_out <= reg_data2_in;
		Rt_out <= Rt_in;
		Rd_out <= Rd_in;
	end
end

endmodule