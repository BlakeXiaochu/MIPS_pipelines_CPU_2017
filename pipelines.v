`timescale 1ns/1ps

module Pipeline_CPU(
	clk,
	reset,
	interrupt,
	//DataMem is a peripheral
	Mem_Addr,
	MemWr,
	MemWr_data,
	MemRd,
	MemRd_data
	);
	
input clk;
input reset;
//external interruption
input interrupt;

output [31:0] Mem_Addr;
output MemWr;
output [31:0] MemWr_data;
output MemRd;
input [31:0] MemRd_data; 

//----------------------------IF Stage----------------------------------
reg [31:0] PC_in;
wire [31:0] PC_out;
wire [31:0] PC_plus_4;
wire PC_RegWr;

//PC multiplexer
wire [2:0] PCSrc;
wire ALUOut0;
wire [31:0] ConBA_out;
wire [31:0] ConBA;
wire [31:0] JT;
wire [31:0] Databus_A;
wire [31:0] ILLOP;
wire [31:0] XADR;

wire [31:0] Instrcution;

//IF/ID Reg
wire IF_Flush;
wire IF_ID_RegWr;
wire [31:0] IF_ID_PC_out;
wire [5:0] IF_ID_OpCode;
wire [5:0] IF_ID_Funct;
wire [4:0] IF_ID_Rs;
wire [4:0] IF_ID_Rt;
wire [4:0] IF_ID_Rd;
wire [4:0] IF_ID_Shamt;
wire [15:0] IF_ID_Imme;
wire [25:0] IF_ID_JumpAddr;

//----------------------------ID Stage----------------------------------
wire [1:0] RegDst;
reg [4:0] RegWr_Addr;
wire [31:0] RegFileWr_data;
//Databus_A defined in IF Stage
wire [31:0] Databus_B;
wire RegFileWr;

wire [31:0] Ext_Imme;
wire [31:0] Lu_Imme;

wire IRQ;
reg IF_Flush_flag;

wire [2:0] con_PCSrc;
wire [1:0] con_RegDst;
wire con_RegWr;
wire con_ALUSrc1;
wire con_ALUSrc2;
wire [5:0] con_ALUFun;
wire con_Sign;
wire con_MemWr;
wire con_MemRd;
wire [1:0] con_MemToReg;
wire con_ExtOp;
wire con_LuOp;
wire con_IF_Flush;

//ID/EX Reg
wire ID_Flush;
wire [2:0] ID_EX_PCSrc;
wire [1:0] ID_EX_RegDst;
wire ID_EX_RegWr;
wire ID_EX_ALUSrc1;
wire ID_EX_ALUSrc2;
wire [5:0] ID_EX_ALUFun;
wire ID_EX_Sign;
wire ID_EX_MemWr;
wire ID_EX_MemRd;
wire [1:0] ID_EX_MemToReg;
wire ID_EX_LuOp;
wire [31:0] ID_EX_PC_out;
wire [4:0] ID_EX_Rs;
wire [4:0] ID_EX_Rt;
wire [4:0] ID_EX_Rd;
wire [4:0] ID_EX_Shamt;
wire [31:0] ID_EX_Ext_Imme;
wire [31:0] ID_EX_Lu_Imme;
wire [31:0] ID_EX_reg_data1;
wire [31:0] ID_EX_reg_data2;

wire stall;


//----------------------------EX Stage----------------------------------
wire [31:0] ALU_in1;
wire [31:0] ALU_in2;
wire [31:0] ALU_out;

wire [1:0] ForwardA;
wire [1:0] ForwardB;
wire [1:0] Forward_Jr;
wire [31:0] ForwardA_data;
wire [31:0] ForwardB_data;
wire [31:0] Forward_Jr_data;

//EX/MEM Reg
wire [1:0] EX_MEM_RegDst;
wire EX_MEM_RegWr;
wire EX_MEM_MemWr;
wire EX_MEM_MemRd;
wire [1:0] EX_MEM_MemToReg;
wire [31:0] EX_MEM_PC_out;
wire [31:0] EX_MEM_ALU_out;
wire [31:0] EX_MEM_reg_data2;
wire [4:0] EX_MEM_Rt;
wire [4:0] EX_MEM_Rd;

//----------------------------MEM Stage----------------------------------
wire [1:0] MEM_WB_RegDst;
wire MEM_WB_RegWr;
wire [1:0] MEM_WB_MemToReg;

wire [31:0] MEM_WB_PC_out;
wire [31:0] MEM_WB_ALU_out;
wire [31:0] MEM_WB_MemRd_data;
wire [4:0] MEM_WB_Rt;
wire [4:0] MEM_WB_Rd;


//----------------------------WB Stage----------------------------------




//----------------------------IF Stage----------------------------------
PC_Reg PC(.clk(clk), .reset(reset), .RegWr(PC_RegWr), .Addr_in(PC_in), .Addr_out(PC_out));

ROM instruc_mem(.addr(PC_out), .data(Instrcution));

IF_ID_Reg IF_ID_reg(
	.clk(clk),
	.reset(reset),
	.Flush(IF_Flush),
	.PC_plus_4_in(PC_plus_4),
	.Instrcution(Instrcution),
	.RegWr(IF_ID_RegWr),

	.PC_plus_4_out(IF_ID_PC_out),
	.OpCode(IF_ID_OpCode),
	.Funct(IF_ID_Funct),
	.Rs(IF_ID_Rs),
	.Rt(IF_ID_Rt),
	.Rd(IF_ID_Rd),
	.Shamt(IF_ID_Shamt),
	.Imme(IF_ID_Imme),
	.JumpAddr(IF_ID_JumpAddr)
	);


//----------------------------ID Stage----------------------------------
RegFile regfile(
	.reset(reset),
	.clk(clk),
	//Read Reg
	.addr1(IF_ID_Rs),
	.addr2(IF_ID_Rt),
	.data1(Databus_A),
	.data2(Databus_B),
	//Write Reg
	.wr(RegFileWr),
	.addr3(RegWr_Addr),
	.data3(RegFileWr_data)
	);

Main_Control_Unit main_controler(
	.OpCode(IF_ID_OpCode),
	.Funct(IF_ID_Funct),
	.IRQ(IRQ),

	.PCSrc(con_PCSrc),
	.RegDst(con_RegDst),
	.RegWr(con_RegWr),
	.ALUSrc1(con_ALUSrc1),
	.ALUSrc2(con_ALUSrc2),
	.ALUFun(con_ALUFun),
	.Sign(con_Sign),
	.MemWr(con_MemWr),
	.MemRd(con_MemRd),
	.MemToReg(con_MemToReg),
	.ExtOp(con_ExtOp),
	.LuOp(con_LuOp),
	.IF_Flush(con_IF_Flush)
	);

ID_EX_Reg ID_EX_reg(
	.clk(clk),
	.reset(reset),
	//???
	.Flush(ID_Flush),
	.PCSrc_in(con_PCSrc),
	.RegDst_in(con_RegDst),
	.RegWr_in(con_RegWr),
	.ALUSrc1_in(con_ALUSrc1),
	.ALUSrc2_in(con_ALUSrc2),
	.ALUFun_in(con_ALUFun),
	.Sign_in(con_Sign),
	.MemWr_in(con_MemWr),
	.MemRd_in(con_MemRd),
	.MemToReg_in(con_MemToReg),
	.LuOp_in(con_LuOp),
	
	.PC_plus_4_in(IF_ID_PC_out),
	.Rs_in(IF_ID_Rs),
	.Rt_in(IF_ID_Rt),
	.Rd_in(IF_ID_Rd),
	.Shamt_in(IF_ID_Shamt),
	.Ext_Imme_in(Ext_Imme),
	.Lu_Imme_in(Lu_Imme),
	.reg_data1_in(Databus_A),
	.reg_data2_in(Databus_B),

	.PCSrc_out(ID_EX_PCSrc),
	.RegDst_out(ID_EX_RegDst),
	.RegWr_out(ID_EX_RegWr),
	.ALUSrc1_out(ID_EX_ALUSrc1),
	.ALUSrc2_out(ID_EX_ALUSrc2),
	.ALUFun_out(ID_EX_ALUFun),
	.Sign_out(ID_EX_Sign),
	.MemWr_out(ID_EX_MemWr),
	.MemRd_out(ID_EX_MemRd),
	.MemToReg_out(ID_EX_MemToReg),
	.LuOp_out(ID_EX_LuOp),
	.PC_plus_4_out(ID_EX_PC_out),
	.Rs_out(ID_EX_Rs),
	.Rt_out(ID_EX_Rt),
	.Rd_out(ID_EX_Rd),
	.Shamt_out(ID_EX_Shamt),
	.Ext_Imme_out(ID_EX_Ext_Imme),
	.Lu_Imme_out(ID_EX_Lu_Imme),
	.reg_data1_out(ID_EX_reg_data1),
	.reg_data2_out(ID_EX_reg_data2)
	);


Hazard hazard_unit(
	.ID_EX_MemRd(ID_EX_MemRd),
	.ID_EX_Rt(ID_EX_Rt),
	.IF_ID_Rs(IF_ID_Rs),
	.IF_ID_Rt(IF_ID_Rt),
	.stall(stall)
	);




//----------------------------EX Stage----------------------------------
ALU ALU(.A(ALU_in1), .B(ALU_in2), .ALUFun(ID_EX_ALUFun), .Sign(ID_EX_Sign), .S(ALU_out));

Forwarding forward_unit(
	.ID_EX_Rs(ID_EX_Rs),
	.ID_EX_Rt(ID_EX_Rt),
	.ID_EX_Rd(ID_EX_Rd),
	.ID_EX_RegWr(ID_EX_RegWr),
	.ID_EX_RegDst(ID_EX_RegDst),

	.EX_MEM_Rt(EX_MEM_Rt),
	.EX_MEM_Rd(EX_MEM_Rd),
	.EX_MEM_RegWr(EX_MEM_RegWr),
	.EX_MEM_RegDst(EX_MEM_RegDst),

	.MEM_WB_Rt(MEM_WB_Rt),
	.MEM_WB_Rd(MEM_WB_Rd),
	.MEM_WB_RegWr(MEM_WB_RegWr),
	.MEM_WB_RegDst(MEM_WB_RegDst),

	.IF_ID_PCSrc(con_PCSrc),
	.IF_ID_Rs(IF_ID_Rs),

	.ForwardA(ForwardA),
	.ForwardB(ForwardB),
	.Forward_Jr(Forward_Jr)
	);

EX_MEM_Reg EX_MEM_reg(
	.clk(clk),
	.reset(reset),
	.RegDst_in(ID_EX_RegDst),
	.RegWr_in(ID_EX_RegWr),
	.MemWr_in(ID_EX_MemWr),
	.MemRd_in(ID_EX_MemRd),
	.MemToReg_in(ID_EX_MemToReg),

	.PC_plus_4_in(ID_EX_PC_out),
	//ALU's result
	.ALU_in(ALU_out),
	.reg_data2_in(ForwardB_data),
	.Rt_in(ID_EX_Rt),
	.Rd_in(ID_EX_Rd),

	.RegDst_out(EX_MEM_RegDst),
	.RegWr_out(EX_MEM_RegWr),
	.MemWr_out(EX_MEM_MemWr),
	.MemRd_out(EX_MEM_MemRd),
	.MemToReg_out(EX_MEM_MemToReg),
	.PC_plus_4_out(EX_MEM_PC_out),
	.ALU_out(EX_MEM_ALU_out),
	.reg_data2_out(EX_MEM_reg_data2),
	.Rt_out(EX_MEM_Rt),
	.Rd_out(EX_MEM_Rd)
	);


//----------------------------MEM Stage----------------------------------
MEM_WB_Reg MEM_WB_reg(
	.clk(clk),
	.reset(reset),
	.RegDst_in(EX_MEM_RegDst),
	.RegWr_in(EX_MEM_RegWr),
	.MemToReg_in(EX_MEM_MemToReg),

	.PC_plus_4_in(EX_MEM_PC_out),
	.ALU_in(EX_MEM_ALU_out),
	.mem_data_in(MemRd_data),
	.Rt_in(EX_MEM_Rt),
	.Rd_in(EX_MEM_Rd),

	.RegDst_out(MEM_WB_RegDst),
	.RegWr_out(MEM_WB_RegWr),
	.MemToReg_out(MEM_WB_MemToReg),

	.PC_plus_4_out(MEM_WB_PC_out),
	.ALU_out(MEM_WB_ALU_out),
	.mem_data_out(MEM_WB_MemRd_data),
	.Rt_out(MEM_WB_Rt),
	.Rd_out(MEM_WB_Rd)
	);

//----------------------------WB Stage----------------------------------
//None


//----------------------------IF Stage----------------------------------
assign PC_plus_4 = PC_out + 4;
assign ILLOP = 32'h80000004;
assign XADR = 32'h80000008;

assign ConBA_out = (ID_EX_PCSrc == 3'b001) ? (ALUOut0 ? ConBA : PC_plus_4) : PC_plus_4;

always @(*)
begin
	case(PCSrc)
	3'b000: PC_in <= PC_plus_4;
	3'b001: PC_in <= ConBA_out;
	3'b010: PC_in <= JT;
	3'b011:	PC_in <= Forward_Jr_data;
	3'b100: PC_in <= ILLOP;
	3'b101: PC_in <= XADR;
	default: PC_in <= XADR;
	endcase
end

//load-use(stall)
assign PC_RegWr = ~(stall && ~IRQ);
//PC priority: IRQ > branch > control PC
assign PCSrc = (ID_EX_PCSrc == 3'b001) ? 3'b001 : con_PCSrc;
assign ALUOut0 = ALU_out[0];

always @(posedge clk)
begin
	IF_Flush_flag <= IF_Flush;
end

//Exception, interruption, Branch, Jump
assign IF_Flush = (con_IF_Flush || (ID_EX_PCSrc == 3'b001 && ALUOut0));
//load-use(stall)
assign IF_ID_RegWr = ~(stall && ~IRQ);

//----------------------------ID Stage----------------------------------
always @(*)
begin
	case(RegDst)
	2'b00: RegWr_Addr <= MEM_WB_Rd;
	2'b01: RegWr_Addr <= MEM_WB_Rt;
	2'b10: RegWr_Addr <= 5'd31;
	2'b11: RegWr_Addr <= 5'd26;
	endcase
end

assign Ext_Imme = {(con_ExtOp ? {16{IF_ID_Imme[15]}} : 16'h0000), IF_ID_Imme};
assign Lu_Imme = {IF_ID_Imme, 16'h0000};

assign JT = {IF_ID_PC_out[31:28], IF_ID_JumpAddr, 2'b00};

assign IRQ = interrupt && ~PC_out[31] && ~IF_Flush_flag;

//Branch, load-use(stall)
assign ID_Flush = ((ID_EX_PCSrc == 3'b001 && ALUOut0) || (stall && ~IRQ));


//----------------------------EX Stage----------------------------------
assign ForwardA_data = 
						(ForwardA == 2'b00) ? ID_EX_reg_data1 :
						(ForwardA == 2'b01) ? RegFileWr_data : EX_MEM_ALU_out;
assign ForwardB_data = 
						(ForwardB == 2'b00) ? ID_EX_reg_data2 :
						(ForwardB == 2'b01) ? RegFileWr_data : EX_MEM_ALU_out;
assign Forward_Jr_data = 
						(Forward_Jr == 2'b00) ? Databus_A :
						(Forward_Jr == 2'b01) ? RegFileWr_data :
						(Forward_Jr == 2'b10) ? (EX_MEM_MemRd ? MemRd_data : EX_MEM_ALU_out) :
						 ALU_out;

assign ALU_in1 = (ID_EX_ALUSrc1) ? {17'h00000, ID_EX_Shamt} : ForwardA_data;
assign ALU_in2 = (ID_EX_ALUSrc2) ? (ID_EX_LuOp ? ID_EX_Lu_Imme : ID_EX_Ext_Imme) : ForwardB_data;

assign ConBA = ID_EX_PC_out + {ID_EX_Ext_Imme[29:0], 2'b00};


//----------------------------MEM Stage----------------------------------
assign Mem_Addr = EX_MEM_ALU_out;
assign MemWr = EX_MEM_MemWr;
assign MemWr_data = EX_MEM_reg_data2;
assign MemRd = EX_MEM_MemRd;

//----------------------------WB Stage----------------------------------
assign RegDst = MEM_WB_RegDst;

assign RegFileWr = MEM_WB_RegWr;

assign RegFileWr_data = 
						(MEM_WB_MemToReg == 2'b00) ? MEM_WB_ALU_out :
						(MEM_WB_MemToReg == 2'b01) ? MEM_WB_MemRd_data : MEM_WB_PC_out;

endmodule