`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:01:18 03/11/2019 
// Design Name: 
// Module Name:    regFile 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module regFile(
	input clk, writeEnable,
	input [4:0] writeAddr,readAddrA, readAddrB,
	input [15:0] writeData,
	output [15:0] readDataA, readDataB
	);

	reg [15:0] rFile [0:31];
	initial begin
		rFile[0]=16'b0;  rFile[1]=16'b0;  rFile[2]=16'b0;  rFile[3]=16'b0;  rFile[4]=16'b0;
		rFile[5]=16'b0;  rFile[6]=16'b0;  rFile[7]=16'b0;  rFile[8]=16'b0;  rFile[9]=16'b0;
		rFile[10]=16'b0; rFile[11]=16'b0; rFile[12]=16'b0; rFile[13]=16'b0; rFile[14]=16'b0;
		rFile[15]=16'b0; rFile[16]=16'b0; rFile[17]=16'b0; rFile[18]=16'b0; rFile[19]=16'b0;
		rFile[20]=16'b0; rFile[21]=16'b0; rFile[22]=16'b0; rFile[23]=16'b0; rFile[24]=16'b0;
		rFile[25]=16'b0; rFile[26]=16'b0; rFile[27]=16'b0; rFile[28]=16'b0; rFile[29]=16'b0;
		rFile[30]=16'b0; rFile[31]=16'b0;
	end

	assign readDataA = rFile[readAddrA];
	assign readDataB = rFile[readAddrB];


	always @(posedge clk) begin
		if (writeEnable) begin 
		rFile[writeAddr] <= writeData;
		end
	end
endmodule
