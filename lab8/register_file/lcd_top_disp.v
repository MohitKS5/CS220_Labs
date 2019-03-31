`timescale 1ns / 1ps

module lcd_output_top(
	// LCD ports
	input clk,
	output lcd_rs, lcd_rw, lcd_e,
	output [0:3] data,

	// LCD mode and lines
	input [1:0] mode,
	input [4:0] wa,raA,
	input [15:0] rdA,rdB,wd
    );

	reg [0:127] LINE1;
  	reg [0:127] LINE2;
	always @(posedge clk) begin
	    if(mode==2'b00) begin
	      LINE1 <= "ACCEPTING       ";
	      LINE2 <= "  INPUT         ";
	    end
	    else if(mode==2'b01) begin
	      LINE1 <= {"0"+wa[0],"0"+wa[1],"0"+wa[2],"0"+wa[3],"0"+wa[4], "           "};
	      LINE2 <= {"0"+wd[0],"0"+wd[1],"0"+wd[2],"0"+wd[3],"0"+wd[4],"0"+wd[5],"0"+wd[6],"0"+wd[7],"0"+wd[8],"0"+wd[9],"0"+wd[10],"0"+wd[11],"0"+wd[12],"0"+wd[13],"0"+wd[14],"0"+wd[15]};
		 end
	    else if(mode==2'b10) begin
	      LINE1 <= {"0"+raA[0],"0"+raA[1],"0"+raA[2],"0"+raA[3],"0"+raA[4], "           "};
	      LINE2 <= {"0"+rdA[0],"0"+rdA[1],"0"+rdA[2],"0"+rdA[3],"0"+rdA[4],"0"+rdA[5],"0"+rdA[6],"0"+rdA[7],"0"+rdA[8],"0"+rdA[9],"0"+rdA[10],"0"+rdA[11],"0"+rdA[12],"0"+rdA[13],"0"+rdA[14],"0"+rdA[15]};
		 end
	    else if(mode==2'b11) begin
	      LINE1 <= {"0"+rdA[0],"0"+rdA[1],"0"+rdA[2],"0"+rdA[3],"0"+rdA[4],"0"+rdA[5],"0"+rdA[6],"0"+rdA[7],"0"+rdA[8],"0"+rdA[9],"0"+rdA[10],"0"+rdA[11],"0"+rdA[12],"0"+rdA[13],"0"+rdA[14],"0"+rdA[15]};
		 LINE2 <= {"0"+rdB[0],"0"+rdB[1],"0"+rdB[2],"0"+rdB[3],"0"+rdB[4],"0"+rdB[5],"0"+rdB[6],"0"+rdB[7],"0"+rdB[8],"0"+rdB[9],"0"+rdB[10],"0"+rdB[11],"0"+rdB[12],"0"+rdB[13],"0"+rdB[14],"0"+rdB[15]};
	    end
	end
	

	lcd_welcome LCD (LINE1,LINE2,
			 clk, lcd_rs, lcd_rw, lcd_e, data[0], data[1], data[2], data[3]);
endmodule
