`timescale 1ns/1ps

module Forwarding(
	ID_EX_Rs,
	ID_EX_Rt,
	ID_EX_Rd,
	ID_EX_RegWr,
	ID_EX_RegDst,

	EX_MEM_Rt,
	EX_MEM_Rd,
	EX_MEM_RegWr,
	EX_MEM_RegDst,

	MEM_WB_Rt,
	MEM_WB_Rd,
	MEM_WB_RegWr,
	MEM_WB_RegDst,

	IF_ID_PCSrc,
	IF_ID_Rs,

	ForwardA,
	ForwardB,
	Forward_Jr
	);

input [4:0] ID_EX_Rs;
input [4:0] ID_EX_Rt;
input [4:0] ID_EX_Rd;
input ID_EX_RegWr;
input [1:0] ID_EX_RegDst;

input [4:0] EX_MEM_Rt;
input [4:0] EX_MEM_Rd;
input EX_MEM_RegWr;
input [1:0] EX_MEM_RegDst;

input [4:0] MEM_WB_Rt;
input [4:0] MEM_WB_Rd;
input MEM_WB_RegWr;
input [1:0] MEM_WB_RegDst;

input [2:0] IF_ID_PCSrc;
input [4:0] IF_ID_Rs;

//Forward == 2'b10:EX Hazard; Forward == 2'b01: MEM Hazard
output reg [1:0] ForwardA;
output reg [1:0] ForwardB;
output reg [1:0] Forward_Jr;

wire [4:0] ID_EX_RegFileWr_addr;
wire [4:0] EX_MEM_RegFileWr_addr;
wire [4:0] MEM_WB_RegFileWr_addr;


assign ID_EX_RegFileWr_addr = 
						(ID_EX_RegDst == 2'b00) ? ID_EX_Rd :
						(ID_EX_RegDst == 2'b01) ? ID_EX_Rt :
						(ID_EX_RegDst == 2'b10) ? 5'd31 : 5'd26;
assign EX_MEM_RegFileWr_addr = 
						(EX_MEM_RegDst == 2'b00) ? EX_MEM_Rd :
						(EX_MEM_RegDst == 2'b01) ? EX_MEM_Rt :
						(EX_MEM_RegDst == 2'b10) ? 5'd31 : 5'd26;
assign MEM_WB_RegFileWr_addr  = 
						(MEM_WB_RegDst == 2'b00) ? MEM_WB_Rd :
						(MEM_WB_RegDst == 2'b01) ? MEM_WB_Rt :
						(MEM_WB_RegDst == 2'b10) ? 5'd31 : 5'd26;

always @(*)
begin
	//ForwardA
	//EX Hazard, and EX stage's results are more "fresh"
	if(EX_MEM_RegWr && EX_MEM_RegFileWr_addr != 5'b00000 && (EX_MEM_RegFileWr_addr == ID_EX_Rs)) 
		ForwardA <= 2'b10;
	//MEM Hazard
	else if(MEM_WB_RegWr && MEM_WB_RegFileWr_addr != 5'b00000 && (MEM_WB_RegFileWr_addr == ID_EX_Rs))
		ForwardA <= 2'b01;
	//No Hazard
	else ForwardA <= 2'b00;


	//ForwardB
	//EX Hazard, and EX stage's results are more "fresh"
	if(EX_MEM_RegWr && EX_MEM_RegFileWr_addr != 5'b00000 && (EX_MEM_RegFileWr_addr == ID_EX_Rt)) 
		ForwardB <= 2'b10;
	//MEM Hazard
	else if(MEM_WB_RegWr && MEM_WB_RegFileWr_addr != 5'b00000 && (MEM_WB_RegFileWr_addr == ID_EX_Rt))
		ForwardB <= 2'b01;
	//No Hazard
	else ForwardB <= 2'b00;


	//JumpRegisiter Forwarding:jr and jalr
	if(IF_ID_PCSrc == 3'b011)
	begin
		//use ALU's result(previous one intrustion)
		if(ID_EX_RegWr && ID_EX_RegFileWr_addr != 5'b00000 && (IF_ID_Rs == ID_EX_RegFileWr_addr))
			Forward_Jr <= 2'b11;
		//use previous two intrustion's result
		else if(EX_MEM_RegWr && EX_MEM_RegFileWr_addr != 5'b00000 && (IF_ID_Rs == EX_MEM_RegFileWr_addr))
			Forward_Jr <= 2'b10;
		//use previous three intrustion's result
		else if(MEM_WB_RegWr && MEM_WB_RegFileWr_addr != 5'b00000 && (IF_ID_Rs == MEM_WB_RegFileWr_addr))
			Forward_Jr <= 2'b01;
		//Not Forwarding
		else Forward_Jr <= 2'b00;
	end
	else Forward_Jr <= 2'b00;
end

endmodule