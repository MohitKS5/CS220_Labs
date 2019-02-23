`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:18:42 01/28/2019 
// Design Name: 
// Module Name:    ripple_blinker 
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
`define SHIFT_TIME 25000000
module ripple_blinker(clk,led);
	input clk;
	output [7:0] led;
	reg [7:0] led;
	reg [32:0] counter;
	initial begin 
		led=8'b0000_0001;
		counter=32'b0;
	end
	always @(posedge clk) begin
		counter<=counter+1;
		if(counter==`SHIFT_TIME) begin
			led[1]<=led[0];
			led[2]<=led[1];
			led[3]<=led[2];
			led[4]<=led[3];
			led[5]<=led[4];
			led[6]<=led[5];
			led[7]<=led[6];
			led[0]<=led[7];
			counter<=0;
		end
	end
endmodule