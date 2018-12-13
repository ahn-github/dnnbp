module ai_top_tb();

// parameters
parameter WIDTH = 32;

// registers
reg clk;
reg rst;
reg wr;
reg [7:0] addr_i;
reg [7:0] addr_o;
reg [63:0] i;

ai_top #(
		.WIDTH(WIDTH),
		.N_IN(2),
		.N_OUT(2),
		.N_HL(1),
		.N_HL_P(3)
	) inst_ai_top (
		.clk    (clk),
		.rst    (rst),
		.wr     (wr),
		.addr_i (addr_i),
		.addr_o (addr_o),
		.i      (i)
	);

initial
begin
	clk = 1;
	rst = 1;
	wr = 0;
	addr_i = 8'd0;
	addr_o = 8'd0;
	i = 64'd0;
	#100;
	rst = 0;
end

always
begin
	clk = !clk;
	#50;
end

endmodule