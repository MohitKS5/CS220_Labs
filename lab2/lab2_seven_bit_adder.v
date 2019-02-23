`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:34:46 01/21/2019 
// Design Name: 
// Module Name:    seven_bit_adder 
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
module full_adder(a, b, cin, sum, cout
    );
	 input a, b, cin;
	 output sum, cout;
	 wire sum, cout;
	 assign sum = a^b^cin;
	 assign cout = (a & b) | (b & cin) | (cin & a);
endmodule
module seven_bit_adder(PB1, PB2, PB3, PB4, holder ,sum,carry
    );
	input PB1,PB2, PB3, PB4;
	input [3:0] holder;
	reg [6:0] x;
	reg [6:0] y;
	wire [3:0] holder;
	always @(posedge PB1) begin
		x[3:0] <= holder[3:0];
	end
	always @(posedge PB2) begin
		x[6:4] <= holder[2:0];
	end
	always @(posedge PB3) begin
		y[3:0] <= holder[3:0];
	end
	always @(posedge PB4) begin
		y[6:4] <= holder[2:0];
	end
	output [6:0] sum;
	output carry;
	wire carry;
	wire [6:0] sum;
	wire [5:0] carrymid;
	full_adder FA0(x[0], y[0], 1'b0, sum[0], carrymid[0]);
	full_adder FA1(x[1], y[1], carrymid[0], sum[1], carrymid[1]);
	full_adder FA2(x[2], y[2], carrymid[1], sum[2], carrymid[2]);
	full_adder FA3(x[3], y[3], carrymid[2], sum[3], carrymid[3]);
	full_adder FA4(x[4], y[4], carrymid[3], sum[4], carrymid[4]);
	full_adder FA5(x[5], y[5], carrymid[4], sum[5], carrymid[5]);
	full_adder FA6(x[6], y[6], carrymid[5], sum[6], carry);
endmodule
