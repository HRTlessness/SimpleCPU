module control(input clk, input reset);

	//regs
	reg [5:0] AR;
	reg [5:0] PC;
	reg [7:0] DR;
	reg [1:0] IR;
	
	reg [7:0] AC;
	reg [7:0] ALU;

	reg [3:0] state;
	parameter FETCH1 = 4'd0, FETCH2 = 4'd1, FETCH3 = 4'd2, CLR1 = 3'd3, ADD1 = 4'd8, ADD2 = 4'd9, AND1 = 4'd10, AND2 = 4'd11, JMP1 = 4'd12, INC1 = 4'd14;
	
	//microcode part (?)
	


	//reset
	always @(reset) begin //clears all regs and sends state back to FETCH
		PC <= 6'h00;
		ALU <= 8'h00;
		AC <= 8'h00;
		DR <= 8'h00;
		AR <= 6'hz;
		IR <= 2'd0;
		state <= FETCH1;
	end
	
	

endmodule
