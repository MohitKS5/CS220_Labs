`timescale 1ns / 1ps

// `define IDLE 0;

module processor(
	// LCD ports
	input clk,
	output lcd_rs, lcd_rw, lcd_e, lcd4, lcd5, lcd6, lcd7,

// Input ports
	// slide switches
	input [3:0] holder,
	// accept and reject input push buttons
	input rot_a,rot_b,rejectPB,
	
	//debugging
	output reg [3:0] led
    );

//  counters for state machines
	reg [3:0] state;
	reg reset;

// for register file
	reg writeEnable;
	reg [4:0] writeAddr,readAddrA,readAddrB;
	reg [15:0] writeData;
	wire [15:0] readDataA, readDataB;

// for lCD
	reg [0:127] line1,line2;
	reg [1:0] mode;


// command code
	reg [2:0] cmd; 

// operations
	reg op; //add=0 or sub=1
	wire [16:0] val;
	
	// encoder
	reg rot_e,prev;
	
	// adder substract
	n_bit_adder #(16) sum1(.a(readDataA),.b(readDataB),.cin(op),.sum(val),.overflow());
	regFile RF1(
	 clk, writeEnable,
	 writeAddr,readAddrA, readAddrB,
	 writeData,
	 readDataA, readDataB
	);
	
	// LCD output
	lcd_output_top DISP(.clk(clk), .lcd_rs(lcd_rs), .lcd_rw(lcd_rw), .lcd_e(lcd_e), 
			 .data({lcd4, lcd5, lcd6, lcd7}),
			 .mode(mode),.wa(writeAddr),.raA(readAddrA),.rdA(readDataA),.rdB(readDataB),.wd(writeData));
			 
	initial begin
		state<=1;
		mode<=0;
		cmd<=3'b000;
		op<=0;
	end

	always @(posedge clk) begin
			led[3:0]<=state[3:0]; //debug
			
 			if(rot_a & rot_b) begin
	        	rot_e <= 1;
        	end 
        	else if(!rot_a & !rot_b) begin
            	rot_e <= 0;
        	end
			
			// reject interrupt
        	if(rejectPB==1) reset<=1;
			
			prev <= rot_e;
        	if(!prev & rot_e) begin
        		//if(state==0) reset<=0; // idle state
				if(state==1) begin 
					cmd<=holder;
				//reset all
					readAddrA<=0;
					writeAddr<=5'b0;
					writeData<=16'b0;
					readAddrB<=0;
					writeEnable<=0;
					mode<=0;
				end
				else if(state==2) begin case(cmd)
					3'b000: begin writeAddr[3:0]<=holder; mode<=1; end
					3'b001: begin readAddrA[3:0]<=holder; mode<=2; end
					3'b010: begin readAddrA[3:0]<=holder; mode<=3; end
					3'b011: begin readAddrA[3:0]<=holder; mode<=2; end
					3'b100: begin readAddrA[3:0]<=holder; mode<=3; end
					3'b101: begin readAddrA[3:0]<=holder; mode<=1; end
					3'b110: begin readAddrA[3:0]<=holder; mode<=1; end
					3'b111: begin writeAddr[3:0]<=holder; mode<=1; end
				endcase end
			   else if(state==3) begin case(cmd)
					3'b000: begin writeAddr[4]<=holder[0];end
					3'b001: begin readAddrA[4]<=holder[0]; reset<=1; end //completed
					3'b010: readAddrA[4]<=holder[0];
					3'b011: readAddrA[4]<=holder[0];
					3'b100: readAddrA[4]<=holder[0];
					3'b101: readAddrA[4]<=holder[0];
					3'b110: readAddrA[4]<=holder[0];
					3'b111: writeAddr[4]<=holder[0]; 
				endcase end
				else if(state==4) begin case(cmd)
					3'b000: writeData[15-:4]<=holder;
					3'b001:;
					3'b010: readAddrB[3:0]<=holder;
					3'b011: writeAddr[3:0]<=holder;
					3'b100: readAddrB[3:0]<=holder;
					3'b101: readAddrB[3:0]<=holder;
					3'b110: readAddrB[3:0]<=holder;
					3'b111: readAddrA[3:0]<=holder;
				endcase end
				else if(state==5)begin case(cmd)
					3'b000: writeData[11-:4]<=holder;
					3'b001:;
					3'b010: begin readAddrB[4]<=holder[0]; reset<=1; end //completed
					3'b011: writeAddr[4]<=holder[0];
					3'b100: readAddrB[4]<=holder[0];
					3'b101: readAddrB[4]<=holder[0];
					3'b110: readAddrB[4]<=holder[0];
					3'b111: readAddrA[4]<=holder[0];
				endcase end
				else if(state==6) begin case(cmd)
					3'b000: writeData[7-:4]<=holder;
					3'b001:;
					3'b010:;
					3'b011: writeData[15-:4]<=holder;
					3'b100: writeAddr[3:0] <= holder;
					3'b101: begin op<=0; writeAddr[3:0] <= holder; end
					3'b110: begin op<=1; writeAddr[3:0] <= holder; end
					3'b111: begin writeData<=readDataA<<holder; writeEnable<=1; reset<=1; end //completed
				endcase end
				else if(state==7) begin case(cmd)
					3'b000: begin writeData[3-:4]<=holder; writeEnable<=1; reset<=1; end //completed
					3'b001:;
					3'b010:;
					3'b011: writeData[11-:4]<=holder;
					3'b100: writeAddr[4]<=holder[0];
					3'b101: begin writeAddr[4]<=holder[0]; writeData<=val; writeEnable<=1; reset<=1; end //completed
					3'b110: begin writeAddr[4]<=holder[0]; writeData<=val; writeEnable<=1; reset<=1; end //completed
					3'b111:;
				endcase end
				else if(state==8) begin case(cmd)
					3'b000:;
					3'b001:;
					3'b010:;
					3'b011: writeData[7-:4]<=holder;
					3'b100: writeData[15-:4]<=holder;
					3'b101:;
					3'b110:;
					3'b111:;
				endcase end
				else if(state==9) begin case(cmd)
					3'b000:;
					3'b001:;
					3'b010:;
					3'b011: begin writeData[3-:4]<=holder; writeEnable<=1; reset<=1; end //completed
					3'b100: writeData[11-:4]<=holder;
					3'b101:;
					3'b110:;
					3'b111:;
				endcase end
				else if(state==10) begin case(cmd)
					3'b000:;
					3'b001:;
					3'b010:;
					3'b011:;
					3'b100: writeData[7-:4]<=holder;
					3'b101:;
					3'b110:;
					3'b111:;
				endcase end
				else if(state==11) begin case(cmd)
					3'b000:;
					3'b001:;
					3'b010:;
					3'b011:;
					3'b100: begin writeData[3-:4]<=holder; writeEnable<=1; reset<=1; end
					3'b101:;
					3'b110:;
					3'b111:;
				endcase end
				state<=state+1;
			end

			// command completed
			if(reset==1) begin state<=1;	reset<=0; writeEnable<=0; end
	end
endmodule
