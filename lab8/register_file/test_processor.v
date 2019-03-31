`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:05:28 03/31/2019
// Design Name:   processor
// Module Name:   F:/sem6/CS220/assignments/lab8/register_file/test_processor.v
// Project Name:  register_file
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: processor
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_processor;

	// Inputs
	reg clk;
	reg [3:0] holder;
	reg rot_a;
	reg rot_b;
	reg rejectPB;

	// Outputs
	wire lcd_rs;
	wire lcd_rw;
	wire lcd_e;
	wire lcd4;
	wire lcd5;
	wire lcd6;
	wire lcd7;
	wire [3:0] led;

	// Instantiate the Unit Under Test (UUT)
	processor uut (
		.clk(clk), 
		.lcd_rs(lcd_rs), 
		.lcd_rw(lcd_rw), 
		.lcd_e(lcd_e), 
		.lcd4(lcd4), 
		.lcd5(lcd5), 
		.lcd6(lcd6), 
		.lcd7(lcd7), 
		.holder(holder), 
		.rot_a(rot_a), 
		.rot_b(rot_b), 
		.rejectPB(rejectPB), 
		.led(led)
	);
	integer counter=0;
	always #1 clk=~clk;
	
	initial begin
		rot_a = 0;
		rot_b = 0;
		forever begin if(counter<(3+7)) begin
			#10 rot_a=1;
			#10 rot_b=1;
			#10 rot_a=0;
			#10 rot_b=0;
			counter=counter+1;
		end
		end
	end
	
	initial begin
		// Initialize Inputs
		clk=0;
		holder = 0;
		rejectPB = 0;
		
		#5 holder=0;
		#40 holder=0;
		#40 holder=0;
		#40 holder=0;
		#40 holder=0;
		#40 holder=0;
		#40 holder=10;
		
		#40 holder=1;
		#40 holder=0;
		#40 holder=0;
	end
      
endmodule

