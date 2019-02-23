`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:09:31 01/28/2019
// Design Name:   comparator
// Module Name:   /media/mohitks/WD PASSPORT/CS220Labs/Lab2_3/comparator/testing_comparator.v
// Project Name:  comparator
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: comparator
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testing_comparator;

	// Inputs
	reg PB1;
	reg PB2;
	reg PB3;
	reg PB4;
	reg [3:0] holder;

	// Outputs
	wire greater;
	wire smaller;
	wire equal;

	// Instantiate the Unit Under Test (UUT)
	comparator uut (
		.PB1(PB1), 
		.PB2(PB2), 
		.PB3(PB3), 
		.PB4(PB4), 
		.holder(holder), 
		.greater(greater), 
		.smaller(smaller), 
		.equal(equal)
	);

	initial begin
		PB1=0;PB2=0;PB3=0;PB4=0;holder=0000;
		#5
		PB1 = 1; PB2<=0; PB3=0; PB4=0;holder = 4'b0100;
		#5
		PB1 = 0; PB2=1; PB3=0; PB4=0;holder = 4'b0101;
		#5
		PB1 = 0; PB2=0; PB3=1; PB4=0;holder = 4'b0001;
		#5
		PB1 = 0; PB2=0; PB3=0; PB4=1;holder = 4'b0010;
		#5
		$finish;

	end
      
endmodule

