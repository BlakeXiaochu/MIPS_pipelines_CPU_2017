`timescale 1ns/1ps

module Main_Control_Unit_tb();
reg [5:0] OpCode;
reg [5:0] Funct;
reg IRQ;
wire [2:0] PCSrc;
wire [1:0] RegDst;
wire RegWr, ALUSrc1, ALUSrc2;
wire [5:0] ALUFun;
wire Sign, MemWr, MemRd;
wire [1:0] MemToReg;
wire ExtOp, LuOp, IF_Flush;

initial
begin
	OpCode <= 6'h00;
	Funct <= 6'h09;
	IRQ <= 0;
end

Main_Control_Unit controler(
	.OpCode(OpCode),
	.Funct(Funct),
	.IRQ(IRQ),

	.PCSrc(PCSrc),
	.RegDst(RegDst),
	.RegWr(RegWr),
	.ALUSrc1(ALUSrc1),
	.ALUSrc2(ALUSrc2),
	.ALUFun(ALUFun),
	.Sign(Sign),
	.MemWr(MemWr),
	.MemRd(MemRd),
	.MemToReg(MemToReg),
	.ExtOp(ExtOp),
	.LuOp(LuOp),
	.IF_Flush(IF_Flush)
	);

endmodule