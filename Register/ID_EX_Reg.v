`timescale 1ns/1ps

module ID_EX_Reg(
	clk,
	reset,
	//Main Control Unit signals
	Flush,
	PCSrc_in, 
	RegDst_in, 
	RegWr_in, 
	ALUSrc1_in, 
	ALUSrc2_in, 
	ALUFun_in,
	Sign_in,
	MemWr_in, 
	MemRd_in, 
	MemToReg_in,
	LuOp_in,
	//ID/IF Ref signals
	PC_plus_4_in,
	Rs_in,
	Rt_in,
	Rd_in,
	Shamt_in,
	Ext_Imme_in,
	Lu_Imme_in,
	reg_data1_in,
	reg_data2_in,

	PCSrc_out,
	RegDst_out,
	RegWr_out,
	ALUSrc1_out,
	ALUSrc2_out,
	ALUFun_out,
	Sign_out,
	MemWr_out,
	MemRd_out,
	MemToReg_out,
	LuOp_out,

	PC_plus_4_out,
	Rs_out,
	Rt_out,
	Rd_out,
	Shamt_out,
	Ext_Imme_out,
	Lu_Imme_out,
	reg_data1_out,
	reg_data2_out
	);

input clk;
input reset;
//Main Control Unit signals
input Flush;
input [2:0] PCSrc_in;
input [1:0] RegDst_in;
input RegWr_in;
input ALUSrc1_in;
input ALUSrc2_in;
input [5:0] ALUFun_in;
input Sign_in;
input MemWr_in; 
input MemRd_in; 
input [1:0] MemToReg_in;
input LuOp_in;
//ID/IF Ref signals
input [31:0] PC_plus_4_in;
input [4:0] Rs_in;
input [4:0] Rt_in;
input [4:0] Rd_in;
input [4:0] Shamt_in;
input [31:0] Ext_Imme_in;
input [31:0] Lu_Imme_in;
input [31:0] reg_data1_in;
input [31:0] reg_data2_in;

output reg [2:0] PCSrc_out;
output reg [1:0] RegDst_out;
output reg RegWr_out;
output reg ALUSrc1_out;
output reg ALUSrc2_out;
output reg [5:0] ALUFun_out;
output reg Sign_out;
output reg MemWr_out;
output reg MemRd_out;
output reg [1:0] MemToReg_out;
output reg LuOp_out;

output reg [31:0] PC_plus_4_out;
output reg [4:0] Rs_out;
output reg [4:0] Rt_out;
output reg [4:0] Rd_out;
output reg [4:0] Shamt_out;
output reg [31:0] Ext_Imme_out;
output reg [31:0] Lu_Imme_out;
output reg [31:0] reg_data1_out;
output reg [31:0] reg_data2_out;

always @(posedge clk or negedge reset)
begin
	if (~reset)
	begin
		PCSrc_out <= 3'd0;
		RegDst_out <= 2'd0;
		RegWr_out <= 0;
		ALUSrc1_out <= 0;
		ALUSrc2_out <= 0;
		ALUFun_out <= 6'b000000;
		Sign_out <= 0;
		MemWr_out <= 0;
		MemRd_out <= 0;
		MemToReg_out <= 2'b00;
		LuOp_out <= 0;

		PC_plus_4_out <= 32'h00000000;
		Rs_out <= 5'b00000;
		Rt_out <= 5'b00000;
		Rd_out <= 5'b00000;
		Shamt_out <= 5'b00000;
		Ext_Imme_out <= 32'h00000000;
		Lu_Imme_out <= 32'h00000000;
		reg_data1_out <= 32'h00000000;
		reg_data2_out <= 32'h00000000;
	end
	else
	begin
		if(Flush)
		begin
			PCSrc_out <= 3'd0;
			RegDst_out <= 2'd0;
			RegWr_out <= 0;
			ALUSrc1_out <= 0;
			ALUSrc2_out <= 0;
			ALUFun_out <= 6'b000000;
			Sign_out <= 0;
			MemWr_out <= 0;
			MemRd_out <= 0;
			MemToReg_out <= 2'b00;
			LuOp_out <= 0;

			//When interruption or exception, save current PC+4
			PC_plus_4_out <= PC_plus_4_in;
			Rs_out <= 5'b00000;
			Rt_out <= 5'b00000;
			Rd_out <= 5'b00000;
			Shamt_out <= 5'b00000;
			Ext_Imme_out <= 32'h00000000;
			Lu_Imme_out <= 32'h00000000;
			reg_data1_out <= 32'h00000000;
			reg_data2_out <= 32'h00000000;
		end

		else begin
			PCSrc_out <= PCSrc_in;
			RegDst_out <= RegDst_in;
			RegWr_out <= RegWr_in;
			ALUSrc1_out <= ALUSrc1_in;
			ALUSrc2_out <= ALUSrc2_in;
			ALUFun_out <= ALUFun_in;
			Sign_out <= Sign_in;
			MemWr_out <= MemWr_in;
			MemRd_out <= MemRd_in;
			MemToReg_out <= MemToReg_in;
			LuOp_out <= LuOp_in;

			PC_plus_4_out <= PC_plus_4_in;
			Rs_out <= Rs_in;
			Rt_out <= Rt_in;
			Rd_out <= Rd_in;
			Shamt_out <= Shamt_in;
			Ext_Imme_out <= Ext_Imme_in;
			Lu_Imme_out <= Lu_Imme_in;
			reg_data1_out <= reg_data1_in;
			reg_data2_out <= reg_data2_in;
		end
	end
end

endmodule