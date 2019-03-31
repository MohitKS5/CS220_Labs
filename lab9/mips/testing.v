`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:29:24 03/31/2019
// Design Name:   mips
// Module Name:   F:/sem6/CS220/assignments/lab9/mips/testing.v
// Project Name:  mips
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mips
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module testing;

	// Inputs
	reg clk;
	reg switch;

	// Outputs
	wire [7:0] led;

	// Instantiate the Unit Under Test (UUT)
	mips uut (
		.clk(clk), 
		.switch(switch), 
		.led(led)
	);

	always #10 clk=~clk;
	initial begin
		// Initialize Inputs
		clk = 0;
		switch = 0;

		// Wait 100 ns for global reset to finish
		#100;
      switch=1;
		// Add stimulus here

	end
      
endmodule

