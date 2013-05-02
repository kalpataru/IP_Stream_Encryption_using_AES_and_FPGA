`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:26:50 04/08/2013 
// Design Name: 
// Module Name:    aes 
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
module aes(in,out,key,ready,done,encrypt,clk,reset);

input [127:0] in,key;
input ready,encrypt,clk,reset;

output [127:0] out;
output done;

reg [127:0] out,tout;
reg done,tdone;

reg [127:0]key_buff[10:0];
reg [127:0]in1,in2,key_in,key_temp,state,state0;
reg [3:0]round,round2;
reg ready1,ready2,encry,flag1,flag2,flag3;
integer i;

wire [127:0] out1,out2;
wire done1,done2;


key_schedule  ks(in1,out1,ready1,done1,round,clk,reset);
stage2 s2(in2,out2,key_in,round2,ready2,done2,encry,clk,reset);


always @(posedge clk)
begin
	if(reset)
	begin
		flag1=0;
		encry=0;
	end
	else if(ready)
	begin
		encry=encrypt;
		state=in;
		key_temp=key;
		flag1=1;
	end
	else
		flag1=0;
end

always @(posedge clk)
begin
	if(reset)
	begin
		ready1=0;round=0;
		flag2=0;i=0;
	end
	else if(flag1)
	begin
		in1=key_temp;
		round=1;
		ready1=1;
		flag2=0;
	end
	else if(done1)
	begin
		key_buff[round]=out1;
		if(round<10)
		begin
			in1=out1;
			round=round+1;
			ready1=1;
			flag2=0;
		end
		else
		begin
			ready1=0;
			key_buff[0]=key_temp;
			flag2=1;
			i=11;
		end
	end
	else
	begin
		ready1=0;
		flag2=0;
	end
end
	
//********************************************************
always @(posedge clk)
begin
	if(reset)
	begin
		flag3=0;
	end
	else if(flag2)
	begin
		if(encry)
		begin
			state0=state^key_buff[0];
		end
		else
		begin
			state0=state^key_buff[10];
		end
		flag3=1;
	end
	else
		flag3=0;
end

//*****************************************************
always @(posedge clk)
begin
	if(reset)
	begin
		round2=0;ready2=0;
		done=0;
	end
	else if(flag3)
	begin
		if(encry)
		begin
			in2=state0;
			round2=1;
			key_in=key_buff[round2];
			ready2=1;
			done=0;
		end
		else
		begin
			in2=state0;
			round2=1;
			key_in=key_buff[10-round2];
			ready2=1;
			done=0;
		end
	end
	else if(done2)
	begin
		if(encry)
		begin
			if(round2<10)
			begin
				in2=out2;
				round2=round2+1;
				key_in=key_buff[round2];
				ready2=1;
				done=0;	
			end
			else
			begin
				out=out2;
				done=1;
				ready2=0;
			end
		end
		else
		begin
			if(round2<10)
			begin
				in2=out2;
				round2=round2+1;
				key_in=key_buff[10-round2];
				ready2=1;
				done=0;	
			end
			else
			begin
				out=out2;
				done=1;
				ready2=0;
			end
		end
	end
	else
	begin
		ready2=0;
		done=0;
	end
end

endmodule 
