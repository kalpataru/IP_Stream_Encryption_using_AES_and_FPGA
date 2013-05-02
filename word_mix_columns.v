`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:37:45 04/08/2013 
// Design Name: 
// Module Name:    word_mix_columns 
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
module word_mix_columns(in1,in2,in3,in4,out1,out2,out3,out4,ready,done,encrypt,clk,reset);

input [7:0]in1,in2,in3,in4;
input ready,encrypt,clk,reset;

output [7:0] out1,out2,out3,out4;
output done;

reg [7:0] out1,out2,out3,out4;
reg done,encry;

reg [7:0] mulby2,result,mulby22,mulby222,mulby9,mulby11,mulby13,mulby14,temp,temp1,temp2,temp3,temp4;
reg [7:0] mulby1_1,mulby1_2,mulby1_3,mulby1_9,mulby1_11,mulby1_13,mulby1_14;
reg [7:0] mulby2_1,mulby2_2,mulby2_3,mulby2_9,mulby2_11,mulby2_13,mulby2_14;
reg [7:0] mulby3_1,mulby3_2,mulby3_3,mulby3_9,mulby3_11,mulby3_13,mulby3_14;
reg [7:0] mulby4_1,mulby4_2,mulby4_3,mulby4_9,mulby4_11,mulby4_13,mulby4_14;
reg [7:0] mulby1_22,mulby2_22,mulby3_22,mulby4_22,mulby1_222,mulby2_222,mulby3_222,mulby4_222;


always @(posedge clk)
begin
  if(reset)
	begin
		out1=0;out2=0;out3=0;out4=0;
		done=0;encry=0;
		mulby2=0;result=0;mulby22=0;mulby222=0;mulby9=0;mulby11=0;mulby13=0;mulby14=0;temp=0;temp1=0;temp2=0;temp3=0;temp4=0;
		mulby1_1=0;mulby1_2=0;mulby1_3=0;mulby1_9=0;mulby1_11=0;mulby1_13=0;mulby1_14=0;
		mulby2_1=0;mulby2_2=0;mulby2_3=0;mulby2_9=0;mulby2_11=0;mulby2_13=0;mulby2_14=0;
		mulby3_1=0;mulby3_2=0;mulby3_3=0;mulby3_9=0;mulby3_11=0;mulby3_13=0;mulby3_14=0;
		mulby4_1=0;mulby4_2=0;mulby4_3=0;mulby4_9=0;mulby4_11=0;mulby4_13=0;mulby4_14=0;
		mulby1_22=0;mulby2_22=0;mulby3_22=0;mulby4_22=0;mulby1_222=0;mulby2_222=0;mulby3_222=0;mulby4_222=0;
	end
	else if(ready)
	begin
		temp1=in1;
		temp2=in2;
		temp3=in3;
		temp4=in4;
		
		if(encrypt)
		begin
		//----------------------------------------1
			//mulby1_1=in1;
			mulby1_2[7:1]=in1[6:0];
			mulby1_2[0]=1'b0;		
			if(in1[7])
				mulby1_2=mulby1_2^8'h1b;
			mulby1_3=mulby1_2^in1[7:0];
			
			//----------------------------------------2			
			//mulby2_1=in2;
			mulby2_2[7:1]=in2[6:0];
			mulby2_2[0]=1'b0;
			if(in2[7])
				mulby2_2=mulby2_2^8'h1b;
			mulby2_3=mulby2_2^in2;
			
			//---------------------------------------3			
			//mulby3_1=in3;
			mulby3_2[7:1]=in3[6:0];
			mulby3_2[0]=1'b0;
			if(in3[7])
				mulby3_2=mulby3_2^8'h1b;
			mulby3_3=mulby3_2^in3;
			
			//---------------------------------------4			
			//mulby4_1=in4;
			mulby4_2[7:1]=in4[6:0];
			mulby4_2[0]=1'b0;
			if(in4[7])
				mulby4_2=mulby4_2^8'h1b;
			mulby4_3=mulby4_2^in4;
			
			out1=mulby1_2 ^ mulby2_3 ^ in3 ^ in4;
			out2=in1 ^ mulby2_2 ^ mulby3_3 ^ in4;
			out3=in1 ^ in2 ^ mulby3_2 ^ mulby4_3;
			out4=mulby1_3 ^ in2 ^ in3 ^ mulby4_2;
			done=1;
		end
		else
		begin
//***************************************************************************************temp1
			mulby1_2[7:1]=in1[6:0];
			mulby1_2[0]=1'b0;
			if(in1[7])
				mulby1_2=mulby1_2^8'h1b;//------------mulby1_2
			mulby1_22[7:1]=mulby1_2[6:0];
			mulby1_22[0]=1'b0;
			if(mulby1_2[7])
				mulby1_22=mulby1_22^8'h1b;//----------mulby1_22
			mulby1_222[7:1]=mulby1_22[6:0];
			mulby1_222[0]=1'b0;
			if(mulby1_22[7])
				mulby1_222=mulby1_222^8'h1b;//---------mulby1_222
			mulby1_9=mulby1_222^in1;//---------------------mulby1_9


			mulby1_2[7:1]=in1[6:0];
			mulby1_2[0]=1'b0;
			if(in1[7])
				mulby1_2=mulby1_2^8'h1b;//------------mulby1_2
			mulby1_22[7:1]=mulby1_2[6:0];
			mulby1_22[0]=1'b0;
			if(mulby1_2[7])
				mulby1_22=mulby1_22^8'h1b;//----------mulby1_22
			mulby1_22=mulby1_22^in1;
			mulby1_222[7:1]=mulby1_22[6:0];
			mulby1_222[0]=1'b0;
			if(mulby1_22[7])
				mulby1_222=mulby1_222^8'h1b;//---------mulby1_222
			mulby1_11=mulby1_222^in1;//---------------------mulby1_11	
			
			
			mulby1_2[7:1]=in1[6:0];
			mulby1_2[0]=1'b0;
			if(in1[7])
				mulby1_2=mulby1_2^8'h1b;//------------mulby1_2
			mulby1_2=mulby1_2^in1;
			mulby1_22[7:1]=mulby1_2[6:0];
			mulby1_22[0]=1'b0;
			if(mulby1_2[7])
				mulby1_22=mulby1_22^8'h1b;//----------mulby1_22
			mulby1_222[7:1]=mulby1_22[6:0];
			mulby1_222[0]=1'b0;
			if(mulby1_22[7])
				mulby1_222=mulby1_222^8'h1b;//---------mulby1_222
			mulby1_13=mulby1_222^in1;//--------------------mulby1_13	
			
			
			mulby1_2[7:1]=in1[6:0];
			mulby1_2[0]=1'b0;
			if(in1[7])
				mulby1_2=mulby1_2^8'h1b;//------------mulby1_2
			mulby1_2=mulby1_2^in1;
			mulby1_22[7:1]=mulby1_2[6:0];
			mulby1_22[0]=1'b0;
			if(mulby1_2[7])
				mulby1_22=mulby1_22^8'h1b;//----------mulby1_22
			mulby1_22=mulby1_22^in1;
			mulby1_14[7:1]=mulby1_22[6:0];
			mulby1_14[0]=1'b0;
			if(mulby1_22[7])
				mulby1_14=mulby1_14^8'h1b;//---------------------mulby1_14
				
//***************************************************************************************temp2
			mulby2_2[7:1]=in2[6:0];
			mulby2_2[0]=1'b0;
			if(in2[7])
				mulby2_2=mulby2_2^8'h1b;//------------mulby2_2
			mulby2_22[7:1]=mulby2_2[6:0];
			mulby2_22[0]=1'b0;
			if(mulby2_2[7])
				mulby2_22=mulby2_22^8'h1b;//----------mulby2_22
			mulby2_222[7:1]=mulby2_22[6:0];
			mulby2_222[0]=1'b0;
			if(mulby2_22[7])
				mulby2_222=mulby2_222^8'h1b;//---------mulby2_222
			mulby2_9=mulby2_222^in2;//---------------------mulby2_9


			mulby2_2[7:1]=in2[6:0];
			mulby2_2[0]=1'b0;
			if(in2[7])
				mulby2_2=mulby2_2^8'h1b;//------------mulby2_2
			mulby2_22[7:1]=mulby2_2[6:0];
			mulby2_22[0]=1'b0;
			if(mulby2_2[7])
				mulby2_22=mulby2_22^8'h1b;//----------mulby2_22
			mulby2_22=mulby2_22^in2;
			mulby2_222[7:1]=mulby2_22[6:0];
			mulby2_222[0]=1'b0;
			if(mulby2_22[7])
				mulby2_222=mulby2_222^8'h1b;//---------mulby2_222
			mulby2_11=mulby2_222^in2;//---------------------mulby2_11	


			mulby2_2[7:1]=in2[6:0];
			mulby2_2[0]=1'b0;
			if(in2[7])
				mulby2_2=mulby2_2^8'h1b;//------------mulby2_2
			mulby2_2=mulby2_2^in2;
			mulby2_22[7:1]=mulby2_2[6:0];
			mulby2_22[0]=1'b0;
			if(mulby2_2[7])
				mulby2_22=mulby2_22^8'h1b;//----------mulby2_22
			mulby2_222[7:1]=mulby2_22[6:0];
			mulby2_222[0]=1'b0;
			if(mulby2_22[7])
				mulby2_222=mulby2_222^8'h1b;//---------mulby2_222
			mulby2_13=mulby2_222^in2;//--------------------mulby2_13	
			
			mulby2_2[7:1]=in2[6:0];
			mulby2_2[0]=1'b0;
			if(in2[7])
				mulby2_2=mulby2_2^8'h1b;//------------mulby2_2
			mulby2_2=mulby2_2^in2;
			mulby2_22[7:1]=mulby2_2[6:0];
			mulby2_22[0]=1'b0;
			if(mulby2_2[7])
				mulby2_22=mulby2_22^8'h1b;//----------mulby2_22
			mulby2_22=mulby2_22^in2;
			mulby2_14[7:1]=mulby2_22[6:0];
			mulby2_14[0]=1'b0;
			if(mulby2_22[7])
				mulby2_14=mulby2_14^8'h1b;//---------------------mulby2_14

//***************************************************************************************temp3
			mulby3_2[7:1]=in3[6:0];
			mulby3_2[0]=1'b0;
			if(in3[7])
				mulby3_2=mulby3_2^8'h1b;//------------mulby3_2
			mulby3_22[7:1]=mulby3_2[6:0];
			mulby3_22[0]=1'b0;
			if(mulby3_2[7])
				mulby3_22=mulby3_22^8'h1b;//----------mulby3_22
			mulby3_222[7:1]=mulby3_22[6:0];
			mulby3_222[0]=1'b0;
			if(mulby3_22[7])
				mulby3_222=mulby3_222^8'h1b;//---------mulby3_222
			mulby3_9=mulby3_222^in3;//---------------------mulby3_9


			mulby3_2[7:1]=in3[6:0];
			mulby3_2[0]=1'b0;
			if(in3[7])
				mulby3_2=mulby3_2^8'h1b;//------------mulby3_2
			mulby3_22[7:1]=mulby3_2[6:0];
			mulby3_22[0]=1'b0;
			if(mulby3_2[7])
				mulby3_22=mulby3_22^8'h1b;//----------mulby3_22
			mulby3_22=mulby3_22^in3;
			mulby3_222[7:1]=mulby3_22[6:0];
			mulby3_222[0]=1'b0;
			if(mulby3_22[7])
				mulby3_222=mulby3_222^8'h1b;//---------mulby3_222
			mulby3_11=mulby3_222^in3;//---------------------mulby3_11	

			mulby3_2[7:1]=in3[6:0];
			mulby3_2[0]=1'b0;
			if(in3[7])
				mulby3_2=mulby3_2^8'h1b;//------------mulby3_2
			mulby3_2=mulby3_2^in3;
			mulby3_22[7:1]=mulby3_2[6:0];
			mulby3_22[0]=1'b0;
			if(mulby3_2[7])
				mulby3_22=mulby3_22^8'h1b;//----------mulby3_22
			mulby3_222[7:1]=mulby3_22[6:0];
			mulby3_222[0]=1'b0;
			if(mulby3_22[7])
				mulby3_222=mulby3_222^8'h1b;//---------mulby3_222
			mulby3_13=mulby3_222^in3;//--------------------mulby3_13	
			
			mulby3_2[7:1]=in3[6:0];
			mulby3_2[0]=1'b0;
			if(in3[7])
				mulby3_2=mulby3_2^8'h1b;//------------mulby3_2
			mulby3_2=mulby3_2^in3;
			mulby3_22[7:1]=mulby3_2[6:0];
			mulby3_22[0]=1'b0;
			if(mulby3_2[7])
				mulby3_22=mulby3_22^8'h1b;//----------mulby3_22
			mulby3_22=mulby3_22^in3;
			mulby3_14[7:1]=mulby3_22[6:0];
			mulby3_14[0]=1'b0;
			if(mulby3_22[7])
				mulby3_14=mulby3_14^8'h1b;//---------------------mulby3_14				
//***************************************************************************************temp4
			mulby4_2[7:1]=in4[6:0];
			mulby4_2[0]=1'b0;
			if(in4[7])
				mulby4_2=mulby4_2^8'h1b;//------------mulby4_2
			mulby4_22[7:1]=mulby4_2[6:0];
			mulby4_22[0]=1'b0;
			if(mulby4_2[7])
				mulby4_22=mulby4_22^8'h1b;//----------mulby4_22
			mulby4_222[7:1]=mulby4_22[6:0];
			mulby4_222[0]=1'b0;
			if(mulby4_22[7])
				mulby4_222=mulby4_222^8'h1b;//---------mulby4_222
			mulby4_9=mulby4_222^in4;//---------------------mulby4_9


			mulby4_2[7:1]=in4[6:0];
			mulby4_2[0]=1'b0;
			if(in4[7])
				mulby4_2=mulby4_2^8'h1b;//------------mulby4_2
			mulby4_22[7:1]=mulby4_2[6:0];
			mulby4_22[0]=1'b0;
			if(mulby4_2[7])
				mulby4_22=mulby4_22^8'h1b;//----------mulby4_22
			mulby4_22=mulby4_22^in4;
			mulby4_222[7:1]=mulby4_22[6:0];
			mulby4_222[0]=1'b0;
			if(mulby4_22[7])
				mulby4_222=mulby4_222^8'h1b;//---------mulby4_222
			mulby4_11=mulby4_222^in4;//---------------------mulby4_11	

			mulby4_2[7:1]=in4[6:0];
			mulby4_2[0]=1'b0;
			if(in4[7])
				mulby4_2=mulby4_2^8'h1b;//------------mulby4_2
			mulby4_2=mulby4_2^in4;
			mulby4_22[7:1]=mulby4_2[6:0];
			mulby4_22[0]=1'b0;
			if(mulby4_2[7])
				mulby4_22=mulby4_22^8'h1b;//----------mulby4_22
			mulby4_222[7:1]=mulby4_22[6:0];
			mulby4_222[0]=1'b0;
			if(mulby4_22[7])
				mulby4_222=mulby4_222^8'h1b;//---------mulby4_222
			mulby4_13=mulby4_222^in4;//--------------------mulby4_13	
			
			mulby4_2[7:1]=in4[6:0];
			mulby4_2[0]=1'b0;
			if(in4[7])
				mulby4_2=mulby4_2^8'h1b;//------------mulby4_2
			mulby4_2=mulby4_2^in4;
			mulby4_22[7:1]=mulby4_2[6:0];
			mulby4_22[0]=1'b0;
			if(mulby4_2[7])
				mulby4_22=mulby4_22^8'h1b;//----------mulby4_22
			mulby4_22=mulby4_22^in4;
			mulby4_14[7:1]=mulby4_22[6:0];
			mulby4_14[0]=1'b0;
			if(mulby4_22[7])
				mulby4_14=mulby4_14^8'h1b;//---------------------mulby4_14
				
//**************************************************************************xor operation

			out1=mulby1_14 ^ mulby2_11 ^ mulby3_13 ^ mulby4_9;
			out2=mulby1_9 ^ mulby2_14 ^ mulby3_11 ^ mulby4_13;
			out3=mulby1_13 ^ mulby2_9 ^ mulby3_14 ^ mulby4_11;
			out4=mulby1_11 ^ mulby2_13 ^ mulby3_9 ^ mulby4_14;
		
			done=1;
		end
	end
	else
		done=0;
end

endmodule

