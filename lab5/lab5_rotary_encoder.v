`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:24:21 02/11/2019 
// Design Name: 
// Module Name:    rotary_encoder 
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

module ripple_blinker_mod(clk, rotation_event, rotation_direction, led);
	
	input clk, rotation_event, rotation_direction;
	
	output [7:0] led;
	
	reg [7:0] led;
	
	reg prev_rot_event;	
	initial begin 
		
		led = 8'b0000_0001;
		
		prev_rot_event = 1'b1;	
	end
	
	always @(posedge clk) begin
				
		if((prev_rot_event == 0) & (rotation_event == 1)) begin
			
			if (rotation_direction == 1) begin
				led[1] <= led[0];
			
				led[2] <= led[1];
			
				led[3] <= led[2];
			
				led[4] <= led[3];
			
				led[5] <= led[4];
			
				led[6] <= led[5];
			
				led[7] <= led[6];
			
				led[0] <= led[7];

			
end
			else begin
				led[0] <= led[1];
			
				led[1] <= led[2];
			
				led[2] <= led[3];
			
				led[3] <= led[4];
			
				led[4] <= led[5];
			
				led[5] <= led[6];
			
				led[6] <= led[7];
			
				led[7] <= led[0];

			end	
		end

		prev_rot_event <= rotation_event;	
	end

endmodule

module top_level(clk, ROT_A, ROT_B, led);
	input clk, ROT_A, ROT_B;
	wire rotation_event, rotation_direction;
	output [7:0] led;
	wire [7:0] led;

	rotation_detect A1(clk, ROT_A, ROT_B, rotation_event, rotation_direction);
	ripple_blinker_mod A2(clk, rotation_event, rotation_direction, led);

endmodule
