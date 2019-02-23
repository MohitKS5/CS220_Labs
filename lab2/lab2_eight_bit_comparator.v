`timescale 1ns / 1ps

module one_bit_comparator(a,b,greater, smaller, equal);
	input a,b;
	output greater,smaller,equal;
	reg greater,smaller,equal;
	always @(a,b) begin
		smaller=~a&b;
		greater=a&~b;
		equal=~smaller&~greater;
	end
endmodule

module comparator(PB1, PB2, PB3, PB4, holder, greater, smaller, equal);
	input PB1,PB2, PB3, PB4;
	input [3:0] holder;
	reg [7:0] x,y;
	always @(posedge PB1) begin
		x[3:0] <= holder[3:0];
	end
	always @(posedge PB2) begin
		x[7:4] <= holder[3:0];
	end
	always @(posedge PB3) begin
		y[3:0] <= holder[3:0];
	end
	always @(posedge PB4) begin
		y[7:4] <= holder[3:0];
	end
	
	output greater,smaller,equal;
	wire [7:0] g,s,e;
	genvar i;
	generate
		for(i=0;i<8;i=i+1) begin:compare
			one_bit_comparator A1(x[i],y[i],g[i],s[i],e[i]);
		end
	endgenerate
	assign equal = &e;
	assign greater = g[7]|g[6]&(&e[7])|g[5]&(&e[7:6])|g[4]&(&e[7:5])
						 |g[3]&(&e[7:4])|g[2]&(&e[7:3])|g[1]&(&e[7:2])|g[0]&(&e[7:1]);
	assign smaller = ~equal & ~greater;
endmodule