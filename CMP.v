module CMP(A,B,ALUFun,Sign,Z,V,N,S);
  input [31:0] A;
  input [31:0] B;
  input [2:0] ALUFun;
  input Sign,Z,V,N;
  output reg S;
  
  always@(*)
  case(ALUFun)
    3'b001:S=Z;
    3'b000:S=~Z;
    3'b010:S=N;
    3'b110:S=((A==0)|(Sign&A[31]));
    3'b101:S=(Sign&A[31]);
    3'b111:S=((~(Sign&A[31]))&(A!=0));
    default:S=1'b0;
  endcase
  
endmodule