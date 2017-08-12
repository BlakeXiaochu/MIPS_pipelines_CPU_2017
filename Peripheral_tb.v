`timescale 1ns/1ps

module Peripheral_tb();
reg clk;
reg reset;
reg rd;
reg wr;
reg [31:0] addr;
reg [31:0] wdata;
wire [31:0] rdata;
wire [7:0] led;
wire [7:0] switch;
wire [11:0] digi;
wire irqout;
reg UART_RX;
wire UART_TX;

initial
begin
	reset = 1;
	clk = 0;
	rd = 0;
	wr = 0;
	UART_RX = 1;
	addr = 32'h00000000;
	wdata = 32'h0000008f;
	#2 reset = 0;
	#2 reset = 1;
	#104167 UART_RX = 0;
	#104167 UART_RX = 1;
	#104167 UART_RX = 1;
	#104167 UART_RX = 0;
	#104167 UART_RX = 1;
	#104167 UART_RX = 0;
	#104167 UART_RX = 0;
	#104167 UART_RX = 1;
	#104167 UART_RX = 1;
	#104167 UART_RX = 1;
	#104167 UART_RX = 1;
	#104167 UART_RX = 0;
	#104167 UART_RX = 0;
	#104167 UART_RX = 0;
	#104167 UART_RX = 0;
	#104167 UART_RX = 0;
	#104167 UART_RX = 1;
	#104167 UART_RX = 1;
	#104167 UART_RX = 1;
	#104167 UART_RX = 1;
	#104167 UART_RX = 1;
	#104167 UART_RX = 1;

	wr = 1;
	addr = 32'h40000018;
	#20 wr = 0;
	
	#2000000 wr = 1;
	wdata = 32'h000000ac;
	#20 wr = 0;
end

always @(*) #10 clk <= ~clk;

Peripheral peripheral(
	.reset(reset),
	.sysclk(clk),
	.clk(clk),
	.rd(rd),
	.wr(wr),
	.addr(addr),
	.wdata(wdata),
	.rdata(rdata),
	.led(led),
	.switch(switch),
	.digi(digi),
	.irqout(irqout),
	.UART_RX(UART_RX),
	.UART_TX(UART_TX)
	);
endmodule