`timescale 1ns / 1ps
module lcd_welcome(
    first_line,
    second_line,
    clk,
    lcd_rs,
    lcd_rw,
    lcd_e,
    db4,
    db5,
    db6,
    db7
    );

     input [0:127] first_line;
     input [0:127] second_line;
     input clk;
     output lcd_rs, lcd_rw, lcd_e, db4, db5, db6, db7;
     reg lcd_rs, lcd_rw, lcd_e, db4, db5, db6, db7;

     reg [7:0] line1_index = 0;
     reg [1:0] line1_state = 3;

     reg [7:0] line2_index = 0;
     reg [1:0] line2_state = 3;

     reg [19:0] counter = 1_000_000;
     reg [2:0] next_state = 0;

     reg [2:0] line_break_state = 7;

     reg [5:0] init_ROM [0:13];
     reg [3:0] init_ROM_index = 0;

     // Initialization code
     initial begin
        init_ROM[0] = 6'h03;
        init_ROM[1] = 6'h03;
        init_ROM[2] = 6'h03;
        init_ROM[3] = 6'h02;
        init_ROM[4] = 6'h02;
        init_ROM[5] = 6'h08;
        init_ROM[6] = 6'h00;
        init_ROM[7] = 6'h06;
        init_ROM[8] = 6'h00;
        init_ROM[9] = 6'h0c;
        init_ROM[10] = 6'h00;
        init_ROM[11] = 6'h01;
        init_ROM[12] = 6'h08;
        init_ROM[13] = 6'h00;
     end

    always @ (posedge clk) begin
       if (counter == 0) begin
           counter <= 1_000_000;

            // Initialization state machine
            if (init_ROM_index == 14) begin
                next_state <= 4;
                init_ROM_index <= 0;
                line1_state <= 0;
            end

            if ((next_state != 4) && (init_ROM_index != 14)) begin
              case (next_state)
					 0: begin
                        lcd_e <= 0;
                        next_state <= 1;
						 end

					 1: begin
                        {lcd_rs, lcd_rw, db7, db6, db5, db4} <= init_ROM[init_ROM_index];
                        next_state <= 2;
                   end

                2: begin
								lcd_e <= 1;
                        next_state <= 3;
                    end

                3: begin
								lcd_e <= 0;
                        next_state <= 1;
                        init_ROM_index <= init_ROM_index + 1;
                    end
                endcase
             end

            // First line state machine
            if (line1_index == 128) begin
                line1_state <= 3;
                line1_index <= 0;
                line_break_state <= 0;
            end
            if ((line1_state != 3) && (line1_index != 128)) begin
                case (line1_state)
                    0: begin
                            {lcd_rs, lcd_rw, db7, db6, db5, db4} <=
{2'h2,first_line[line1_index],first_line[line1_index+1],first_line[line1_index+2],first_line[line1_index+3]};
                            line1_state <= 1;
                        end

                    1: begin
                            lcd_e <= 1;
                            line1_state <= 2;
                        end

                    2: begin
                            lcd_e <= 0;
                            line1_state <= 0;
                            line1_index <= line1_index+4;
                        end
                endcase
            end

            // Line break state machine
            if (line_break_state != 7) begin
                case (line_break_state)
                    0: begin
                            {lcd_rs, lcd_rw, db7, db6, db5, db4} <= 6'h0c;
                            line_break_state <= 1;
                        end

                    1: begin
                            lcd_e <= 1;
                            line_break_state <= 2;
                        end

                    2: begin
                            lcd_e <= 0;
                            line_break_state <= 3;
                        end

                    3: begin
                            {lcd_rs, lcd_rw, db7, db6, db5, db4} <= 6'h00;
                            line_break_state <= 4;
                        end

                    4: begin
                            lcd_e <= 1;
                            line_break_state <= 5;
                        end

                    5: begin
                            lcd_e <= 0;
                            line_break_state <= 7;
                            line2_state <= 0;
                        end
                endcase
            end

            // Second line state machine
            if (line2_index == 128) begin
                line2_state <= 3;
                line2_index <= 0;
            end
            if ((line2_state != 3) && (line2_index != 128)) begin
                case (line2_state)
                    0: begin
                            {lcd_rs, lcd_rw, db7, db6, db5, db4} <=
{2'h2,second_line[line2_index],second_line[line2_index+1],second_line[line2_index+2],second_line[line2_index+3]};
                            line2_state <= 1;
                        end

                    1: begin
                            lcd_e <= 1;
                            line2_state <= 2;
                        end

                    2: begin
                            lcd_e <= 0;
                            line2_state <= 0;
                            line2_index <= line2_index+4;
                        end
                endcase
            end
            if(line2_index == 128)
            begin
                line1_index <= 0;
                line1_state <= 3;

                line2_index <= 0;
                line2_state <= 3;

                next_state <= 0;

                line_break_state <= 7;

                init_ROM_index <= 0;
            end
        end
        else
        begin
           counter <= counter - 1;
        end
    end
endmodule
module top(
	input clk,
	output wire LCD_RS,
	output wire LCD_E,
	output wire LCD_W,
	output wire [3:0] data
      );

  reg [127:0] LINE1;
  reg [127:0] LINE2;
  
   initial begin
      LINE1 <=  "WELCOME TO CSE  ";
      LINE2 <=  "IIT KANPUR      ";
    end
  lcd_welcome uut(LINE1,LINE2,clk,LCD_RS,LCD_W,LCD_E,data[0],data[1],data[2],data[3]);
endmodule