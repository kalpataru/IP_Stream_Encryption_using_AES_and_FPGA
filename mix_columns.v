`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:35:26 04/08/2013 
// Design Name: 
// Module Name:    mix_columns 
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
module mix_columns(in,out,ready,done,encrypt,clk,reset);

input [127:0]in;
input ready,encrypt,clk,reset;

output [127:0] out;
output done;

reg [127:0] out;
reg done;

reg [7:0] in1_1,in2_1,in3_1,in4_1,in1_2,in2_2,in3_2,in4_2,in1_3,in2_3,in3_3,in4_3,in1_4,in2_4,in3_4,in4_4;
reg ready1,ready2,ready3,ready4;

wire [7:0] out1_1,out2_1,out3_1,out4_1,out1_2,out2_2,out3_2,out4_2,out1_3,out2_3,out3_3,out4_3,out1_4,out2_4,out3_4,out4_4;
wire done1,done2,done3,done4;

word_mix_columns wmc1(in1_1,in2_1,in3_1,in4_1,out1_1,out2_1,out3_1,out4_1,ready1,done1,encrypt,clk,reset);
word_mix_columns wmc2(in1_2,in2_2,in3_2,in4_2,out1_2,out2_2,out3_2,out4_2,ready2,done2,encrypt,clk,reset);
word_mix_columns wmc3(in1_3,in2_3,in3_3,in4_3,out1_3,out2_3,out3_3,out4_3,ready3,done3,encrypt,clk,reset);
word_mix_columns wmc4(in1_4,in2_4,in3_4,in4_4,out1_4,out2_4,out3_4,out4_4,ready4,done4,encrypt,clk,reset);

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
		in1_1<=in[127:120];
		in2_1<=in[119:112];
		in3_1<=in[111:104];
		in4_1<=in[103:96];
		
		in1_2<=in[95:88];
		in2_2<=in[87:80];
		in3_2<=in[79:72];
		in4_2<=in[71:64];
		
		in1_3<=in[63:56];
		in2_3<=in[55:48];
		in3_3<=in[47:40];
		in4_3<=in[39:32];
		
		in1_4<=in[31:24];
		in2_4<=in[23:16];
		in3_4<=in[15:8];
		in4_4<=in[7:0];
		
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
		out[127:120]=out1_1;
		out[119:112]=out2_1;
		out[111:104]=out3_1;
		out[103:96]=out4_1;

		out[95:88]=out1_2;
		out[87:80]=out2_2;
		out[79:72]=out3_2;
		out[71:64]=out4_2;

		out[63:56]=out1_3;
		out[55:48]=out2_3;
		out[47:40]=out3_3;
		out[39:32]=out4_3;

		out[31:24]=out1_4;
		out[23:16]=out2_4;
		out[15:8]=out3_4;
		out[7:0]=out4_4;
		
		done=1;
	end
	else
		done=0;
end


endmodule
