module Logic(A,B,ALUFun,S);
  input [31:0] A;
  input [31:0] B;
  input [3:0] ALUFun;
  output reg [31:0] S;
  
  always@(*)
  case(ALUFun)
    4'b1000:S=A&B;
    4'b1110:S=A|B;
    4'b0110:S=A^B;
    4'b0001:S=~(A|B);
    4'b1010:S=A;
    default:S=0;
  endcase
  
endmodule