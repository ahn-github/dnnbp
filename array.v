////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : DNN Array Module
// File Name        : array.v
// Version          : 1.0
// Description      : DNN Array
//
////////////////////////////////////////////////////////////////////////////////

module array(clk, rst, wr, i, o);

// parameters
parameter N_IN = 40;
parameter N_OUT = 8;
parameter N_HL = 1;
parameter N_HL_P = 40;
parameter WIDTH = 32;

// common ports
input clk, rst;

// control ports
input wr;

// input ports
input signed [N_IN*WIDTH-1:0] i;

// output ports
output signed [N_OUT*WIDTH-1:0] o;

// wires
wire signed [N_IN*WIDTH-1:0] o_in_layr;
wire signed [N_HL_P*WIDTH-1:0] o_hd_layr;

// input layer, have N_IN input
in #(.NUM(N_IN), .WIDTH(WIDTH)) in_layr (.i(i), .o(o_in_layr));

// hidden layer, with N_IN number of inputs, and N_HL_P perceptrons
hidden #(.NUM_INPUT(N_IN), .NUM_PCTN(N_HL_P), .WIDTH(WIDTH)) hd_layr (
	.clk(clk),
	.rst(rst),
	.wr(wr),
	.i_k(o_in_layr),
	.i_w(),
	.i_b(),
	.o(o_hd_layr)
); 

// output layer, with N_HL_P number of inputs, and N_OUT perceptrons
out #(.NUM_INPUT(N_HL_P), .NUM_PCTN(N_OUT), .WIDTH(WIDTH)) ot_layr (
	.clk(clk),
	.rst(rst),
	.wr(wr),
	.i_k(o_hd_layr),
	.i_w(),
	.i_b(),
	.o(o)
);

endmodule