`timescale 1ns/1ps

`timescale 1ns/1ps

module pipelines_with_peripheral(reset, sysclk, UART_RX, UART_TX, led, switch, digi_out1, digi_out2, digi_out3, digi_out4);
input reset;
input sysclk;
input UART_RX;
output UART_TX;
output [7:0] led;
input [7:0] switch;
output [6:0] digi_out1;
output [6:0] digi_out2;
output [6:0] digi_out3;
output [6:0] digi_out4;

wire [31:0] Mem_Addr;
wire MemWr;
wire [31:0] MemWr_data;
wire MemRd;
wire [31:0] MemRd_data;
wire [11:0] digi;
wire irqout;

reg clk;

always @(posedge sysclk or negedge reset) begin
	if (~reset) clk <= 0;
	else clk <= ~clk;
end

digitube_scan digitube(
	.digi_in(digi),
	.digi_out1(digi_out1),
	.digi_out2(digi_out2),
	.digi_out3(digi_out3),
	.digi_out4(digi_out4)
	);

Pipeline_CPU pipeline_CPU(
	.clk(sysclk),
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
	.cpu_clk(sysclk),
	.sysclk(sysclk),
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