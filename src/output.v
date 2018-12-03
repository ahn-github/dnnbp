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

wire signed [31:0] o_1;
wire signed [31:0] o_2;

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

perceptron #(
		.NUM(NUM_INPUT),
		.WIDTH(WIDTH),
		.FILE_NAME("mem_wght_o_1.list")
	) perceptron_1 (
		.clk (clk),
		.rst (rst),
		.wr  (wr),
		.i_k (i_k),
		.i_w (i_w),
		.i_b (i_b),
		.o_a (o_1),
		.o_w (),
		.o_b ()
	);

perceptron #(
		.NUM(NUM_INPUT),
		.WIDTH(WIDTH),
		.FILE_NAME("mem_wght_o_2.list")
	) perceptron_2 (
		.clk (clk),
		.rst (rst),
		.wr  (wr),
		.i_k (i_k),
		.i_w (i_w),
		.i_b (i_b),
		.o_a (o_2),
		.o_w (),
		.o_b ()
	);

// perceptron_4 #(.NUM(NUM_INPUT), .WIDTH(WIDTH))  module_perceptron_1 (
// 	.clk(clk),
// 	.rst(rst),
// 	.wr(wr),
// 	.i_k(i_k),
// 	.i_w(i_w),
// 	.i_b(i_b),
// 	.o(o_1)
// );

// perceptron_5 #(.NUM(NUM_INPUT), .WIDTH(WIDTH))  module_perceptron_2 (
// 	.clk(clk),
// 	.rst(rst),
// 	.wr(wr),
// 	.i_k(i_k),
// 	.i_w(i_w),
// 	.i_b(i_b),
// 	.o(o_2)
// );

assign o = {o_2, o_1};

endmodule