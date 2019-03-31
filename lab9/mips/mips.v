module mips(
input clk,
input switch,
output reg [7:0] led
  );

    reg [2:0] cntR,cntI;
    reg [1:0] cntJ;

    reg [1:0] cnt3,cnt4,cnt5,cnt6;

    reg [31:0] op [0:7];
    reg [2:0] pc;

    reg [1:0] state;
    reg [31:0] cur;
    reg [4:0] rd;

    initial begin
        pc<=0;
        cur<=0;
		  state<=0;

        cntR<=0;cntI<=0;cntJ<=0;
		  cnt3<=0;cnt4<=0;cnt5<=0;cnt6<=0;
    //op code
        op[0] = {6'h8, 5'h0, 5'h4, 16'h3456}; //addi $4 $0 0x3456
        op[1] = {6'h8, 5'h0, 5'h5, 16'hffff}; // addi $5, $0, 0xffff
        op[2] = {6'h0, 5'h5, 5'h4, 5'h6, 5'h0, 6'h20}; //add  $6, $5, $4
        op[3] = {6'h8, 5'h0, 5'h3, 16'h7}; //addi $3, $0, 0x7
        op[4] = {6'h0, 5'h6, 5'h3, 5'h6, 5'h0, 6'h4}; //sllv $6, $6, $3
        op[5] = {6'h0, 5'h0, 5'h3, 5'h3, 5'h1, 6'h2}; // srl  $3, $3, 0x1
        op[6] = {6'h23, 5'h4, 5'h5, 16'h9abc}; // lw  $5, 0x9abc($4)
        op[7] = {6'h2, 26'h123456}; // j    0x123456
    end

    always @(posedge clk) begin
      // fsm
      if(state==0) begin 
          cur<=op[pc];
          state<=1;
      end

      else if(state==1) begin
      // check format
        if(cur[31:26]==6'h0) begin //r format
          cntR<=cntR+1;
          rd<=cur[15:11];
        end
        else if(cur[31:26]==5'h2||cur[31:26]==5'h3) cntJ<=cntJ+1; // j format
        else begin
          cntI<=cntI+1;
          rd<=cur[20:16];
        end
        state<=2;
      end

      else if(state==2)begin
         if(cur[31:26]==0||cur[31:29]==3'b001||cur[31:29]==3'b100) begin // r-format or immediate or load instruction
          case(rd)
            3: cnt3<=cnt3+1;
            4: cnt4<=cnt4+1;
            5: cnt5<=cnt5+1;
            6: cnt6<=cnt6+1;
          endcase
			end
        pc<=pc+1;
        if(pc<7) state<=0;
        else state<=3;
      end
      else if(state==3) begin
        if(switch==0) led<={cntJ,cntI,cntR};
        else led<={cnt6,cnt5,cnt4,cnt3};
      end
    end
endmodule
