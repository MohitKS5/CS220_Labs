`timescale 1ns / 1ps

module n_bit_comparator(A, B,less, greater, equality);
	 parameter [4:0] BS=8;
	 output less, greater, equality;
	 wire less, greater, equality;
	 
	 input [BS-1:0] A,B;
	 wire [BS-2:0] less_array;
	 wire [BS-2:0] greater_array;
	 wire [BS-2:0] equality_array;

	generate
	 	genvar i;
	 	one_bit_comparator COMP7 (1'b0, 1'b0, 1'b1, A[BS-1], B[BS-1],
								less_array[BS-2], greater_array[BS-2], equality_array[BS-2]);
		for(i=0;i<BS-2;i=i+1) begin:compare
	 		one_bit_comparator COMP1 (less_array[i+1], greater_array[i+1], equality_array[i+1],
						A[i+1], B[i+1], less_array[i], greater_array[i], equality_array[i]);
		end
		one_bit_comparator COMP0 (less_array[0], greater_array[0], equality_array[0],
						A[0], B[0], less, greater, equality);
	endgenerate
endmodule