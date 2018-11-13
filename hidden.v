////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : Hidden Layer Module
// File Name        : hidden.v
// Version          : 1.0
// Description      : hidden layer, each perceptron have:
//                    NUM_INPUT inputs and weights
//
////////////////////////////////////////////////////////////////////////////////

module hidden(clk, rst, wr, i_k, i_w, i_b, o);

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

// wire ports
wire signed [31:0] o_1;
wire signed [31:0] o_2;
wire signed [31:0] o_3;



// instantiating a NUM_PCTN of perceptrons
/*perceptron #(.NUM(NUM_INPUT), .WIDTH(WIDTH)) pctn[NUM_PCTN-1:0] (
	.clk(clk),
	.rst(rst),
	.wr(wr),
	.i_k(i_k),
	.i_w(i_w),
	.i_b(i_b),
	.o(o)
);
*/

perceptron_1 #(.NUM(NUM_INPUT), .WIDTH(WIDTH))  module_perceptron_1 (
	.clk(clk),
	.rst(rst),
	.wr(wr),
	.i_k(i_k),
	.i_w(i_w),
	.i_b(i_b),
	.o(o_1)
);

perceptron_2 #(.NUM(NUM_INPUT), .WIDTH(WIDTH))  module_perceptron_2 (
	.clk(clk),
	.rst(rst),
	.wr(wr),
	.i_k(i_k),
	.i_w(i_w),
	.i_b(i_b),
	.o(o_2)
);

perceptron_3 #(.NUM(NUM_INPUT), .WIDTH(WIDTH))  module_perceptron_3 (
	.clk(clk),
	.rst(rst),
	.wr(wr),
	.i_k(i_k),
	.i_w(i_w),
	.i_b(i_b),
	.o(o_3)
);



assign o= {o_3, o_2, o_1};

endmodule