`timescale 1ns/1ps

module PC_Reg(clk, reset, RegWr, Addr_in, Addr_out);
input clk;
input reset;
input RegWr;
input [31:0] Addr_in;
output reg [31:0] Addr_out;

always @(posedge clk or negedge reset) begin
	if (~reset)
	begin
		Addr_out <= 32'h80000000;	
	end
	else
	begin
		if(RegWr)
		begin
			Addr_out <= Addr_in;
		end
	end
end

endmodule