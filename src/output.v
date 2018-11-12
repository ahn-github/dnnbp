////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : Output Layer Module
// File Name        : output.v
// Version          : 1.0
// Description      : output, each perceptron have:
//                    NUM_INPUT inputs and weights
//
////////////////////////////////////////////////////////////////////////////////

module out(clk, rst, wr, i_k, i_w, i_b, o);

// parameters
parameter NUM_INPUT = 2;
parameter NUM_PCTN = NUM_INPUT;
parameter WIDTH = 32;

// common ports
input clk, rst;

// control ports
input wr;

// input ports
input signed [NUM_INPUT*WIDTH-1:0] i_k;
input signed [NUM_INPUT*WIDTH-1:0] i_w;
input signed [WIDTH-1:0] i_b;

// output ports
output signed [NUM_PCTN*WIDTH-1:0] o;

// instantiating a NUM_PCTN of perceptrons
perceptron #(.NUM(NUM_INPUT), .WIDTH(WIDTH)) pctn[NUM_PCTN-1:0] (
	.clk(clk),
	.rst(rst),
	.wr(wr),
	.i_k(i_k),
	.i_w(i_w),
	.i_b(i_b),
	.o(o)
);

endmodule