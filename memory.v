module memory(input [5:0] address, input WRITE, input READ, inout wire [7:0] data);
	initial $readmemh("mem_hex.txt", mem);
	reg [7:0] mem[0:63];  
	reg [7:0] data_out;

	always @(posedge WRITE) //write to memory
		mem[address] <= data;

	always @(posedge READ) //read from memory
		data_out <= mem[address];

	assign data = (READ) ? data_out : 8'bz; //Gives an output value only if READ is on, otherwise the output does not matter

endmodule
