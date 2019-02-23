`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:49:57 01/28/2019 
// Design Name: 
// Module Name:    five_adder 
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
module full_adder(a, b, cin, sum, cout);
	 input a, b, cin;
	 output sum, cout;
	 assign sum = a^b^cin;
	 assign cout = (a & b) | (b & cin) | (cin & a);
endmodule

module five_adder(PB1, PB2, PB3, PB4, PB5, holder ,sum);
	input PB1,PB2, PB3, PB4, PB5;
	input [3:0] holder;
	reg [3:0] a,b,c,d,e;
	always @(posedge PB1) begin
		a[3:0] = holder[3:0];
	end
	always @(posedge PB2) begin
		b[3:0] = holder[3:0];
	end
	always @(posedge PB3) begin
		c[3:0] = holder[3:0];
	end
	always @(posedge PB4) begin
		d[3:0] = holder[3:0];
	end
	always @(posedge PB5) begin
		e[3:0] = holder[3:0];
	end
	output [6:0] sum;
	wire [4:0] x,y;
	wire [5:0] z;
	n_bit_adder #(4) A1(a,b,x); 
	n_bit_adder #(4) A2(c,d,y); 
	n_bit_adder #(5) A3(x,y,z); 
	n_bit_adder #(6) A4(z,{2'b00,e[3:0]},sum);
endmodule

module n_bit_adder(a,b,sum);
	parameter [4:0] BS=4;
	input [BS-1:0] a,b;
	output [BS:0] sum;
	wire [BS-1:0] carrymid;
	genvar i;
	generate
		full_adder FA0(a[0], b[0], 1'b0, sum[0], carrymid[1]);
		for(i=1;i<BS-1;i=i+1) begin:block_1
			full_adder FA0(a[i], b[i], carrymid[i], sum[i], carrymid[i+1]);
		end
		full_adder FA1(a[BS-1], b[BS-1], carrymid[BS-1], sum[BS-1], sum[BS]);
	endgenerate
endmodule