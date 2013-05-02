`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:29:53 04/08/2013 
// Design Name: 
// Module Name:    s_box 
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
module s_box(in,out,ready,done,encrypt,clk,reset);

input [7:0]in;
input ready,encrypt,clk,reset;

output [7:0]out;
output done;

reg [7:0]out;
reg done;

reg [7:0]t1,t2,t3,t4,t5,t6;
reg [3:0]p,p1,p2,p21,q,q1,q2,x,y;
reg [1:0]a,a1,a2,b,b1,b2,b3,c,c1,d,d1,d2,f,f1,f2,f3,g,g1,g2,h,h1,h2,e,e1,e2,i,i1,i2,j,j1,j2,j3,m,m1,m2,l,l1,l2,s,t;
reg encry;

always @(posedge clk)
begin
  if(reset)
	begin
		encry=0;
	end
	else if(ready)
	begin
		//Mux-1
		encry=encrypt;
		if(encrypt)
		begin
			t1=in;
		end
		else
		begin
			//Inverse Affine Transformation
			t1[7]=in[6]^in[4]^in[1];
			t1[6]=in[5]^in[3]^in[0];
			t1[5]=in[7]^in[4]^in[2];
			t1[4]=in[6]^in[3]^in[1];
			t1[3]=in[5]^in[2]^in[0];
			t1[2]=in[7]^in[4]^in[1];
			t1[1]=in[6]^in[3]^in[0];
			t1[0]=in[7]^in[5]^in[2];
			t1=t1^8'h05;
		end
	// Multiplicative Inversion
		//Isomorphic mapping to Composite Fields
		t2[7]=t1[7]^t1[5];
		t2[6]=t1[7]^t1[6]^t1[4]^t1[3]^t1[2]^t1[1];
		t2[5]=t1[7]^t1[5]^t1[3]^t1[2];
		t2[4]=t1[7]^t1[5]^t1[3]^t1[2]^t1[1];
		t2[3]=t1[7]^t1[6]^t1[2]^t1[1];
		t2[2]=t1[7]^t1[4]^t1[3]^t1[2]^t1[1];
		t2[1]=t1[6]^t1[4]^t1[1];
		t2[0]=t1[6]^t1[1]^t1[0];

		//Spliting from a 8bit reg to two 4bit reg(higher and lower part) using the formula "bx+c"
		p=t2[7:4];
		q=t2[3:0];
		//Adition operation in GF(2^4)
		q1=p^q;
		
		//Squareing  in GF(2^4)
		p1[3]=p[3];
		p1[2]=p[3]^p[2];
		p1[1]=p[2]^p[1];
		p1[0]=p[3]^p[1]^p[0];
		
		//Multiplication with constant lambda in GF(2^4)
		p2[3]=p1[2]^p1[0];
		p2[2]=p1[3]^p1[2]^p1[1]^p1[0];
		p2[1]=p1[3];
		p2[0]=p1[2];
		//Multiplication Operation in GF(2^4)-----1
	
		a=q1[3:2];
		b=q1[1:0];
		c=q[3:2];
		d=q[1:0];
		
		a1[1]=(a[1]^a[0])&(c[1]^c[0])^(a[0]&c[0]);
		a1[0]=(a[1]&c[1])^(a[0]&c[0]);
		a2[1]=a1[1]^a1[0];
		a2[0]=a1[1];
		
		b1=a^b;
		c1=c^d;
		b2[1]=(b1[1]^b1[0])&(c1[1]^c1[0])^(b1[0]&c1[0]);
		b2[0]=(b1[1]&c1[1])^(b1[0]&c1[0]);
		
		d1[1]=(b[1]^b[0])&(d[1]^d[0])^(b[0]&d[0]);
		d1[0]=(b[1]&d[1])^(b[0]&d[0]);

		p21=p2;

		q2[3:2]=b2^d1;
		q2[1:0]=a2^d1;
		//xor operation
		t3=p21^q2;
		
		//Multiplicative Inversion in GF(2^4)
		t4[3]=t3[3]^t3[3]&t3[2]&t3[1]^t3[3]&t3[0]^t3[2];
		t4[2]=t3[3]&t3[2]&t3[1]^t3[3]&t3[2]&t3[0]^t3[3]&t3[0]^t3[2]^t3[2]&t3[1];
		t4[1]=t3[3]^t3[3]&t3[2]&t3[1]^t3[3]&t3[1]&t3[0]^t3[2]^t3[2]&t3[0]^t3[1];
		t4[0]=t3[3]&t3[2]&t3[1]^t3[3]&t3[2]&t3[0]^t3[3]&t3[1]^t3[3]&t3[1]&t3[0]^t3[3]&t3[0]^t3[2]^t3[2]&t3[1]^t3[2]&t3[1]&t3[0]^t3[1]^t3[0];
		
	
		//Multiplication Operation in GF(2^4)-----2
		e=p[3:2];
		f=p[1:0];
		g=t4[3:2];
		h=t4[1:0];
		e1[1]=(e[1]^e[0])&(g[1]^g[0])^(e[0]&g[0]);
		e1[0]=(e[1]&g[1])^(e[0]&g[0]);
		e2[1]=e1[1]^e1[0];
		e2[0]=e1[1];
		
		f1=e^f;
		g1=g^h;
		f2[1]=(f1[1]^f1[0])&(g1[1]^g1[0])^(f1[0]&g1[0]);
		f2[0]=(f1[1]&g1[1])^(f1[0]&g1[0]);
		
		h1[1]=(f[1]^f[0])&(h[1]^h[0])^(f[0]&h[0]);
		h1[0]=(f[1]&h[1])^(f[0]&h[0]);
		
		f3=f2^h1;
		h2=e2^h1;
			
		x[3:2]=f3;
		x[1:0]=h2;
		//iultiplimitimj mperitimj ij GF(2^4)-----3
		i=t4[3:2];
		j=t4[1:0];
		m=q1[3:2];
		l=q1[1:0];
		
		i1[1]=(i[1]^i[0])&(m[1]^m[0])^(i[0]&m[0]);
		i1[0]=(i[1]&m[1])^(i[0]&m[0]);
		i2[1]=i1[1]^i1[0];
		i2[0]=i1[1];
		
		j1=i^j;
		m1=m^l;
		j2[1]=(j1[1]^j1[0])&(m1[1]^m1[0])^(j1[0]&m1[0]);
		j2[0]=(j1[1]&m1[1])^(j1[0]&m1[0]);
		
		l1[1]=(j[1]^j[0])&(l[1]^l[0])^(j[0]&l[0]);
		l1[0]=(j[1]&l[1])^(j[0]&l[0]);
		
		j3=j2^l1;
		l2=i2^l1;
		
		y[3:2]=j3;
		y[1:0]=l2;

		//Combining from two 4bit reg(higher and lower part) to a 8bit reg
		t5[7:4]=x;
		t5[3:0]=y;
		
		//Inverse Isomorphic mapping to GF(2^8)
		t6[7]=t5[7]^t5[6]^t5[5]^t5[1];
		t6[6]=t5[6]^t5[2];
		t6[5]=t5[6]^t5[5]^t5[1];
		t6[4]=t5[6]^t5[5]^t5[4]^t5[2]^t5[1];
		t6[3]=t5[5]^t5[4]^t5[3]^t5[2]^t5[1];
		t6[2]=t5[7]^t5[4]^t5[3]^t5[2]^t5[1];
		t6[1]=t5[5]^t5[4];
		t6[0]=t5[6]^t5[5]^t5[4]^t5[2]^t5[0];

		//Mux-2
		if(encry)
		begin
			//Affine Transformation
			out[7]=t6[7]^t6[6]^t6[5]^t6[4]^t6[3];
			out[6]=t6[6]^t6[5]^t6[4]^t6[3]^t6[2];
			out[5]=t6[5]^t6[4]^t6[3]^t6[2]^t6[1];
			out[4]=t6[4]^t6[3]^t6[2]^t6[1]^t6[0];
			out[3]=t6[7]^t6[3]^t6[2]^t6[1]^t6[0];
			out[2]=t6[7]^t6[6]^t6[2]^t6[1]^t6[0];
			out[1]=t6[7]^t6[6]^t6[5]^t6[1]^t6[0];
			out[0]=t6[7]^t6[6]^t6[5]^t6[4]^t6[0];
			out=out^8'h63;
			done=1;
		end
		else
		begin
			out=t6;
			done=1;
		end
	end
	else
		done=0;
end
endmodule
