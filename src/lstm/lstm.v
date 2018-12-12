////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : Perceptron Module
// File Name        : perceptron.v
// Version          : 2.0
// Description      : Perceptron with NUM inputs, NUM weight, and 1 bias.
//                    Giving output of activation and weight value for
//					  backpropagation purpose.
//
////////////////////////////////////////////////////////////////////////////////

module lstm (clk, rst, sel, i_x, o_w_a, o_b_a, o_w_i, o_b_i, o_w_f, o_b_f, o_w_o, o_b_o, o_c, o_h,);

// parameters
parameter WIDTH = 32;
parameter NUM = 2;


// common ports
input clk, rst;

// control ports
input sel;

// input ports
input signed [(NUM+1)*WIDTH-1:0] i_x;


// output ports
output signed [NUM*WIDTH-1:0] o_w_a;
output signed [WIDTH-1:0] o_b_a;
output signed [NUM*WIDTH-1:0] o_w_i;
output signed [WIDTH-1:0] o_b_i;
output signed [NUM*WIDTH-1:0] o_w_f;
output signed [WIDTH-1:0] o_b_f;
output signed [NUM*WIDTH-1:0] o_w_o;
output signed [WIDTH-1:0] o_b_o;
output signed [WIDTH-1:0] o_c;
output signed [WIDTH-1:0] o_h;

// registers
reg signed [WIDTH-1:0] reg_input;

// wires
wire signed [WIDTH-1:0] output_inst_lstm_cell;
wire signed [WIDTH-1:0] input_inst_lstm_cell;


lstm_cell #(
		.WIDTH(WIDTH),
		.NUM(NUM)
	) inst_lstm_cell (
		.clk   (clk),
		.reset (reset),
		.i_x   ({input_inst_lstm_cell, i_x}),
		.o_w_a (o_w_a),
		.o_b_a (o_b_a),
		.o_w_i (o_w_i),
		.o_b_i (o_b_i),
		.o_w_f (o_w_f),
		.o_b_f (o_b_f),
		.o_w_o (o_w_o),
		.o_b_o (o_b_o),
		.o_c   (o_c),
		.o_h   (output_inst_lstm_cell)
	);
multiplexer #(.WIDTH(WIDTH)) inst_multiplexer (.i_a(32'b0), .i_b(reg_input), .sel(sel), .o(input_inst_lstm_cell));


always @(posedge clk or posedge rst)
begin
	if (rst)
		reg_input<=0;
	else 
		reg_input<= output_inst_lstm_cell;

	end
end


endmodule;
