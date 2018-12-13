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

module lstm (clk, rst, sel, i_x, i_w_a, i_w_i, i_w_f, i_w_o,  
i_b_a, i_b_i,  i_b_f, i_b_o,
o_w_a, o_w_i,  o_w_f, o_w_o,
o_b_a, o_b_i, o_b_f, o_b_o, 
o_a, o_i, o_f, o_o, o_c, o_h);

// parameters
parameter WIDTH = 32;
parameter NUM = 3;

// common ports
input clk, rst;

// control ports
input sel;

// input ports
input signed [(NUM-1)*WIDTH-1:0] i_x;

// input ports for backpropagation
input signed [NUM*WIDTH-1:0] i_w_a;
input signed [NUM*WIDTH-1:0] i_w_i;
input signed [NUM*WIDTH-1:0] i_w_f;
input signed [NUM*WIDTH-1:0] i_w_o;
input signed [WIDTH-1:0] i_b_a;
input signed [WIDTH-1:0] i_b_i;
input signed [WIDTH-1:0] i_b_f;
input signed [WIDTH-1:0] i_b_o;


// output ports
output signed [NUM*WIDTH-1:0] o_w_a;
output signed [NUM*WIDTH-1:0] o_w_i;
output signed [NUM*WIDTH-1:0] o_w_f;
output signed [NUM*WIDTH-1:0] o_w_o;
output signed [WIDTH-1:0] o_b_a;
output signed [WIDTH-1:0] o_b_i;
output signed [WIDTH-1:0] o_b_f;
output signed [WIDTH-1:0] o_b_o;
output signed [WIDTH-1:0] o_c;
output signed [WIDTH-1:0] o_h;
output signed [WIDTH-1:0] o_a;
output signed [WIDTH-1:0] o_i;
output signed [WIDTH-1:0] o_f;
output signed [WIDTH-1:0] o_o;

// registers
reg signed [WIDTH-1:0] reg_input;

// wires
wire signed [WIDTH-1:0] temp_h;
wire signed [NUM*WIDTH-1:0] concatenated_input;
wire signed [WIDTH-1:0] out_multiplexer;

// input format {h(t-1), x1, x2, x3, .....}
assign concatenated_input ={out_multiplexer, i_x};

multiplexer #(.WIDTH(WIDTH)) inst_multiplexer (.i_a(32'b0), .i_b(reg_input), .sel(sel), .o(out_multiplexer));

lstm_cell #(
		.WIDTH(WIDTH),
		.NUM(NUM)
	) inst_lstm_cell (
		.clk   (clk),
		.rst   (rst),
		.sel   (sel),
		.i_x   (concatenated_input),
		.i_w_a (i_w_a),
		.i_w_i (i_w_i),
		.i_w_f (i_w_f),
		.i_w_o (i_w_o),
		.i_b_a (i_b_a),
		.i_b_i (i_b_i),
		.i_b_f (i_b_f),
		.i_b_o (i_b_o),
		.o_w_a (o_w_a),
		.o_w_i (o_w_i),
		.o_w_f (o_w_f),
		.o_w_o (o_w_o),
		.o_b_a (o_b_a),
		.o_b_i (o_b_i),
		.o_b_f (o_b_f),
		.o_b_o (o_b_o),
		.o_a   (o_a),
		.o_i   (o_i),
		.o_f   (o_f),
		.o_o   (o_o),
		.o_c   (o_c),
		.o_h   (temp_h)
	);




always @(posedge clk or rst)
begin
	if (rst)	
	begin
		reg_input<=0;
	end
	else 
	begin
		reg_input<= temp_h;
	end
end

assign o_h = temp_h;

endmodule
