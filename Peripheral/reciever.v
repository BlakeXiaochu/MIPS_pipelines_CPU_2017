`timescale 1ns/1ps

module reciever(BRclk, reset, UART_RX, RX_STATUS, RX_DATA);
input BRclk, reset, UART_RX;
output reg RX_STATUS;
output reg [7:0] RX_DATA;

reg start;
reg [7:0] data;
reg [3:0] delay;
reg align;
reg [3:0] bit_num;
reg [4:0] count_num;
//signal bit
always @(negedge UART_RX or negedge reset or posedge align)
begin
	if(~reset)
		start <= 0;
	else if(align) start <= 0;
	else start <= 1;
end

//align to one circle's center(delay 8 circles)
//bit number recieved
always @(posedge BRclk or negedge reset)
begin
	if (~reset) 
	begin
		delay <= 0;
		align <= 0;
		bit_num <= 0;
		count_num <= 0;
		RX_STATUS <= 0;
		data <= 8'b00000000;
		RX_DATA <= 8'b00000000;
	end
	else if(start)
	begin
		if(delay >= 4'b1000) 
		begin
			delay <= 0;	
			align <= 1;
		end
		else delay <= delay + 4'd1;		
	end
	else begin
		if(RX_STATUS)
				RX_STATUS <= 0; 
		if(align) 
		begin
			if(count_num >= 5'b01111)
			begin
				count_num <= 0;
				bit_num <= bit_num + 4'd1;
				data[bit_num] <= UART_RX;
			end
			else count_num <= count_num + 5'd1;
			
			//complete recieving 
			if(bit_num >= 4'b1000)
			begin
				align <= 0;
				count_num <= 0;
				bit_num <= 0;
				RX_STATUS <= 1;
				data <= 0;
				RX_DATA <= data;
			end
		end
	end
end
endmodule