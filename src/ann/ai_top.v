module ai_top(clk, rst, wr, addr_i, addr_o, i);

// parameters
parameter WIDTH = 32;
parameter N_IN = 2;
parameter N_OUT = 2;
parameter N_HL = 1;
parameter N_HL_P = 3;

// common ports
input clk, rst;

// control ports
input wr;
input [7:0] addr_i;
input [7:0] addr_o;

// input ports
input signed [N_IN*WIDTH-1:0] i;

// wires
wire [N_IN*WIDTH-1:0] read_i_mem;
wire [N_OUT*WIDTH-1:0] o_array;

i_mem #(.WIDTH(N_IN*WIDTH)) i_mem (
	.clk(clk),
	.rst(rst),
	.addr(addr_i),
	.wr(wr),
	.i(i),
	.o(read_i_mem)
);
array #(.N_IN(N_IN), .N_OUT(N_OUT), .N_HL(N_HL), .N_HL_P(N_HL_P), .WIDTH(WIDTH)) arr (
	.clk(clk),
	.rst(rst),
	.wr(wr),
	.i(read_i_mem),
	.o(o_array)
);
o_mem #(.WIDTH(N_OUT*WIDTH)) o_mem (
	.clk(clk),
	.rst(rst),
	.addr(addr_o),
	.wr(wr),
	.i(o_array),
	.o()
);

endmodule