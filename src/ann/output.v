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

module out(clk, rst, wr, i_k, i_w, i_b, o_a, o_w, o_b);

// parameters
parameter NUM_INPUT = 3;
parameter NUM_PCTN = 2;
parameter WIDTH = 32;

// common ports
input clk, rst;

// control ports
input wr;

// input ports
input signed [NUM_INPUT*WIDTH-1:0] i_k;
input signed [NUM_PCTN*NUM_INPUT*WIDTH-1:0] i_w;
input signed [NUM_PCTN*WIDTH-1:0] i_b;

// output ports
output signed [NUM_PCTN*WIDTH-1:0] o_a;
output signed [NUM_PCTN*NUM_INPUT*WIDTH-1:0] o_w;
output signed [NUM_PCTN*WIDTH-1:0] o_b;

// wires
wire signed [NUM_INPUT*WIDTH-1:0] i_w1;
wire signed [NUM_INPUT*WIDTH-1:0] i_w2;
wire signed [WIDTH-1:0] i_b1;
wire signed [WIDTH-1:0] i_b2;

wire signed [WIDTH-1:0] o_1;
wire signed [WIDTH-1:0] o_2;
wire signed [NUM_INPUT*WIDTH-1:0] w_1;
wire signed [NUM_INPUT*WIDTH-1:0] w_2;
wire signed [WIDTH-1:0] b_1;
wire signed [WIDTH-1:0] b_2;

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

// parsing inputs
assign i_w1 = i_w[1*NUM_INPUT*WIDTH-1:0*NUM_INPUT*WIDTH];
assign i_w2 = i_w[2*NUM_INPUT*WIDTH-1:1*NUM_INPUT*WIDTH];
assign i_b1 = i_b[1*WIDTH-1:0*WIDTH];
assign i_b2 = i_b[2*WIDTH-1:1*WIDTH];

perceptron #(
		.NUM(NUM_INPUT),
		.WIDTH(WIDTH),
		.FILE_NAME("mem_wght_o_1.list")
	) perceptron_1 (
		.clk (clk),
		.rst (rst),
		.wr  (wr),
		.i_k (i_k),
		.i_w (i_w1),
		.i_b (i_b1),
		.o_a (o_1),
		.o_w (w_1),
		.o_b (b_1)
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
		.i_w (i_w2),
		.i_b (i_b2),
		.o_a (o_2),
		.o_w (w_2),
		.o_b (b_2)
	);

assign o_a = {o_2, o_1};
assign o_w = {w_2, w_1};
assign o_b = {b_2, b_1};

endmodule