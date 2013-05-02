`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:24:43 04/08/2013 
// Design Name: 
// Module Name:    address_check 
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
module address_check(in,src,dest,direct,encrypt,address_select,ready,done,clk,reset);

input [31:0]in,src,dest;
input address_select,ready,clk,reset;

output direct,encrypt,done;

reg direct,encrypt,done;
reg [31:0]address[7:0];
reg [3:0] i;
reg p,q,r,s;

always @(posedge clk)
begin
  if(reset)
	begin
		i=0;p=0;q=0;r=0;s=0;
		done=0;direct=0;encrypt=0;
	end
	else if(address_select)
	begin
		address[i]=in;
		i=i+1;
		done=0;
	end
	else if(ready)
	begin
		if(src==address[0])
			p=1;
		else
			p=0;
		case(src)
			address[1]:q=1;
			address[2]:q=1;
			address[3]:q=1;
			address[4]:q=1;
			address[5]:q=1;
			address[6]:q=1;
			address[7]:q=1;
			default:q=0;
		endcase
		
		if(dest==address[0])
			r=1;
		else
			r=0;
		case(dest)
			address[1]:s=1;
			address[2]:s=1;
			address[3]:s=1;
			address[4]:s=1;
			address[5]:s=1;
			address[6]:s=1;
			address[7]:s=1;
			default:s=0;
		endcase
		
		if(p&&s)
		begin
			encrypt=p&s;//encryption need
			direct=0;
		end
		else if(q&&r)
		begin
			encrypt=!(q&r);//decryption need
			direct=0;
		end
		else// for any other case direct send
		begin
			direct=1;
		end
		done=1;
	end
	else
		done=0;
end
endmodule

