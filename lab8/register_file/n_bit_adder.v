module full_adder(a, b, cin, sum, cout);
	 input a, b, cin;
	 output sum, cout;
	 assign sum = a^b^cin;
	 assign cout = (a & b) | (b & cin) | (cin & a);
endmodule
// n-bit full adder
module n_bit_adder(a,b,cin,sum,overflow);
	parameter [4:0] BS=4;
	input [BS-1:0] a,b;
	input cin;
	output [BS:0] sum;
	output overflow;
	wire [BS-1:0] carrymid;
	genvar i;
	generate
		full_adder FA0(a[0], cin^b[0], cin, sum[0], carrymid[1]);
		for(i=1;i<BS-1;i=i+1) begin:block_1
			full_adder FA0(a[i], cin^b[i], carrymid[i], sum[i], carrymid[i+1]);
		end
		full_adder FA1(a[BS-1], cin^b[BS-1], carrymid[BS-1], sum[BS-1], sum[BS]);
	endgenerate
	assign overflow = sum[BS]^carrymid[BS-1];
endmodule