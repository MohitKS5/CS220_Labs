`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   01:48:50 01/27/2019
// Design Name:   five_numbers_adder
// Module Name:   F:/sem6/CS220/assignments/ass1/five_4-bit-adder/test_5-num-adder.v
// Project Name:  five_4-bit-adder
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: five_numbers_adder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_5_num_adder;

	// Inputs
	reg PB1;
	reg PB2;
	reg PB3;
	reg PB4;
	reg PB5;
	reg [3:0] holder;
	//reg clk;
	// Outputs
	wire [6:0] sum;

	// Instantiate the Unit Under Test (UUT)
	five_numbers_adder uut (
		.PB1(PB1), 
		.PB2(PB2), 
		.PB3(PB3), 
		.PB4(PB4), 
		.PB5(PB5), 
		.holder(holder), 
		.sum(sum)
	);
	/*initial
		clk=0;
	always
		#5 clk=!clk;
	*/

	initial begin
		// Initialize Inputs
		PB1=0;PB2=0;PB3=0;PB4=0;PB5=0;holder=0000;
		#5
		PB1 = 1; PB2<=0; PB3=0; PB4=0; PB5=0; holder = 4'b0100;
		#5
		PB1 = 0; PB2=1; PB3=0; PB4=0; PB5=0; holder = 4'b0101;
		#5
		PB1 = 0; PB2=0; PB3=1; PB4=0; PB5=0; holder = 4'b0001;
		#5
		PB1 = 0; PB2=0; PB3=0; PB4=1; PB5=0; holder = 4'b0010;
		#5
		PB1 = 0; PB2=0; PB3=0; PB4=0; PB5=1; holder = 4'b0011;
		#5;
        
		// Add stimulus here
	$finish;
	end
      
endmodule

