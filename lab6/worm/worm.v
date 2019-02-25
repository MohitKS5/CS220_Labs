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
module n_bit_adder(a,b,cin,sum);
	parameter [4:0] BS=4;
	input [BS-1:0] a,b;
	input cin;
	output [BS:0] sum;
	wire [BS-1:0] carrymid;
	genvar i;
	generate
		full_adder FA0(a[0], cin^b[0], cin, sum[0], carrymid[1]);
		for(i=1;i<BS-1;i=i+1) begin:block_1
			full_adder FA0(a[i], cin^b[i], carrymid[i], sum[i], carrymid[i+1]);
		end
		full_adder FA1(a[BS-1], cin^b[BS-1], carrymid[BS-1], sum[BS-1], sum[BS]);
	endgenerate
endmodule

`define EAST 0
`define WEST 1
`define NORTH 2
`define SOUTH 3
// top level module
module rotary_adder (
	input clk, ROT_A,ROT_B,
	input [3:0] holder,
	output reg [7:0] led
);
	// get rotation state
	wire [2:0] rotation_state;
	shaft_encoder R1(clk,ROT_A,ROT_B,rotation_state);

	reg [3:0] x,y,num1,num2;
	reg [1:0] steps,direction;
	reg prev_rotation_lsb,cin;
	wire cout;
	wire [3:0]sum;

	// initialize all to zero
	initial begin
		num1 <= 7'b0;
		num2 <= 7'b0;
		cin<=0;
		prev_rotation_lsb <= 0;
	end
	
	always @(posedge clk) begin
		// if rotation_state is incremented (LSB alternates)
		if (prev_rotation_lsb^rotation_state[0]) begin 
			{steps,direction} <= holder[3:0];
			case(direction)
			`EAST: begin
				num1 <= x;
				num2 <= {2'b0,steps};
				cin<=0;
  			end
			`WEST: begin
				num1 <= x;
				num2 <= {2'b0,steps};
				cin<=1;
			end
			`NORTH: begin
				num1 <= y;
				num2 <= {2'b0,steps};
				cin<=0;
			end
			`SOUTH: begin
				num1 <= y;
				num2 <= {2'b0,steps};
				cin<=1;
			end
			endcase
			prev_rotation_lsb <= rotation_state[0];	
		end
		if(cout==0 && direction[1]==0) x <= sum;
		if(cout==0 && direction[1]==1) y <= sum;
		led <= {x,y};
	end
	n_bit_adder #(5) S1(num1,num2,cin,{cout,sum});
endmodule

