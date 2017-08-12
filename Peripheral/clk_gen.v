`timescale 1ns/1ps

module clk_gen(clk, reset, clko1, clko2);
input  clk;
input  reset;
output reg clko1, clko2;

//9600Hz
parameter   CNT_NUM1 = 26'd5208 - 26'd2;
//9600*16Hz
parameter   CNT_NUM2 = 26'd325 - 26'd2;

reg [25:0]  cnt1, cnt2;

//9600Hz
always @(posedge clk or negedge reset)
begin
    if(~reset) begin
        cnt1 <= 26'd0;
        clko1 <= 1'b0;
    end
    else begin
        if(cnt1>=CNT_NUM1)
            cnt1 <= 26'd0;
        else
            cnt1 <= cnt1 + 26'd2;
        
        if(cnt1==26'd0)
            clko1 <= ~clko1;
    end
end

//9600*16Hz
always @(posedge clk or negedge reset)
begin
    if(~reset) begin
        cnt2 <= 26'd0;
        clko2 <= 1'b0;
    end
    else begin
        if(cnt2>=CNT_NUM2)
            cnt2 <= 26'd0;
        else
            cnt2 <= cnt2 + 26'd2;
        
        if(cnt2==26'd0)
            clko2 <= ~clko2;
    end
end
endmodule