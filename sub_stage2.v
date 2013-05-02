`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:31:38 04/08/2013 
// Design Name: 
// Module Name:    sub_stage2 
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
module sub_stage2(in,out,key,round,ready,done,encrypt,clk,reset);

input [127:0] in,key;
input [3:0]round;
input ready,encrypt,clk,reset;

output [127:0] out;
output done;

reg [127:0] out;
reg done;

reg [127:0]in1,in2,rkey,temp;
reg [3:0]rnd;
reg ready1,ready2,encry,flag1;

wire [127:0] out1,out2;
wire done1,done2;


mix_columns  	mc(in1,out1,ready1,done1,encry,clk,reset);
add_roundkey	ak(in2,out2,rkey,ready2,done2,clk,reset);


// For encryption
always @(posedge clk)
begin
	if(reset)
	begin
		encry=0;rnd=0;
		flag1=0;ready1=0;
		ready2=0;done=0;
	end
	else if(ready)
	begin
		encry=encrypt;
		rkey=key;
		rnd=round;
		if(encrypt)
		begin
			if(round<10)
			begin
				in1=in;
				flag1=0;
				ready1=1;
				done=0;
				ready2=0;
			end
			else
			begin
				temp=in;
				flag1=1;
				ready1=0;
				done=0;
				ready2=0;
			end	
		end
		else
		begin
			in2=in;
			ready2=1;
			done=0;
			ready1=0;
			flag1=0;
		end
	end
	else if(done2)
	begin
		if(encry)
		begin
			out=out2;
			done=1;
			ready1=0;
			ready2=0;
			flag1=0;
		end
		else
		begin
			if(round<10)
			begin
				in1=out2;
				flag1=0;
				ready1=1;
				done=0;
				ready2=0;
			end
			else
			begin
				temp=out2;
				flag1=1;
				ready1=0;
				done=0;
				ready2=0;
			end	
		end
	end
	else if(flag1)
	begin
		if(encry)
		begin
			in2=temp;
			ready2=1;
			done=0;
			ready1=0;
			flag1=0;
		end
		else
		begin
			out=temp;
			done=1;
			ready1=0;
			ready2=0;
			flag1=0;
		end
	end
	else if(done1)
	begin
		if(encry)
		begin
			in2=out1;
			ready2=1;
			done=0;
			ready1=0;
			flag1=0;
		end
		else
		begin
			out=out1;
			done=1;
			ready1=0;
			ready2=0;
			flag1=0;
		end
	end	
	else
	begin
		done=0;
		ready1=0;
		ready2=0;
		flag1=0;
	end
end
endmodule

