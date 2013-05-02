`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:32:32 04/08/2013 
// Design Name: 
// Module Name:    sub_bytes 
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
module sub_bytes(in,out,ready,done,encrypt,clk,reset);

input [127:0]in;
input ready,encrypt,clk,reset;

output [127:0]out;
output done;

reg [127:0] out;
reg done;

reg [31:0] in1,in2,in3,in4;
reg ready1,ready2,ready3,ready4;

wire [31:0] out1,out2,out3,out4;
wire done1,done2,done3,done4;


word_sub_bytes wsb1(in1,out1,ready1,done1,encrypt,clk,reset);
word_sub_bytes wsb2(in2,out2,ready2,done2,encrypt,clk,reset);
word_sub_bytes wsb3(in3,out3,ready3,done3,encrypt,clk,reset);
word_sub_bytes wsb4(in4,out4,ready4,done4,encrypt,clk,reset);


always @(posedge clk)
begin
  if(reset)
	begin
		ready1<=0;
		ready2<=0;
		ready3<=0;
		ready4<=0;
	end
	else if(ready)
	begin
		in1<=in[127:96];
		in2<=in[95:64];
		in3<=in[63:32];
		in4<=in[31:0];
		
		ready1<=1;
		ready2<=1;
		ready3<=1;
		ready4<=1;
	end
	else
	begin
		ready1<=0;
		ready2<=0;
		ready3<=0;
		ready4<=0;	
	end
end

always @(posedge clk)
begin
	if(reset)
	begin
		done=0;
	end
	else if(done1 && done2 && done3 && done4)
	begin
		out[127:96]<=out1;
		out[95:64]<=out2;
		out[63:32]<=out3;
		out[31:0]<=out4;
		done=1;
	end
	else
		done=0;
end

endmodule

