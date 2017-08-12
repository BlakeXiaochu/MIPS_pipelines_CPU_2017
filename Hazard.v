`timescale 1ns/1ps

module Hazard(
	ID_EX_MemRd,
	ID_EX_Rt,
	IF_ID_Rs,
	IF_ID_Rt,

	stall
	);

input ID_EX_MemRd;
input [4:0] ID_EX_Rt;
input [4:0] IF_ID_Rs;
input [4:0] IF_ID_Rt;

output reg stall;

always @(*)
begin
	if(ID_EX_MemRd && ((ID_EX_Rt == IF_ID_Rs) || (ID_EX_Rt == IF_ID_Rt)))
		stall <= 1;
	else stall <= 0;
end

endmodule