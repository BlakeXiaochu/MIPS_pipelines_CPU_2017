`timescale 1ns/1ps

module pipelines_tb();

reg clk;
reg reset;
// reg interrupt;
wire [31:0] Mem_Addr;
wire MemWr;
wire [31:0] MemWr_data;
wire MemRd;
wire [31:0] MemRd_data;
wire [7:0] led;
wire [7:0] switch;
wire [11:0] digi;
wire [6:0] digi_out1;
wire [6:0] digi_out2;
wire [6:0] digi_out3;
wire [6:0] digi_out4;
wire irqout;
reg UART_RX;
wire UART_TX;


initial
begin
	reset = 1;
	clk = 0;
	UART_RX = 1;
	// interrupt = 0;
	#1 reset = 0;
	#1 reset = 1;
	#104167 UART_RX = 0;
	#104167 UART_RX = 0;
	#104167 UART_RX = 0;
	#104167 UART_RX = 1;
	#104167 UART_RX = 1;
	#104167 UART_RX = 1;
	#104167 UART_RX = 0;
	#104167 UART_RX = 1;
	#104167 UART_RX = 1;
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
end

always @(*) #10 clk <= ~clk;

digitube_scan digitube(
	.digi_in(digi),
	.digi_out1(digi_out1),
	.digi_out2(digi_out2),
	.digi_out3(digi_out3),
	.digi_out4(digi_out4)
	);

Pipeline_CPU pipeline_CPU(
	.clk(clk),
	.reset(reset), 
	.interrupt(irqout), 
	.Mem_Addr(Mem_Addr), 
	.MemWr(MemWr),
	.MemWr_data(MemWr_data),
	.MemRd(MemRd),
	.MemRd_data(MemRd_data)
	 );

Peripheral peripheral(
	.reset(reset),
	.cpu_clk(clk),
	.sysclk(clk),
	.rd(MemRd),
	.wr(MemWr),
	.addr(Mem_Addr),
	.wdata(MemWr_data),
	.rdata(MemRd_data),
	.led(led),
	.switch(switch),
	.digi(digi),
	.irqout(irqout),
	.UART_RX(UART_RX),
	.UART_TX(UART_TX)
	);

endmodule