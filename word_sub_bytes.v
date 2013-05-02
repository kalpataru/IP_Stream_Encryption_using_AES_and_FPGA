`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:34:23 04/08/2013 
// Design Name: 
// Module Name:    word_sub_bytes 
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
module word_sub_bytes(in,out,ready,done,encrypt,clk,reset);

input [31:0] in;
input ready,encrypt,clk,reset;

output [31:0] out;
output done;

reg [31:0] out;
reg done;

reg [7:0] in1,in2,in3,in4;
reg ready1,ready2,ready3,ready4;

wire [7:0] out1,out2,out3,out4;
wire done1,done2,done3,done4;


s_box sbox1(in1,out1,ready1,done1,encrypt,clk,reset);
s_box sbox2(in2,out2,ready2,done2,encrypt,clk,reset);
s_box sbox3(in3,out3,ready3,done3,encrypt,clk,reset);
s_box sbox4(in4,out4,ready4,done4,encrypt,clk,reset);


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
		in1<=in[31:24];
		in2<=in[23:16];
		in3<=in[15:8];
		in4<=in[7:0];
		
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
		done<=0;
	end
	else if(done1 && done2 && done3 && done4)
	begin
		out[31:24]<=out1;
		out[23:16]<=out2;
		out[15:8]<=out3;
		out[7:0]<=out4;
		done<=1;
	end
	else
		done<=0;
end

endmodule

