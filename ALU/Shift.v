module Shift(A,B,ALUFun,S);
  input [31:0] A;
  input [31:0] B;
  input [1:0] ALUFun;
  output reg [31:0] S;
  reg [31:0] S0,S1,S2,S3;
  
  always@(*)
  begin
    if(ALUFun==2'b00)
    begin
      S <= B << A[4:0];
    end
    else if(ALUFun==2'b01)
    begin
      S <= B >> A[4:0];
    end
    else if(ALUFun==2'b11)
    begin
      S0 <= A[0]?{B[31],B[31:1]}:B;
      S1 <= A[1]?{{2{B[31]}},S0[31:2]}:S0;
      S2 <= A[2]?{{4{B[31]}},S1[31:4]}:S1;
      S3 <= A[3]?{{8{B[31]}},S2[31:8]}:S2;
      S <= A[4]?{{16{B[31]}},S3[31:16]}:S3;
    end
	   else
      begin
       S0 <= 32'b0;
       S1 <= 32'b0;
       S2 <= 32'b0; 
       S3 <= 32'b0;
		 S <= B;
	   end
  end
  
endmodule
     