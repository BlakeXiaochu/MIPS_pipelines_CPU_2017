`timescale 1ns/1ps

module Peripheral(reset, sysclk, cpu_clk, rd, wr, addr, wdata, rdata, led, switch, digi, irqout, UART_RX, UART_TX);
input reset;
//50Mhz sysclk, and processor'clk
input sysclk, cpu_clk;
input rd,wr;
input [31:0] addr;
input [31:0] wdata;
output reg [31:0] rdata;

output reg [7:0] led;
input [7:0] switch;
output reg [11:0] digi;
output irqout;

reg [31:0] TH,TL;
reg [2:0] TCON;
wire [31:0] MemRd_data;
wire MemWr;

input UART_RX;
output UART_TX;
//9600Hz
wire clk1;
//9600*16Hz
wire clk2;
wire RX_STATUS;
//previous RX_STATUS
reg pre_RX_STATUS;
wire [7:0] pre_UART_RXD;
reg [7:0] UART_RXD;
reg [7:0] UART_TXD;
wire TX_STATUS;
reg pre_TX_STATUS;
wire [4:0] UART_CON;
//Flag which represents if there's new data to send
reg TX_EN;
reg UART_CON0, UART_CON1, UART_CON2, UART_CON3;

//Interruption
assign irqout = TCON[2];

//UART
clk_gen clk_generator(.clk(sysclk), .reset(reset), .clko1(clk1), .clko2(clk2));
reciever UART_rec(.BRclk(clk2), .reset(reset), .UART_RX(UART_RX), .RX_STATUS(RX_STATUS), .RX_DATA(pre_UART_RXD));
sender UART_sen(.clk(cpu_clk), .BRclk(clk1), .reset(reset), .TX_EN(TX_EN), .TX_DATA(UART_TXD), .TX_STATUS(TX_STATUS), .UART_TX(UART_TX));

assign UART_CON[0] = UART_CON0;
assign UART_CON[1] = UART_CON1;
assign UART_CON[2] = UART_CON2;
assign UART_CON[3] = UART_CON3;
assign UART_CON[4] = ~TX_STATUS;


//DataMemory
DataMem datamem(.reset(reset), .clk(cpu_clk), .rd(rd), .wr(MemWr), .addr(addr), .wdata(wdata), .rdata(MemRd_data));
assign MemWr = 
				~wr ? 1'b0 :
				(addr[31:28] < 4'h4) ? 1'b1 : 1'b0;

always@(*) begin
	if(rd) begin
		case(addr[31:8])
			24'h400000:
			begin
				case(addr[7:0])
				8'h00: rdata <= TH;			
				8'h04: rdata <= TL;			
				8'h08: rdata <= {29'b0, TCON};				
				8'h0C: rdata <= {24'b0, led};			
				8'h10: rdata <= {24'b0, switch};
				8'h14: rdata <= {20'b0, digi};
				8'h18: rdata <= {24'b0, UART_TXD};
				8'h1c: rdata <= {24'b0, UART_RXD};
				8'h20: rdata <= {27'b0, UART_CON};
				default: rdata <= 32'h0;
				endcase
			end
			// 32'h40000000: rdata <= TH;			
			// 32'h40000004: rdata <= TL;			
			// 32'h40000008: rdata <= {29'b0, TCON};				
			// 32'h4000000C: rdata <= {24'b0, led};			
			// 32'h40000010: rdata <= {24'b0, switch};
			// 32'h40000014: rdata <= {20'b0, digi};
			// 32'h40000018: rdata <= {24'b0, UART_TXD};
			// 32'h4000001c: rdata <= {24'b0, UART_RXD};
			// 32'h40000020: rdata <= {27'b0, UART_CON};
			default:
			begin
				if(addr[31:28] < 4'h4) rdata <= MemRd_data;
				else rdata <= 32'h0;
			end
		endcase
	end
	else
		rdata <= 32'b0;
end

always@(negedge reset or posedge cpu_clk)
begin
	if(~reset) begin
		TH <= 32'b0;
		TL <= 32'b0;
		TCON <= 3'b0;
		led <= 8'b0;
		digi <= 12'b0;
		pre_RX_STATUS <= 1;
		pre_TX_STATUS <= 1;
		UART_TXD <= 8'b00000000;
		UART_RXD <= 8'b00000000;
		UART_CON0 <= 0;
		UART_CON1 <= 0;
		UART_CON2 <= 1;
		UART_CON3 <= 0;
		TX_EN <= 0;
	end
	else begin
		if(TCON[0]) begin	//timer is enabled
			if(TL==32'hffffffff) begin
				TL <= TH;
				if(TCON[1]) TCON[2] <= 1'b1;		//irq is enabled
			end
			else TL <= TL + 1;
		end

		pre_RX_STATUS <= RX_STATUS;
		pre_TX_STATUS <= TX_STATUS;
		//RX_STATUS posedge
		//Recieved new data
		if(~pre_RX_STATUS && RX_STATUS)
		begin
			UART_CON3 <= 1;
			UART_RXD <= pre_UART_RXD;
		end

		//Finish sending new data
		if(~pre_TX_STATUS && TX_STATUS)
		begin
			UART_CON2 <= 1;
		end

		//send data
		if(TX_EN && TX_STATUS) TX_EN <= 0;

		//clear after read
		if(rd && addr == 32'h40000020 && ~(~pre_RX_STATUS && RX_STATUS) && ~(~pre_TX_STATUS && TX_STATUS))
		begin
			UART_CON2 <= 0;
			UART_CON3 <= 0;
		end
		
		if(wr) begin
			case(addr)
				32'h40000000: TH <= wdata;
				32'h40000004: TL <= wdata;
				32'h40000008: TCON <= wdata[2:0];		
				32'h4000000C: led <= wdata[7:0];			
				32'h40000014: digi <= wdata[11:0];
				32'h40000018:
				begin
					UART_TXD <= wdata[7:0];
					UART_CON2 <= 0;
					TX_EN <= 1;
				end
				32'h40000020:
				begin
					UART_CON0 <= wdata[0];
					UART_CON1 <= wdata[1];
				end
				default: ;
			endcase
		end
	end
end
endmodule

