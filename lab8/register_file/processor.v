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
	input acceptPB,rejectPB
    );

//  counters for state machines
	integer state;

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
	// reg [3:0] shift_amount;
	
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

	always @(posedge acceptPB) begin
			if(state==1) begin
				cmd<=holder;
				// reset
				readAddrA<=0;
				writeAddr<=5'b0;
				writeData<=16'b0;
				readAddrB<=0;
				writeEnable<=0;
				mode<=0;
			end 
			else if(state==2) case(cmd)
				3'b000:writeAddr[3:0]<=holder;
				3'b001:readAddrA[3:0]<=holder;
				3'b010:readAddrA[3:0]<=holder;
				3'b011:readAddrA[3:0]<=holder;
				3'b100:readAddrA[3:0]<=holder;
				3'b101:readAddrA[3:0]<=holder;
				3'b110:readAddrA[3:0]<=holder;
				3'b111:writeAddr[3:0]<=holder;
			endcase
		   else if(state==3) case(cmd)
				3'b000: writeAddr[4]<=holder[0];
				3'b001: begin readAddrA[4]<=holder[0]; state<=0; mode<=1; end //completed
				3'b010: readAddrA[4]<=holder[0];
				3'b011: readAddrA[4]<=holder[0];
				3'b100: readAddrA[4]<=holder[0];
				3'b101: readAddrA[4]<=holder[0];
				3'b110: readAddrA[4]<=holder[0];
				3'b111: writeAddr[4]<=holder[0]; 
			endcase
			else if(state==4) case(cmd)
				3'b000: writeData[15-:4]<=holder;
				3'b001:;
				3'b010: readAddrB[3:0] <= holder;
				3'b011: writeAddr[3:0] <= holder;
				3'b100: readAddrB[3:0] <= holder;
				3'b101: readAddrB[3:0]<=holder;
				3'b110: readAddrB[3:0]<=holder;
				3'b111: readAddrA[3:0]<=holder;
			endcase
			else if(state==5) case(cmd)
				3'b000: writeData[11-:4]<=holder;
				3'b001:;
				3'b010: begin readAddrB[4]<=holder[0]; state<=0; mode<=3; end //completed
				3'b011: writeAddr[4]<=holder[0];
				3'b100: readAddrB[4]<=holder[0];
				3'b101: readAddrB[4]<=holder[0];
				3'b110: readAddrB[4]<=holder[0];
				3'b111: readAddrA[4]<=holder[0];
			endcase
			else if(state==6) case(cmd)
				3'b000: writeData[7-:4]<=holder;
				3'b001:;
				3'b010:;
				3'b011: writeData[15-:4]<=holder;
				3'b100: writeAddr[3:0] <= holder;
				3'b101: begin op<=0; writeAddr[3:0] <= holder; end
				3'b110: begin op<=1; writeAddr[3:0] <= holder; end
				3'b111: begin writeData<=readDataA<<holder; state<= state+1; end
			endcase
			else if(state==7) case(cmd)
				3'b000: begin writeData[3-:4]<=holder; state<=state+1; end
				3'b001:;
				3'b010:;
				3'b011: writeData[11-:4]<=holder;
				3'b100: writeAddr[4]<=holder[0];
				3'b101: begin writeAddr[4]<=holder[0]; writeData<=val; state<=state+1; end
				3'b110: begin writeAddr[4]<=holder[0]; writeData<=val; state<=state+1; end
				3'b111: begin writeEnable<=1; state<=0; mode<=1; end //completed
			endcase 
			else if(state==8) case(cmd)
				3'b000: begin writeEnable<=1; state<=0; end //completed
				3'b001:;
				3'b010:;
				3'b011: writeData[7-:4]<=holder;
				3'b100: writeData[15-:4]<=holder;
				3'b101: begin writeEnable<=1; state<=0; mode<=1; end //completed
				3'b110: begin writeEnable<=1; state<=0; mode<=1; end // completed
				3'b111:;
			endcase 
			else if(state==9) case(cmd)
				3'b000:;
				3'b001:;
				3'b010:;
				3'b011: begin writeData[3-:4]<=holder; state<=state+1; end
				3'b100: writeData[11-:4]<=holder;
				3'b101:;
				3'b110:;
				3'b111:;
			endcase 
			else if(state==10) case(cmd)
				3'b000:;
				3'b001:;
				3'b010:;
				3'b011: begin writeEnable<=1; state<=0; mode<=2; end //completed
				3'b100: writeData[7-:4]<=holder;
				3'b101:;
				3'b110:;
				3'b111:;
			endcase 
			else if(state==11) case(cmd)
				3'b000:;
				3'b001:;
				3'b010:;
				3'b011:;
				3'b100: writeData[3-:4]<=holder;
				3'b101:;
				3'b110:;
				3'b111:;
			endcase 
			else if(state==12) case(cmd)
				3'b000:;
				3'b001:;
				3'b010:;
				3'b011:;
				3'b100: begin writeEnable<=1; state<=0; mode<=3; end
				3'b101:;
				3'b110:;
				3'b111:;
			endcase 
		state<=state+1;
	end
endmodule
