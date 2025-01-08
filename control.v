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
	reg [12:0] microcoded_memory; 
	reg [12:0] microcode;

	initial begin
		$readmemh("microcoded_memory.txt", microcoded_memory);
		state <= 4'h0;
		microcode <= microcoded_memory[0];
		AR <= 6'hz;
	end

	wire [2:0] M1;
	wire M2;
	wire SEL;
	wire [3:0] ADDR;

	assign SEL = microcode[12];
	assign M1 = microcode[8:6];
	assign M2 = microcode[4];
	assign ADDR = microcode[3:0];

	always  @(posedge clk)
		state <= SEL ? {1'b1, IR, 1'b0} : ADDR;
	
	always @(*)
		microcode <= microcoded_memory[state];

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
	
	//control signal section
	wire [11:0] control_signals;
	wire [7:0] bus, mem_bus;

	assign control_signals[0] = control_signals[9] || M1==3'd3; //ARLOAD
	assign control_signals[1] = M2; //PCINC
	assign control_signals[2] = M1==3'd4; //PCLOAD
	assign control_signals[3] = M1==3'd1; //DRLOAD
	assign control_singals[4] = M1==3'd5 || control_signals[7]; //ACLOAD
	assign control_signals[5] = M1==3'd7; //ACINC
	assign control_signals[6] = M1==3'd3; //IRLOAD
	assign control_signals[7] = M1==3'd6;//ALUSEL
	assign control_signals[8] = control_signals[3]; //MEMBUS
	assign control_signals[9] = M1=3'd2; //PCBUS
	assign control_signals[10] = control_signals[6] || control_signals[2] || control_signal[4]; //DRBUS
	assign control_signals[11] = control_signals[3]; //READ


	always @(negedge clk) begin
		IR <= control_signals[6] ? bus[7:6] : IR; //loading IR
		AC <= control_signals[4] ? ALU : AC; //Loading AC
		AC <= control_signals[5] ? AC+1 : AC; //Increment AC
		DR <= control_signals[3] ? bus : DR; //Loading DR
		PC <= control_signals[1] ? PC+1 : PC; //INcrement PC
		PC <= control_signals[2] ? bus : PC; //Load PC
		AR <= control_signals[0] ? bus[5:0] : AR; //Load AR
	end


	always @(*) ALU <= control_signals[7] ? (bus & AC) : (bus + AC);
	
	assign bus = control[9] ? {2'b00, PC} : (control_signal[10] ? DR : (control_signals[8] ? mem_bus : 8'bz));

	memory mem0 ( .address(AR), .READ(control_signals[11]), .data(mem_bus) );
endmodule
