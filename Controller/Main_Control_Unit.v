`timescale 1ns/1ps

module Main_Control_Unit(
	OpCode, Funct, IRQ,
	PCSrc, 
	RegDst, 
	RegWr, 
	ALUSrc1, 
	ALUSrc2, 
	ALUFun,
	Sign, 
	MemWr, 
	MemRd, 
	MemToReg, 
	ExtOp, 
	LuOp,
	IF_Flush
	);

input [5:0] OpCode;
input [5:0] Funct;
//External interruption, familiar to jal $26 
input IRQ;

output [2:0] PCSrc;
output [1:0] RegDst;
output RegWr;
output ALUSrc1;
output ALUSrc2;
output reg [5:0] ALUFun;
output Sign;
output MemWr;
output MemRd;
output [1:0] MemToReg;
output ExtOp;
output LuOp;

//Undefined instruction
wire Undefined;

//When there is a interruption or exception, we need flush IF/ID reg.
output IF_Flush;


assign Undefined = 
					(OpCode == 6'h00) ? !((Funct >= 6'h20 && Funct <= 6'h27) || Funct == 6'h00 || Funct == 6'h02 || Funct == 6'h03 || Funct == 6'h2a || Funct == 6'h08 || Funct == 6'h09) :
					(OpCode == 6'h23) ? 1'b0 :
					(OpCode == 6'h2b) ? 1'b0 :
					(OpCode == 6'h0f) ? 1'b0 :
					(OpCode >= 6'h01 && OpCode <= 6'h0d && OpCode != 6'h10) ? 1'b0 : 1'b1;

assign PCSrc =  IRQ ? 3'd4 :
				Undefined ? 3'd5 :
				((OpCode >= 6'h04 && OpCode <= 6'h07) || OpCode == 6'h01) ? 3'd1 :
				(OpCode == 6'h02 || OpCode == 6'h03) ? 3'd2 :
				(OpCode == 6'h00 && (Funct == 6'h08 || Funct == 6'h09)) ? 3'd3 : 3'd0;

assign RegDst = 
				(IRQ || Undefined) ? 2'd3 : 
				(OpCode == 6'h00) ? 2'd0:
				(OpCode == 6'h03) ? 2'd2 : 2'd1;

assign RegWr = 
				(IRQ || Undefined) ? 1'b1 :
				(OpCode >= 6'h04 && OpCode <= 6'h07) ? 1'b0 :
				(OpCode == 6'h2b || OpCode == 6'h01 || OpCode == 6'h02) ? 1'b0 : 
				(OpCode == 6'h00 && Funct == 6'h08) ? 1'b0 : 1'b1;

assign ALUSrc1 = (OpCode == 6'h00) ? (Funct <= 6'h03) : 1'b0;

assign ALUSrc2 = (OpCode <= 6'h07) ? 1'b0 : 1'b1;


//Unknown
assign Sign = !(OpCode == 6'h0b || OpCode == 6'h09 || (OpCode == 6'h00 && (Funct == 6'h21 || Funct == 6'h23)));

assign MemWr = 
				(IRQ || Undefined) ? 1'b0 :
				(OpCode == 6'h2b) ? 1'b1 : 1'b0;

assign MemRd = 
				(IRQ || Undefined) ? 1'b0 :
				(OpCode == 6'h23) ? 1'b1 : 1'b0;

assign MemToReg = 
					(IRQ || Undefined || OpCode == 6'h03 || (OpCode == 6'h00 && Funct == 6'h09)) ? 2'd2 :
					(OpCode == 6'h23) ? 2'd1 : 2'd0;

assign ExtOp = !(OpCode == 6'h0d || OpCode == 6'h0c || OpCode == 6'h0b);

assign LuOp = (OpCode == 6'h0f);

//IF/ID Reg Flush
assign IF_Flush = (IRQ || Undefined || OpCode == 6'h02 || OpCode == 6'h03 || (OpCode == 6'h00 && (Funct == 6'h08 || Funct == 6'h09)));

always @(*) 
begin
	case(OpCode)
		6'h00:
		begin
			case(Funct)
				6'h20: ALUFun <= 6'b000000;
				6'h21: ALUFun <= 6'b000000;
				6'h22: ALUFun <= 6'b000001;
				6'h23: ALUFun <= 6'b000001;
				6'h24: ALUFun <= 6'b011000;
				6'h25: ALUFun <= 6'b011110;
				6'h26: ALUFun <= 6'b010110;
				6'h27: ALUFun <= 6'b010001;
				6'h2a: ALUFun <= 6'b110101;
				6'h00: ALUFun <= 6'b100000;
				6'h02: ALUFun <= 6'b100001;
				6'h03: ALUFun <= 6'b100011;
				default: ALUFun <= 6'b000000;
			endcase
		end
		6'h0d: ALUFun <= 6'b011110;
		6'h0f: ALUFun <= 6'b000000;
		6'h23: ALUFun <= 6'b000000;
		6'h2b: ALUFun <= 6'b000000;		
		6'h01: ALUFun <= 6'b111011;
		6'h04: ALUFun <= 6'b110011;
		6'h05: ALUFun <= 6'b110001;
		6'h06: ALUFun <= 6'b111101;
		6'h07: ALUFun <= 6'b111111;
		6'h08: ALUFun <= 6'b000000;
		6'h09: ALUFun <= 6'b000000;
		6'h0a: ALUFun <= 6'b110101;
		6'h0b: ALUFun <= 6'b110101;
		6'h0c: ALUFun <= 6'b011000;
		default: ALUFun <= 6'b000000;
	endcase
end

endmodule