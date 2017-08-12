`timescale 1ns/1ps

module DataMem (reset,clk,rd,wr,addr,wdata,rdata);
input reset,clk;
input rd,wr;
input [31:0] addr;	//Address Must be Word Aligned
output [31:0] rdata;
input [31:0] wdata;

parameter RAM_SIZE = 256;
reg [31:0] RAMDATA [RAM_SIZE-1:0];
integer i;

assign rdata = rd ? RAMDATA[addr[9:2]] : 32'b0;

always@(posedge clk or negedge reset) begin
	if(~reset) 
	begin
		for(i = 0; i < RAM_SIZE; i = i + 1) RAMDATA[i] <= 32'b0;
 	end
	else if(wr) RAMDATA[addr[9:2]] <= wdata;
end

endmodule
