`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:23:22 04/08/2013 
// Design Name: 
// Module Name:    IP_send_recv 
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
module ip_send_recv(in,out,key_select,address_select,ready,h_busy,done,clk,reset);
input [7:0]in;
input key_select,address_select,ready,clk,reset;

output [7:0]out;
output done,h_busy;

reg [7:0] out,temp_in;
reg done,h_busy;

reg [159:0]header,header_out;
reg [127:0]key,data,temp2,in1,aes_out,in4;
reg [15:0]b_count;
reg [31:0]address,src,dest;
reg [7:0] h_count,direct_count,header_count,aes_count,aes_count2,busy_count,count,pbusy_count,padding_count;
reg [1:0] i;

reg encrypt,direct;
reg address_enable,ready1,ready2,ready3,ready4;
reg flag1,flag2,flag3,flag4,f2,body,d,f,direct_out,flag5,flag6;

wire [159:0]out2;
wire [127:0]out1,out4;
wire [15:0]length;
wire [3:0]padding_size;
wire done1,done2,done3,encry,dir,done4,padding;

address_check   ac(address,src,dest,dir,encry,address_enable,ready3,done3,clk,reset);
header_update	hu(header,out2,direct,ready2,length,padding,padding_size,done2,clk,reset);
aes			  aes1(in1,out1,key,ready1,done1,encrypt,clk,reset);

//for address select
always @(posedge clk)
begin
	if(reset)
	begin
		address_enable=0;address=0;
		i=0;
	end
	else if(address_select)
	begin
		address[31:8]=address[23:0];
		address[7:0]=in;
		i=i+1;
		if(i==0)
		begin
			address_enable=1;
		end
		else
			address_enable=0;
	end
	else
		address_enable=0;
end

//for key select
always @(posedge clk)
begin
	if(reset)
	begin
		key=0;
	end
	else if(key_select)
	begin
		key[127:8]=key[119:0];
		key[7:0]=in;
	end
	else
		key=key;
end

//for header and body and padding part select
always @(posedge clk)
begin
	if(reset)
	begin
		flag5=0;flag1=0;body=0;h_count=0;ready3=0;ready1=0;
		b_count=0;aes_count=0;padding_count=0;flag6=0;
		header=0;src=0;dest=0;data=0;in1=0;
	end
//*******************************************************************************************
	else if(ready && !body)  // header part coming
	begin
		flag5=0;
		header[159:8]=header[151:0];
		//header=header<<8;
		header[7:0]=in;
		h_count=h_count+1;		
		if(h_count==19)
			flag1=1;
		else
			flag1=0;
			
		if(h_count==20)
		begin
			body=1;
			h_count=0;
			src=header[63:32];
			dest=header[31:0];
			ready3=1;
		end
		else
			ready3=0;
		ready1=0;
	end
//******************************************************************************************	
	else if(ready && body) // body part coming
	begin
		b_count=b_count+1;
		if(!direct)// for encrypt/decrypt
		begin
			data[127:8]=data[119:0];
			data[7:0]=in;
			aes_count=aes_count+1;
			if(aes_count==16)
			begin
				aes_count=0;
				in1=data;
				ready1=1;
			end
			else
				ready1=0;
		end
		else
			ready1=0;
		if(b_count==length-1)
		begin
			if(padding)
				flag5=1;
			else
				flag5=0;
		end
		if(b_count==length)
		begin
			body=0;
			if(padding)
				flag6=1;
			else
				flag6=0;
		end						
		ready3=0;
		flag1=0;
	end
//*****************************************************************************************
	else if(flag6) // // For padding in last fragment if not divisible
	begin
		data[127:8]=data[119:0];
		data[7:0]=8'h00;
		aes_count=aes_count+1;
		if(aes_count==16)
		begin
			aes_count=0;
			in1=data;
			ready1=1;
		end
		else
			ready1=0;
		padding_count=padding_count+1;
		if(padding_count==padding_size)
		begin
			padding_count=0;
			flag6=0;
		end
	end
	else
	begin
		ready1=0;
		ready3=0;
		flag1=0;
		flag5=0;
		flag6=0;
	end
end



//for h_busy
always @(posedge clk)
begin
	if(reset)
	begin
		h_busy=0;pbusy_count=0;
		busy_count=0;count=0;
	end
	else if(flag1)
	begin
		h_busy=1;
	end
	else if(done3)
	begin
		if(dir)
		begin
			busy_count=20;
		end
		else
		begin
			h_busy=0;
			busy_count=0;
		end
	end
	else if(busy_count>0)
	begin
		busy_count=busy_count-1;
		if(busy_count==0)
			h_busy=0;
	end
	else if(ready1)
	begin
		count=14;
	end
	else if(count>0)
	begin
		count=count-1;
		if(count==0)
			h_busy=1;
	end
	else if(done1)
	begin
		h_busy=0;
	end
	else if(flag5)
	begin
		h_busy=1;
		pbusy_count=padding_size;
	end
	else if(pbusy_count>0)
	begin
		pbusy_count=pbusy_count-1;
			if(pbusy_count==0)
				h_busy=0;
	end
end

//for receiving from address_check and activating header_update
always @(posedge clk)
begin
	if(reset)
	begin
		direct=0;
		encrypt=0;
		ready2=0;
	end
	else if(done3)
	begin
		if(dir)
			direct=1;
		else
		begin
			direct=0;
			encrypt=encry;
		end
		ready2=1;
	end
	else
		ready2=0;
end

//for receiving from header_update, aes or direct and sending output
always @(posedge clk)
begin
	if(reset)
	begin
		header_count=0;done=0;out=0;
		direct_out=0;aes_count2=0;
		header_out=0;out=0;aes_out=0;
	end
	else if(done2)
	begin
		header_out=out2;
		out=header_out[159:152];
		done=1;
		header_count=19;
		if(direct)
			direct_out=1;
		else
			direct_out=0;
	end
	else if(header_count>0)
	begin
		header_out[159:8]=header_out[151:0];
		out=header_out[159:152];
		done=1;
		header_count=header_count-1;
	end
	else if(done1)
	begin
		aes_out=out1;
		out=aes_out[127:120];
		done=1;
		aes_count2=15;
	end
	else if(aes_count2>0)
	begin
		aes_out[127:8]=aes_out[119:0];
		out=aes_out[127:120];
		done=1;
		aes_count2=aes_count2-1;
	end
	else if(direct_out)
	begin
		out=in;
		done=1;
	end
	else
	begin
		header_count=0;
		aes_count2=0;
		done=0;
	end
end

endmodule
