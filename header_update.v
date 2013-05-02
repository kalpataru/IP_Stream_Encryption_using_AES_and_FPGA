`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:25:39 04/08/2013 
// Design Name: 
// Module Name:    header_update 
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
module header_update(in,header1,direct,ready,length,padding,padding_size,done,clk,reset);

input [159:0]in;
input direct,ready,clk,reset;

output [159:0]header1;
output [15:0] length;
output [3:0] padding_size;
output done,padding;

reg [159:0]header1;
reg [15:0] length;
reg [3:0] padding_size;
reg done,padding;

reg [15:0]data_size,new_length;
reg [19:0]checksum;
reg [3:0]mod,remaining_size;

always @(posedge clk)
begin
  if(reset)
	begin
		padding=0; done=0; 
		length=0;
	end
	else if(ready)
	begin
		if(direct==0)
		begin
			header1=in;
			if((header1[109]==0) && (header1[108:96]==0))//uf:unfragmented
			begin                                    //header1[108:96]=offset
				length=header1[143:128]-20;       //header1[143:128]=length
				mod=data_size%16;
				if(mod>0)
				begin
					padding=1;
					padding_size=16-mod;//blank shift
					new_length=header1[143:128]+padding_size;
					//checksum update
					checksum=header1[159:144]+new_length+header1[127:112]+header1[111:96]+header1[95:80]+0+header1[63:48]+header1[47:32]+header1[31:16]+header1[15:0];
					checksum[15:0]=checksum[15:0]+checksum[19:16];
					checksum[15:0]=checksum[15:0] ^ 16'hffff;
					header1[79:64]=checksum[15:0];
				end
				else
				begin
					padding=0;
				end
			end
			else if((header1[109]==1) && (header1[108:96]==0))// ff: first fragment
			begin
				length=header1[143:128]-20;
				padding_size=0;
				padding=0;
				remaining_size=data_size%16;
				if(remaining_size>0)
				begin
					new_length=header1[143:128]-remaining_size;
					//checksum update
					checksum=header1[159:144]+new_length+header1[127:112]+header1[111:96]+header1[95:80]+0+header1[63:48]+header1[47:32]+header1[31:16]+header1[15:0];
					checksum[15:0]=checksum[15:0]+checksum[19:16];
					checksum[15:0]=checksum[15:0] ^ 16'hffff;
					header1[79:64]=checksum[15:0];
				end	
			end
			else if((header1[109]==1) && (header1[108:96]>0))//mf:middle fragment
			begin
				length=header1[143:128]-20;
				padding_size=0;
				padding=0;
				data_size=data_size+remaining_size;
				remaining_size=data_size%16;
				if(remaining_size>0)
				begin
					new_length=data_size-remaining_size;
					checksum=header1[159:144]+new_length+header1[127:112]+header1[111:96]+header1[95:80]+0+header1[63:48]+header1[47:32]+header1[31:16]+header1[15:0];
					checksum[15:0]=checksum[15:0]+checksum[19:16];
					checksum[15:0]=checksum[15:0] ^ 16'hffff;
					header1[79:64]=checksum[15:0];
				end
			end
			else // if((MF==0) && (offset[12:0]>0))//lf:last fragment
			begin
				length=header1[143:128]-20;
				data_size=data_size+remaining_size;
				remaining_size=data_size%16;
				if(remaining_size>0)
				begin
					padding=1;
					padding_size=16-remaining_size;//blank shift
					new_length=data_size+padding_size;
					checksum=header1[159:144]+new_length+header1[127:112]+header1[111:96]+header1[95:80]+0+header1[63:48]+header1[47:32]+header1[31:16]+header1[15:0];
					checksum[15:0]=checksum[15:0]+checksum[19:16];
					checksum[15:0]=checksum[15:0] ^ 16'hffff;
					header1[79:64]=checksum[15:0];
				end
				else
					padding=0;
			end
			done=1;
		end
		else//direct
		begin
			header1=in;
			padding=0;
			done=1;
		end
	end
	else
		done=0;
end
endmodule
