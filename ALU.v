module ALU(A,B,ALUFun,Sign,S);
  input [31:0] A;
  input [31:0] B;
  input [5:0] ALUFun;
  input Sign;
  output [31:0] S;
  wire [31:0] S_ADD,S_Logic,S_Shift;
  wire S_CMP;
  wire Z,V,N;
  
  ADD add1(A,B,ALUFun[0],Sign,S_ADD,Z,V,N);
  CMP cmp1(A,B,ALUFun[3:1],Sign,Z,V,N,S_CMP);
  Logic logic1(A,B,ALUFun[3:0],S_Logic);
  Shift shift1(A,B,ALUFun[1:0],S_Shift);
  
  assign S=(ALUFun[5:4]==2'b00)?S_ADD:
           (ALUFun[5:4]==2'b01)?S_Logic:
           (ALUFun[5:4]==2'b10)?S_Shift:
           {31'b0,S_CMP};
    
endmodule