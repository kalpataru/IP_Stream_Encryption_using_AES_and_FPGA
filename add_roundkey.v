`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:37:01 04/08/2013 
// Design Name: 
// Module Name:    add_roundkey 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module add_roundkey(in,out,rkey,ready,done,clk,reset);

input [127:0]in,rkey;
input ready,clk,reset;
output [127:0]out;
output done;

reg [127:0]out;
reg done;

always @(posedge clk)
begin
  if(reset)
	begin
		done<=0;
	end
	else if(ready)
	begin
		out[7:0]<=in[7:0]^rkey[7:0];
		out[15:8]<=in[15:8]^rkey[15:8];
		out[23:16]<=in[23:16]^rkey[23:16];
		out[31:24]<=in[31:24]^rkey[31:24];
		
		out[39:32]<=in[39:32]^rkey[39:32];
		out[47:40]<=in[47:40]^rkey[47:40];
		out[55:48]<=in[55:48]^rkey[55:48];
		out[63:56]<=in[63:56]^rkey[63:56];
		
		out[71:64]<=in[71:64]^rkey[71:64];
		out[79:72]<=in[79:72]^rkey[79:72];
		out[87:80]<=in[87:80]^rkey[87:80];
		out[95:88]<=in[95:88]^rkey[95:88];

		out[103:96]<=in[103:96]^rkey[103:96];
		out[111:104]<=in[111:104]^rkey[111:104];
		out[119:112]<=in[119:112]^rkey[119:112];
		out[127:120]<=in[127:120]^rkey[127:120];
		
		done<=1;
	end
	else
		done<=0;
end
endmodule 
