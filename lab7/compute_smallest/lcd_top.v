`timescale 1ns / 1ps

module lcd_output_top(
	// LCD ports
	input clk,
	output lcd_rs, lcd_rw, lcd_e, lcd4, lcd5, lcd6, lcd7,
	
	// Push button ports
	input PB1,PB2, PB3, PB4,
	input [3:0] holder
    );
	reg [3:0] num1,num2,num3,num4,min;
	reg [1:0] min_index;
	wire [3:0] less,greater,equality;
	always @(posedge PB1) begin
		num1[3:0] = holder[3:0];
	end
	always @(posedge PB2) begin
		num2[3:0] = holder[3:0];
	end
	always @(posedge PB3) begin
		num3[3:0] = holder[3:0];
	end
	always @(posedge PB4) begin
		num4[3:0] = holder[3:0];
	end

	wire [7:0] charset_index_num1, charset_index_num2, charset_index_num3, charset_index_num4, charset_index_output;
	n_bit_adder #(8) A1({5'h0,num1}, 8'h30, charset_index_num1);
	n_bit_adder #(8) A2({5'h0,num2}, 8'h30, charset_index_num2);
	n_bit_adder #(8) A3({5'h0,num3}, 8'h30, charset_index_num3);
	n_bit_adder #(8) A4({5'h0,num4}, 8'h30, charset_index_num4);
	n_bit_adder #(8) A5({5'h0,num4}, 8'h30, charset_index_output);

	n_bit_comparator #(3) C1(num1,min,less[0],greater[0],equality[0]);
	n_bit_comparator #(3) C2(num2,min,less[1],greater[1],equality[1]);
	n_bit_comparator #(3) C3(num3,min,less[2],greater[2],equality[2]);
	n_bit_comparator #(3) C4(num4,min,less[3],greater[3],equality[3]);

	always @(posedge clk) begin
		if(less[0]) begin 
			min <= num1;
			min_index <= 0;
		end
		else if(less[1])begin 
			min <= num2;
			min_index <= 1;
		end
		else if(less[2]) begin 
			min <= num3;
			min_index <= 2;
		end
		else if(less[3]) begin 
			min <= num4;
			min_index <= 3;
		end
	end

	lcd_welcome LCD ({"      ",charset_index_num1,", ",charset_index_num2,", ",charset_index_num3,", ",charset_index_num4},
			 {"               ", charset_index_output},
			 clk, lcd_rs, lcd_rw, lcd_e, lcd4, lcd5, lcd6, lcd7);
endmodule
