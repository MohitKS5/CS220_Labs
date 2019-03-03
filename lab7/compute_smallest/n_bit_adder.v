`timescale 1ns / 1ps

module full_adder(a, b, cin, sum, cout);
	 input a, b, cin;
	 output sum, cout;
	 assign sum = a^b^cin;
	 assign cout = (a & b) | (b & cin) | (cin & a);
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