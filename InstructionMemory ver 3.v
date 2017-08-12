`timescale 1ns/1ps

module InstructionMemory(Address, Instruction);
	input [7:0] Address;
	output reg [31:0] Instruction;
	
	always @(*)
		case (Address)
  //Start:
        //j   Main			
      8'd0: Instruction <= {6'b000010, 26'd3};
        //j   Interrupt			
      8'd1: Instruction <= {6'b000010, 26'd139};
        //j   Exception			
      8'd2: Instruction <= {6'b000010, 26'd168};
  //Main:
        //addi $t0, $zero, 20		
      8'd3: Instruction <= {6'b001000, 5'd0, 5'd8, 16'h14};
        //jr   $t0			
      8'd4: Instruction <= {6'b000000, 5'd8, 5'd0, 5'd0, 5'd0, 6'b001000};
        //addi $t9, $zero, 4		
      8'd5: Instruction <= {6'b001000, 5'd0, 5'd25, 16'h4};
        //add  $s0, $zero, $zero
      8'd6: Instruction <= {6'b000000, 5'd0, 5'd0, 5'd16, 5'd0, 6'b100000};
        //lui  $s0, 0x4000		
      8'd7: Instruction <= {6'b001111, 5'd0, 5'd16, 16'h4000};
  //Timer_Op:
        //add  $t1, $zero, $zero		
      8'd8: Instruction <= {6'b000000, 5'd0, 5'd0, 5'd9, 5'd0, 6'b100000};
        //sw   $t1, 8($s0)		
      8'd9: Instruction <= {6'b101011, 5'd16, 5'd9, 16'h8};
        //lui  $t1, 0xffff
      8'd10: Instruction <= {6'b001111, 5'd0, 5'd9, 16'hffff};
        //ori  $t1, $t1, 0x61a8		
      8'd11: Instruction <= {6'b001101, 5'd9, 5'd9, 16'h61a8};
        //sw   $t1, 0($s0)		
      8'd12: Instruction <= {6'b101011, 5'd16, 5'd9, 16'h0};
        //ori  $t1, $t1, 0xffff		
      8'd13: Instruction <= {6'b001101, 5'd9, 5'd9, 16'hffff};
        //sw   $t1, 4($s0)		
      8'd14: Instruction <= {6'b101011, 5'd16, 5'd9, 16'h4};
        //addi $t1, $zero, 3		
      8'd15: Instruction <= {6'b001000, 5'd0, 5'd9, 16'h3};
        //sw   $t1, 8($s0)		
      8'd16: Instruction <= {6'b101011, 5'd16, 5'd9, 16'h8};
  //U_Rcv_Initialize:
        //ori  $t2, $zero, 0x0002
      8'd17: Instruction <= {6'b001101, 5'd0, 5'd10, 16'h0002};
        //sw   $t2, 32($s0)		
      8'd18: Instruction <= {6'b101011, 5'd16, 5'd10, 16'h20};
  //U_Rcv_Loop1:
        //lw   $t2, 32($s0)
      8'd19: Instruction <= {6'b100011, 5'd16, 5'd10, 16'h20};
        //andi $t2, $t2, 0x0008
      8'd20: Instruction <= {6'b001100, 5'd10, 5'd10, 16'h0008};
        //beq  $t2, $zero, U_Rcv_Loop1	
      8'd21: Instruction <= {6'b000100, 5'd0, 5'd10, 16'b1111111111111101};
        //lw   $t3, 28($s0)		
      8'd22: Instruction <= {6'b100011, 5'd16, 5'd11, 16'h1C};
        //beq  $t3, $zero, U_Rcv_Loop1	
      8'd23: Instruction <= {6'b000100, 5'd0, 5'd11, 16'b1111111111111011};
        //add  $s1, $zero, $t3		
      8'd24: Instruction <= {6'b000000, 5'd0, 5'd11, 5'd17, 5'd0, 6'b100000};
  //U_Rcv_Loop2:
        //lw   $t2, 32($s0)
      8'd25: Instruction <= {6'b100011, 5'd16, 5'd10, 16'h20};
        //andi $t2, $t2, 0x0008
      8'd26: Instruction <= {6'b001100, 5'd10, 5'd10, 16'h0008};
        //beq  $t2, $zero, U_Rcv_Loop2
      8'd27: Instruction <= {6'b000100, 5'd0, 5'd10, 16'b1111111111111101};
        //lw   $t3, 28($s0)
      8'd28: Instruction <= {6'b100011, 5'd16, 5'd11, 16'h1C};
        //beq  $t3, $zero, U_Rcv_Loop2
      8'd29: Instruction <= {6'b000100, 5'd0, 5'd11, 16'b1111111111111011};
        //add  $s2, $zero, $t3		
      8'd30: Instruction <= {6'b000000, 5'd0, 5'd11, 5'd18, 5'd0, 6'b100000};
  //U_Rcv_Finish:
        //add  $t2, $zero, $zero
      8'd31: Instruction <= {6'b000000, 5'd0, 5'd0, 5'd10, 5'd0, 6'b100000};
        //sw   $t2, 32($s0)		
      8'd32: Instruction <= {6'b101011, 5'd16, 5'd10, 16'h20};
  //Seg_Op:
        //sll  $a0, $s1, 24
      8'd33: Instruction <= {6'b000000, 5'd0, 5'd17, 5'd4, 5'd24, 6'b000000};
        //srl  $a0, $a0, 28
      8'd34: Instruction <= {6'b000000, 5'd0, 5'd4, 5'd4, 5'd28, 6'b000010};
        //jal  Get_Seg_Info
      8'd35: Instruction <= {6'b000011, 26'd77};
        //add  $s4, $zero, $v0		
      8'd36: Instruction <= {6'b000000, 5'd0, 5'd2, 5'd20, 5'd0, 6'b100000};
        //addi $s4, $s4, 0x0800
      8'd37: Instruction <= {6'b001000, 5'd20, 5'd20, 16'h0800};
        //sll  $a0, $s1, 28
      8'd38: Instruction <= {6'b000000, 5'd0, 5'd17, 5'd4, 5'd28, 6'b000000};
        //srl  $a0, $a0, 28
      8'd39: Instruction <= {6'b000000, 5'd0, 5'd4, 5'd4, 5'd28, 6'b000010};
        //jal  Get_Seg_Info
      8'd40: Instruction <= {6'b000011, 26'd77};
        //add  $s5, $zero, $v0		
      8'd41: Instruction <= {6'b000000, 5'd0, 5'd2, 5'd21, 5'd0, 6'b100000};
        //addi $s5, $s5, 0x0400
      8'd42: Instruction <= {6'b001000, 5'd21, 5'd21, 16'h0400};
        //sll  $a0, $s2, 24
      8'd43: Instruction <= {6'b000000, 5'd0, 5'd18, 5'd4, 5'd24, 6'b000000};
        //srl  $a0, $a0, 28
      8'd44: Instruction <= {6'b000000, 5'd0, 5'd4, 5'd4, 5'd28, 6'b000010};
        //jal  Get_Seg_Info
      8'd45: Instruction <= {6'b000011, 26'd77};
        //add  $s6, $zero, $v0		
      8'd46: Instruction <= {6'b000000, 5'd0, 5'd2, 5'd22, 5'd0, 6'b100000};
        //addi $s6, $s6, 0x0200
      8'd47: Instruction <= {6'b001000, 5'd22, 5'd22, 16'h0200};
        //sll  $a0, $s2, 28
      8'd48: Instruction <= {6'b000000, 5'd0, 5'd18, 5'd4, 5'd28, 6'b000000};
        //srl  $a0, $a0, 28
      8'd49: Instruction <= {6'b000000, 5'd0, 5'd4, 5'd4, 5'd28, 6'b000010};
        //jal  Get_Seg_Info
      8'd50: Instruction <= {6'b000011, 26'd77};
        //add  $s7, $zero, $v0		
      8'd51: Instruction <= {6'b000000, 5'd0, 5'd2, 5'd23, 5'd0, 6'b100000};
        //addi $s7, $s7, 0x0100
      8'd52: Instruction <= {6'b001000, 5'd23, 5'd23, 16'h0100};
  //Find_GCD_Main:
        //slt  $t0, $s1, $s2
      8'd53: Instruction <= {6'b000000, 5'd17, 5'd18, 5'd8, 5'd0, 6'b101010};
        //beq  $t0, $zero, Find_GCD_Link
      8'd54: Instruction <= {6'b000100, 5'd0, 5'd8, 16'b11};
        //add  $t0, $zero, $s1
      8'd55: Instruction <= {6'b000000, 5'd0, 5'd17, 5'd8, 5'd0, 6'b100000};
        //add  $s1, $zero, $s2
      8'd56: Instruction <= {6'b000000, 5'd0, 5'd18, 5'd17, 5'd0, 6'b100000};
        //add  $s2, $zero, $t0		
      8'd57: Instruction <= {6'b000000, 5'd0, 5'd8, 5'd18, 5'd0, 6'b100000};
  //Find_GCD_Link:
        //add  $t1, $zero, $s1
      8'd58: Instruction <= {6'b000000, 5'd0, 5'd17, 5'd9, 5'd0, 6'b100000};
        //add  $t2, $zero, $s2
      8'd59: Instruction <= {6'b000000, 5'd0, 5'd18, 5'd10, 5'd0, 6'b100000};
  //GCD_Func_Loop:
        //sub  $t1, $t1, $t2
      8'd60: Instruction <= {6'b000000, 5'd9, 5'd10, 5'd9, 5'd0, 6'b100010};
        //beq  $t1, $zero, GCD_Func_Return
      8'd61: Instruction <= {6'b000100, 5'd0, 5'd9, 16'b110};
        //slt  $t0, $t1, $t2
      8'd62: Instruction <= {6'b000000, 5'd9, 5'd10, 5'd8, 5'd0, 6'b101010};
        //beq  $t0, $zero, GCD_Func_Loop
      8'd63: Instruction <= {6'b000100, 5'd0, 5'd8, 16'b1111111111111100};
        //add  $t0, $zero, $t1
      8'd64: Instruction <= {6'b000000, 5'd0, 5'd9, 5'd8, 5'd0, 6'b100000};
        //add  $t1, $zero, $t2
      8'd65: Instruction <= {6'b000000, 5'd0, 5'd10, 5'd9, 5'd0, 6'b100000};
        //add  $t2, $zero, $t0
      8'd66: Instruction <= {6'b000000, 5'd0, 5'd8, 5'd10, 5'd0, 6'b100000};
        //j    GCD_Func_Loop
      8'd67: Instruction <= {6'b000010, 26'd60};
  //GCD_Func_Return:
        //add  $s3, $zero, $t2
      8'd68: Instruction <= {6'b000000, 5'd0, 5'd10, 5'd19, 5'd0, 6'b100000};
        //sw   $s3, 12($s0)		
      8'd69: Instruction <= {6'b101011, 5'd16, 5'd19, 16'hC};
  //U_Send_Loop:
        //lw   $t2, 32($s0)
      8'd70: Instruction <= {6'b100011, 5'd16, 5'd10, 16'h20};
        //andi $t2, $t2, 0x0010
      8'd71: Instruction <= {6'b001100, 5'd10, 5'd10, 16'h0010};
        //bne  $t2, $zero, U_Send_Loop	
      8'd72: Instruction <= {6'b000101, 5'd0, 5'd10, 16'b1111111111111101};
  //U_Send:
        //ori  $t2, $zero, 0x0001
      8'd73: Instruction <= {6'b001101, 5'd0, 5'd10, 16'h0001};
        //sw   $s3, 32($s0)		
      8'd74: Instruction <= {6'b101011, 5'd16, 5'd19, 16'h20};
        //sw   $s3, 24($s0)		
      8'd75: Instruction <= {6'b101011, 5'd16, 5'd19, 16'h18};
  //U_Send_After:
        //j    U_Rcv_Initialize		
      8'd76: Instruction <= {6'b000010, 26'd17};
  //Get_Seg_Info:
        //ori  $t0, $zero, 0x0000
      8'd77: Instruction <= {6'b001101, 5'd0, 5'd8, 16'h0000};
        //bne  $a0, $t0, Judge_1
      8'd78: Instruction <= {6'b000101, 5'd8, 5'd4, 16'b10};
        //ori  $v0, $zero, 0x0040
      8'd79: Instruction <= {6'b001101, 5'd0, 5'd2, 16'h0040};
        //jr   $ra
      8'd80: Instruction <= {6'b000000, 5'd31, 5'd0, 5'd0, 5'd0, 6'b001000};
  //Judge_1:
        //ori  $t0, $zero, 0x0001
      8'd81: Instruction <= {6'b001101, 5'd0, 5'd8, 16'h0001};
        //bne  $a0, $t0, Judge_2
      8'd82: Instruction <= {6'b000101, 5'd8, 5'd4, 16'b10};
        //ori  $v0, $zero, 0x0079
      8'd83: Instruction <= {6'b001101, 5'd0, 5'd2, 16'h0079};
        //jr   $ra
      8'd84: Instruction <= {6'b000000, 5'd31, 5'd0, 5'd0, 5'd0, 6'b001000};
  //Judge_2:
        //ori  $t0, $zero, 0x0002
      8'd85: Instruction <= {6'b001101, 5'd0, 5'd8, 16'h0002};
        //bne  $a0, $t0, Judge_3
      8'd86: Instruction <= {6'b000101, 5'd8, 5'd4, 16'b10};
        //ori  $v0, $zero, 0x0024
      8'd87: Instruction <= {6'b001101, 5'd0, 5'd2, 16'h0024};
        //jr   $ra
      8'd88: Instruction <= {6'b000000, 5'd31, 5'd0, 5'd0, 5'd0, 6'b001000};
  //Judge_3:
        //ori  $t0, $zero, 0x0003
      8'd89: Instruction <= {6'b001101, 5'd0, 5'd8, 16'h0003};
        //bne  $a0, $t0, Judge_4
      8'd90: Instruction <= {6'b000101, 5'd8, 5'd4, 16'b10};
        //ori  $v0, $zero, 0x0030
      8'd91: Instruction <= {6'b001101, 5'd0, 5'd2, 16'h0030};
        //jr   $ra
      8'd92: Instruction <= {6'b000000, 5'd31, 5'd0, 5'd0, 5'd0, 6'b001000};
  //Judge_4:
        //ori  $t0, $zero, 0x0004
      8'd93: Instruction <= {6'b001101, 5'd0, 5'd8, 16'h0004};
        //bne  $a0, $t0, Judge_5
      8'd94: Instruction <= {6'b000101, 5'd8, 5'd4, 16'b10};
        //ori  $v0, $zero, 0x0019
      8'd95: Instruction <= {6'b001101, 5'd0, 5'd2, 16'h0019};
        //jr   $ra
      8'd96: Instruction <= {6'b000000, 5'd31, 5'd0, 5'd0, 5'd0, 6'b001000};
  //Judge_5:
        //ori  $t0, $zero, 0x0005
      8'd97: Instruction <= {6'b001101, 5'd0, 5'd8, 16'h0005};
        //bne  $a0, $t0, Judge_6
      8'd98: Instruction <= {6'b000101, 5'd8, 5'd4, 16'b10};
        //ori  $v0, $zero, 0x0012
      8'd99: Instruction <= {6'b001101, 5'd0, 5'd2, 16'h0012};
        //jr   $ra
      8'd100: Instruction <= {6'b000000, 5'd31, 5'd0, 5'd0, 5'd0, 6'b001000};
  //Judge_6:
        //ori  $t0, $zero, 0x0006
      8'd101: Instruction <= {6'b001101, 5'd0, 5'd8, 16'h0006};
        //bne  $a0, $t0, Judge_7
      8'd102: Instruction <= {6'b000101, 5'd8, 5'd4, 16'b10};
        //ori  $v0, $zero, 0x0002
      8'd103: Instruction <= {6'b001101, 5'd0, 5'd2, 16'h0002};
        //jr   $ra
      8'd104: Instruction <= {6'b000000, 5'd31, 5'd0, 5'd0, 5'd0, 6'b001000};
  //Judge_7:
        //ori  $t0, $zero, 0x0007
      8'd105: Instruction <= {6'b001101, 5'd0, 5'd8, 16'h0007};
        //bne  $a0, $t0, Judge_8
      8'd106: Instruction <= {6'b000101, 5'd8, 5'd4, 16'b10};
        //ori  $v0, $zero, 0x0078
      8'd107: Instruction <= {6'b001101, 5'd0, 5'd2, 16'h0078};
        //jr   $ra
      8'd108: Instruction <= {6'b000000, 5'd31, 5'd0, 5'd0, 5'd0, 6'b001000};
  //Judge_8:
        //ori  $t0, $zero, 0x0008
      8'd109: Instruction <= {6'b001101, 5'd0, 5'd8, 16'h0008};
        //bne  $a0, $t0, Judge_9
      8'd110: Instruction <= {6'b000101, 5'd8, 5'd4, 16'b10};
        //ori  $v0, $zero, 0x0000
      8'd111: Instruction <= {6'b001101, 5'd0, 5'd2, 16'h0000};
        //jr   $ra
      8'd112: Instruction <= {6'b000000, 5'd31, 5'd0, 5'd0, 5'd0, 6'b001000};
  //Judge_9:
        //ori  $t0, $zero, 0x0009
      8'd113: Instruction <= {6'b001101, 5'd0, 5'd8, 16'h0009};
        //bne  $a0, $t0, Judge_A
      8'd114: Instruction <= {6'b000101, 5'd8, 5'd4, 16'b10};
        //ori  $v0, $zero, 0x0010
      8'd115: Instruction <= {6'b001101, 5'd0, 5'd2, 16'h0010};
        //jr   $ra
      8'd116: Instruction <= {6'b000000, 5'd31, 5'd0, 5'd0, 5'd0, 6'b001000};
  //Judge_A:
        //ori  $t0, $zero, 0x000A
      8'd117: Instruction <= {6'b001101, 5'd0, 5'd8, 16'h000A};
        //bne  $a0, $t0, Judge_B
      8'd118: Instruction <= {6'b000101, 5'd8, 5'd4, 16'b10};
        //ori  $v0, $zero, 0x0008
      8'd119: Instruction <= {6'b001101, 5'd0, 5'd2, 16'h0008};
        //jr   $ra
      8'd120: Instruction <= {6'b000000, 5'd31, 5'd0, 5'd0, 5'd0, 6'b001000};
  //Judge_B:
        //ori  $t0, $zero, 0x000B
      8'd121: Instruction <= {6'b001101, 5'd0, 5'd8, 16'h000B};
        //bne  $a0, $t0, Judge_C
      8'd122: Instruction <= {6'b000101, 5'd8, 5'd4, 16'b10};
        //ori  $v0, $zero, 0x0003
      8'd123: Instruction <= {6'b001101, 5'd0, 5'd2, 16'h0003};
        //jr   $ra
      8'd124: Instruction <= {6'b000000, 5'd31, 5'd0, 5'd0, 5'd0, 6'b001000};
  //Judge_C:
        //ori  $t0, $zero, 0x000C
      8'd125: Instruction <= {6'b001101, 5'd0, 5'd8, 16'h000C};
        //bne  $a0, $t0, Judge_D
      8'd126: Instruction <= {6'b000101, 5'd8, 5'd4, 16'b10};
        //ori  $v0, $zero, 0x0046
      8'd127: Instruction <= {6'b001101, 5'd0, 5'd2, 16'h0046};
        //jr   $ra
      8'd128: Instruction <= {6'b000000, 5'd31, 5'd0, 5'd0, 5'd0, 6'b001000};
  //Judge_D:
        //ori  $t0, $zero, 0x000D
      8'd129: Instruction <= {6'b001101, 5'd0, 5'd8, 16'h000D};
        //bne  $a0, $t0, Judge_E
      8'd130: Instruction <= {6'b000101, 5'd8, 5'd4, 16'b10};
        //ori  $v0, $zero, 0x0021
      8'd131: Instruction <= {6'b001101, 5'd0, 5'd2, 16'h0021};
        //jr   $ra
      8'd132: Instruction <= {6'b000000, 5'd31, 5'd0, 5'd0, 5'd0, 6'b001000};
  //Judge_E:
        //ori  $t0, $zero, 0x000E
      8'd133: Instruction <= {6'b001101, 5'd0, 5'd8, 16'h000E};
        //bne  $a0, $t0, Judge_F
      8'd134: Instruction <= {6'b000101, 5'd8, 5'd4, 16'b10};
        //ori  $v0, $zero, 0x0006
      8'd135: Instruction <= {6'b001101, 5'd0, 5'd2, 16'h0006};
        //jr   $ra
      8'd136: Instruction <= {6'b000000, 5'd31, 5'd0, 5'd0, 5'd0, 6'b001000};
  //Judge_F:
        //ori  $v0, $zero, 0x000E
      8'd137: Instruction <= {6'b001101, 5'd0, 5'd2, 16'h000E};
        //jr   $ra
      8'd138: Instruction <= {6'b000000, 5'd31, 5'd0, 5'd0, 5'd0, 6'b001000};
  //Interrupt:
        //lw   $t4, 8($s0)		
      8'd139: Instruction <= {6'b100011, 5'd16, 5'd12, 16'h8};
        //add  $t5, $zero, $zero		
      8'd140: Instruction <= {6'b000000, 5'd0, 5'd0, 5'd13, 5'd0, 6'b100000};
        //lui  $t5, 0xffff
      8'd141: Instruction <= {6'b001111, 5'd0, 5'd13, 16'hffff};
        //ori  $t5, $t5, 0xfff9		
      8'd142: Instruction <= {6'b001101, 5'd13, 5'd13, 16'hfff9};
        //and  $t4, $t4, $t5
      8'd143: Instruction <= {6'b000000, 5'd12, 5'd13, 5'd12, 5'd0, 6'b100100};
        //sw   $t4, 8($s0)		
      8'd144: Instruction <= {6'b101011, 5'd16, 5'd12, 16'h8};
  //Judge_Show_4:
        //ori  $t6, $zero, 0x0004
      8'd145: Instruction <= {6'b001101, 5'd0, 5'd14, 16'h0004};
        //bne  $t9, $t6, Judge_Show_5
      8'd146: Instruction <= {6'b000101, 5'd14, 5'd25, 16'b11};
        //sw   $s4, 20($s0)		
      8'd147: Instruction <= {6'b101011, 5'd16, 5'd20, 16'h14};
        //ori  $t9, $zero, 0x0005		
      8'd148: Instruction <= {6'b001101, 5'd0, 5'd25, 16'h0005};
        //j    Get_Back
      8'd149: Instruction <= {6'b000010, 26'd162};
  //Judge_Show_5:
        //ori  $t6, $zero, 0x0005
      8'd150: Instruction <= {6'b001101, 5'd0, 5'd14, 16'h0005};
        //bne  $t9, $t6, Judge_Show_6
      8'd151: Instruction <= {6'b000101, 5'd14, 5'd25, 16'b11};
        //sw   $s5, 20($s0)		
      8'd152: Instruction <= {6'b101011, 5'd16, 5'd21, 16'h14};
        //ori  $t9, $zero, 0x0006		
      8'd153: Instruction <= {6'b001101, 5'd0, 5'd25, 16'h0006};
        //j    Get_Back
      8'd154: Instruction <= {6'b000010, 26'd162};
  //Judge_Show_6:
        //ori  $t6, $zero, 0x0006
      8'd155: Instruction <= {6'b001101, 5'd0, 5'd14, 16'h0006};
        //bne  $t9, $t6, Judge_Show_7
      8'd156: Instruction <= {6'b000101, 5'd14, 5'd25, 16'b11};
        //sw   $s6, 20($s0)		
      8'd157: Instruction <= {6'b101011, 5'd16, 5'd22, 16'h14};
        //ori  $t9, $zero, 0x0007		
      8'd158: Instruction <= {6'b001101, 5'd0, 5'd25, 16'h0007};
        //j    Get_Back
      8'd159: Instruction <= {6'b000010, 26'd162};
  //Judge_Show_7:
        //sw   $s7, 20($s0)		
      8'd160: Instruction <= {6'b101011, 5'd16, 5'd23, 16'h14};
        //ori  $t9, $zero, 0x0004		
      8'd161: Instruction <= {6'b001101, 5'd0, 5'd25, 16'h0004};
  //Get_Back:
        //add  $t5, $zero, $zero		
      8'd162: Instruction <= {6'b000000, 5'd0, 5'd0, 5'd13, 5'd0, 6'b100000};
        //ori  $t5, $t5, 0x0002		
      8'd163: Instruction <= {6'b001101, 5'd13, 5'd13, 16'h0002};
        //or   $t4, $t4, $t5
      8'd164: Instruction <= {6'b000000, 5'd12, 5'd13, 5'd12, 5'd0, 6'b100101};
        //sw   $t4, 8($s0)		
      8'd165: Instruction <= {6'b101011, 5'd16, 5'd12, 16'h8};
        //addi $k0, $k0, -4
      8'd166: Instruction <= {6'b001000, 5'd26, 5'd26, 16'hFFFC};
        //jr   $k0
      8'd167: Instruction <= {6'b000000, 5'd26, 5'd0, 5'd0, 5'd0, 6'b001000};
  //Exception:
        //j Exception
      8'd168: Instruction <= {6'b000010, 26'd168};

			default: Instruction <= {6'b000010, 26'd0};
			  //i.e. j Main
		endcase
		
endmodule
