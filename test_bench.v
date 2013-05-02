`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:18:58 04/08/2013 
// Design Name: 
// Module Name:    test_bench 
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
module test_bench;

reg [511:0]ip;
reg [127:0]key;
reg [127:0]result;
reg [31:0]address2[7:0];
reg [7:0]in;
reg clk,rst,ready,key_select,address_select,key_enable,address_enable;

integer i,j,m,k;

wire [7:0]out;
wire done,busy;

initial
begin
    $dumpfile("test.vcd");
    $dumpvars(0,test_bench);
   
	//a[0]=128'h00112233445566778899aabbccddeeff;
	//a[1]=128'h69c4e0d86a7b0430d8cdb78070b4c55a;
	//a[2]=128'h00112233445566778899aabbccddeeff;
	//a[3]=128'h5e390f7df7a69296a7553dc10aa31f6b;
	//a[4]=128'hb692cf0b643dbdf1be9bc5006830b3fe;

	result=128'h69c4e0d86a7b0430d8cdb78070b4c55a;

	key=128'h000102030405060708090a0b0c0d0e0f;

	//ip=512'h61ca9bbf97be8b0102030405a761ca9b43c9738100112233445566778899aabbccddeeff390f7df7a69296a7553dc10aa31f6b69c4e0d86a7b0430d8cdb78070;
	ip=512'h_61ca9bbf_97be8b01_02030405_a761ca9b_43c97381__00112233445566778899aabbccddeeff_390f7df7a69296a7553dc10aa31f6b69_c4e0d86a_7b0430d8_cdb78070; //f6b69_c4e0d86a7b0430d8cdb78070f0b643db_df1be9bc863763ebd2c06721d98a0b14;

	address2[0]=32'ha761ca9b;//This is my address

	address2[1]=32'hbf97be8b;
	address2[2]=32'h5d45d8ad;
	address2[3]=32'h301a611f;
	address2[4]=32'h43c97381;
	address2[5]=32'h70b692cf;
	address2[6]=32'hbf0b643d;
	address2[7]=32'hdabdf1be;

	i=0;
	j=0;
	k=0;
	m=1;

	clk=0;
	rst=1;
	key_select=0;
	address_select=0;
	//#1200 $finish;
end


ip_send_recv isr(in,out,key_enable,address_enable,ready,busy,done,clk,rst);


always @(posedge clk)
begin
	if(rst)
	begin
		rst=0;
		key_select=1;
	end
	else if(key_select)
	begin
		in=key[127:120];
		//key[127:8]=key[119:0];
		key = {key[119:0], 8'd0};
		key_enable=1;
		address_enable=0;
		ready=0;
		i=i+1;
		if(i==16)
		begin
			i=0;
			key_select=0;
			address_select=1;
		end
	end
	else if(address_select)
	begin
		in=address2[i][31:24];
		address2[i][31:8]=address2[i][23:0];
		key_enable=0;
		address_enable=1;
		ready=0;
		j=j+1;
		if(j==4)
		begin
			j=0;
			i=i+1;
		end
		if(i==8)
		begin
			address_select=0;
			i=0;
		end
	end
	else if(!busy)
	begin
		in=ip[511:504];
		ip[511:8]=ip[503:0];
		key_enable=0;
		address_enable=0;
		ready=1;	
	end	
	else
	begin
		key_enable=0;
		address_enable=0;
		ready=0;	
	end
end

always @(posedge clk)
begin
	if(done)
	begin
		//out1=out;
		$display("\ntime=%t,in=%h,	out=%h, i=%d\n",$time,in,out,m);
		if(result==out)
			$display("\nMatch found \n");
		m=m+1;
	end
end

always
#1 clk<=~clk;

endmodule
