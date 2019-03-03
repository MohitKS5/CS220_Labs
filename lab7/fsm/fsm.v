module fsm(
	input clk,
	input [1:0] holder,
	output reg [3:0] state
	);
	reg [2:0] MROM [0:12];
	reg [3:0] DROM_1 [0:3];
	reg [3:0] DROM_2 [0:3];
	initial begin
		// Initialize Microcode ROM
		MROM[0] <= 3'h0;
		MROM[1] <= 3'h0;
		MROM[2] <= 3'h0;
		MROM[3] <= 3'h1;
		MROM[4] <= 3'h2;
		MROM[5] <= 3'h2;
		MROM[6] <= 3'h0;
		MROM[7] <= 3'h0;
		MROM[8] <= 3'h0;
		MROM[9] <= 3'h0;
		MROM[10] <= 3'h3;
		MROM[11] <= 3'h4;
		MROM[12] <= 3'h4;

		// initialize Dispatch ROM for S3
		DROM_1[0]<=4'h4;
		DROM_1[1]<=4'h5;
		DROM_1[2]<=4'h6;
		DROM_1[3]<=4'h6;

		// initialize Dispatch ROM for S10
		DROM_2[0]<=4'hB;
		DROM_2[1]<=4'hC;
		DROM_2[2]<=4'hC;
		DROM_2[3]<=4'hC;
 	end
 	
 	integer counter=0;
 	reg [1:0] prev_holder=2'b0;

 	always @(posedge clk) begin
 		counter<=counter+1;
 		if ((counter == 100_000_000)||(holder!=prev_holder)) begin
 			case(MROM[state])
 				3'h0: state<=state+1;
 				3'h1: state<=DROM_1[holder];
 				3'h2: state<=4'h7;
 				3'h3: state<=DROM_2[holder];
 				3'h4: state<=0;
 			endcase
			prev_holder<=holder;
			counter<=0;
 		end
 	end
endmodule