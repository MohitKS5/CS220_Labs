`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:42:37 01/28/2019 
// Design Name: 
// Module Name:    blinker 
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
module blinker(clk,led0);
	input clk;
	output led0;
	reg led0;
	reg [32:0] counter;
	initial begin 
		led0=0;
		counter=32'b0;
	end
	always @(posedge clk) begin
		counter<=counter+1;
		if(counter==50000000) begin
			led0<=1;
		end
		if(counter==75000000) begin
			led0<=0;
			counter<=0;
		end
	end
endmodule
