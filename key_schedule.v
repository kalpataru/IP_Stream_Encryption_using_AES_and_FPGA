`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:27:53 04/08/2013 
// Design Name: 
// Module Name:    key_schedule 
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
module key_schedule(in,out,ready,done,round,clk,reset);

input [127:0] in;
input [3:0]round;
input ready,clk,reset;

output [127:0]out;
output done;

reg [127:0]out;
reg done;

reg [127:0]buf_in;
reg [7:0]in1,in2,in3,in4;
reg [3:0]rnd;
reg  ready1,ready2,ready3,ready4,encrypt;

wire [7:0]out1,out2,out3,out4;
wire done1,done2,done3,done4;

s_box  sbox1(in1,out1,ready1,done1,encrypt,clk,reset);
s_box  sbox2(in2,out2,ready2,done2,encrypt,clk,reset);
s_box  sbox3(in3,out3,ready3,done3,encrypt,clk,reset);
s_box  sbox4(in4,out4,ready4,done4,encrypt,clk,reset);


always @(posedge clk)
begin
  if(reset)
	begin
		encrypt=0;rnd=0;
		ready1=0;ready2=0;
		ready3=0;ready4=0;
	end
	else if(ready)
	begin
		encrypt=1;
		buf_in=in;
		rnd=round;
		in1=in[31:24];
		in2=in[23:16];
		in3=in[15:8];
		in4=in[7:0];
		ready1=1;
		ready2=1;
		ready3=1;
		ready4=1;
	end
	else
	begin
		ready1=0;
		ready2=0;
		ready3=0;
		ready4=0;
	end
end	

always @(posedge clk)
begin
	if(reset)
	begin
		done=0;
	end
	else if(done1 && done2 &&done3 && done4)
	begin
		case(rnd)
			4'h1:out[127:120]=buf_in[127:120] ^ out2 ^ 8'b00000001;
			4'h2:out[127:120]=buf_in[127:120] ^ out2 ^ 8'b00000010;
			4'h3:out[127:120]=buf_in[127:120] ^ out2 ^ 8'b00000100;
			4'h4:out[127:120]=buf_in[127:120] ^ out2 ^ 8'b00001000;
			4'h5:out[127:120]=buf_in[127:120] ^ out2 ^ 8'b00010000;
			4'h6:out[127:120]=buf_in[127:120] ^ out2 ^ 8'b00100000;
			4'h7:out[127:120]=buf_in[127:120] ^ out2 ^ 8'b01000000;
			4'h8:out[127:120]=buf_in[127:120] ^ out2 ^ 8'b10000000;
			4'h9:out[127:120]=buf_in[127:120] ^ out2 ^ 8'b00011011;
			4'ha:out[127:120]=buf_in[127:120] ^ out2 ^ 8'b00110110;
		endcase
		out[119:112]=buf_in[119:112] ^ out3;
		out[111:104]=buf_in[111:104] ^ out4;
		out[103:96]=buf_in[103:96] ^ out1;

		out[95:88]=buf_in[95:88] ^ out[127:120];
		out[87:80]=buf_in[87:80] ^ out[119:112];
		out[79:72]=buf_in[79:72] ^ out[111:104];
		out[71:64]=buf_in[71:64] ^ out[103:96];
		
		out[63:56]=buf_in[63:56] ^ out[95:88];
		out[55:48]=buf_in[55:48] ^ out[87:80];
		out[47:40]=buf_in[47:40] ^ out[79:72];
		out[39:32]=buf_in[39:32] ^ out[71:64];

		out[31:24]=buf_in[31:24] ^ out[63:56];
		out[23:16]=buf_in[23:16] ^ out[55:48];
		out[15:8]=buf_in[15:8] ^ out[47:40];
		out[7:0]=buf_in[7:0] ^ out[39:32];
		
		done=1;
	end
	else
		done=0;
end
		
endmodule

