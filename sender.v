`timescale 1ns/1ps

module sender(clk, BRclk, reset, TX_EN, TX_DATA, TX_STATUS, UART_TX);
input clk, BRclk, reset, TX_EN;
input [7:0] TX_DATA;
output reg TX_STATUS, UART_TX;

reg sending, sended;
reg [3:0] send_num;
reg [9:0] data;

always @(posedge BRclk or negedge reset)
begin
	if (~reset)
	begin
		send_num <= 0;
		UART_TX <= 1;
	end
	else
	begin
		if(sending)
		begin
			send_num <= send_num + 4'd1;

			if(send_num >= 4'b1010)
			begin
				send_num <= 0;
			end
			else UART_TX <= data[send_num];
		end
	end
end

reg [3:0] flag;

always @(posedge clk or negedge reset)
begin
	if (~reset)
	begin
		sended <= 1;
		sending <= 0;
		TX_STATUS <= 1;
		data <= 0;
	end
	else
	begin
		flag <= send_num;
		if(flag == 4'b1001 && send_num == 4'b1010) sended <= 1;

		if(TX_STATUS && TX_EN && sended)
		begin
			sended <= 0;
			TX_STATUS <= 0;
			sending <= 1;
			data[8:1] <= TX_DATA;
			data[0] <= 0;
			data[9] <= 1;
		end

		else if(sended)
		begin
			sending <= 0;
			TX_STATUS <= 1;
		end
	end
end

endmodule