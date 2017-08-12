module ADD(A,B,ALUFun,Sign,S,Z,V,N);
  input [31:0] A;
  input [31:0] B;
  input ALUFun;
  input Sign;
  output [31:0] S;
  output Z,V,N;
  wire [31:0] b;
  wire [32:0] c;
  wire [32:0] d;
  wire [32:0] s;

  assign c={A,1'b1};
  assign d={~B,1'b1}; 
  assign b=(ALUFun)?(~B+1):B;
  assign s = c + d;
  
  assign S = (ALUFun) ? (s[32:1]) : (A + B);
  assign Z=(S==0);
  assign V=(Sign&(A[31]==b[31])&(S[31]==(~A[31])));
  assign N=((Sign&S[31])|((!Sign)&((A[31]&b[31])|(A[31]&~S[31])|(b[31]&S[31]))));

endmodule