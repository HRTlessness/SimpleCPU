module top_module();
	reg clk =0;
	reg reset = 1;

	always #1 clk = ~clk;

endmodule
