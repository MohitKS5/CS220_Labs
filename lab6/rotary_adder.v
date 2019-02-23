`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:08:44 02/23/2019 
// Design Name: 
// Module Name:    rotary_adder 
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
module rotation_detect(clk, ROT_A, ROT_B, rotation_event, rotation_direction);
	input clk, ROT_A, ROT_B;
	output rotation_event, rotation_direction;
	reg rotation_event, rotation_direction;
	initial begin
		rotation_event = 1'b0;
		rotation_direction = 1'b0;
	end
	reg A_hold , B_hold ;
	always @(posedge clk) begin	
		A_hold <= ROT_A;
		B_hold <= ROT_B;
		if ((A_hold == 0) & (B_hold == 0)) begin
			rotation_event <= 0;
		end
		if ((A_hold == 1) & (B_hold == 1)) begin
			rotation_event <= 1;
		end
		if ((A_hold == 0) & (B_hold == 1)) begin
			rotation_direction <= 1;
		end
		if ((A_hold == 1) & (B_hold == 0)) begin
			rotation_direction <= 0;
		end
	end
endmodule

// rotation state incrementor/decrementor
module shaft_encoder(
	input clk, ROT_A, ROT_B,
	output reg [2:0] rotation_state
);
	wire rotation_event, rotation_direction;
	reg prev_rot_event;
	rotation_detect A1(clk, ROT_A, ROT_B, rotation_event, rotation_direction);
	initial begin
		rotation_state = 3'b0;
		prev_rot_event = 1'b1;	
	end

	always @(posedge clk) begin			
		if((prev_rot_event == 0) & (rotation_event == 1)) begin
			if (rotation_direction == 1) begin
				rotation_state <= rotation_state+1;
			end
			else begin
				rotation_state <= rotation_state-1;
			end	
		end
		prev_rot_event <= rotation_event;	
	end
endmodule

// full adder
module full_adder(a, b, cin, sum, cout);
	 input a, b, cin;
	 output sum, cout;
	 assign sum = a^b^cin;
	 assign cout = (a & b) | (b & cin) | (cin & a);
endmodule
// n-bit full adder
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

// top level module
module rotary_adder (
	input wire clk, ROT_A,ROT_B,
	input [3:0] holder,
	output reg [7:0] led
);
	wire [2:0] rotation_state;
	reg [6:0] num1,num2;
	initial begin
		num1 <= 7'b0;
		num2 <= 7'b0;
		led <= 8'b0;
	end
	
	shaft_encoder R1(clk,ROT_A,ROT_B,rotation_state);
	always @(rotation_state) begin
		case(rotation_state)
		// reset all to zero
			0: begin
				num1 <= 7'b0;
				num2 <= 7'b0;
				led  <= 8'b0;
			end
		// adder inputs state machine
			1: num1[6:4] <= holder[2:0];
			2: num1[3:0] <= holder[3:0];
			3: num2[6:4] <= holder[2:0];
			4: num2[3:0] <= holder[3:0];
		endcase
	end
	n_bit_adder #(7) S1(num1,num2,led);
endmodule


