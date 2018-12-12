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

module lstm_cell (clk, rst, sel, i_x, o_w_a, o_b_a, o_w_i, o_b_i, o_w_f, o_b_f, o_w_o, o_b_o, o_c, o_h,);

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
reg signed [WIDTH-1:0] reg_c;

// wires
wire signed [WIDTH-1:0] a;
wire signed [WIDTH-1:0] i;
wire signed [WIDTH-1:0] f;
wire signed [WIDTH-1:0] o;
wire signed [WIDTH-1:0] mul_ai;
wire signed [WIDTH-1:0] mul_fc;
wire signed [WIDTH-1:0] state_t;
wire signed [WIDTH-1:0] out_reg;


act_tanh #(
			.NUM(NUM),
			.WIDTH(WIDTH),
			.FILE_NAME(FILE_NAME)
		) inst_tanh (
			.clk (clk),
			.rst (rst),
			.i_x (i_x),
			.o_a (i),
			.o_w (o_w_a),
			.o_b (o_b_a)
		);


act_sigmf #(
			.NUM(NUM),
			.WIDTH(WIDTH),
			.FILE_NAME(FILE_NAME)
		) inst_perceptron_i (
			.clk (clk),
			.rst (rst),
			.i_x (i_x),
			.o_a (i),
			.o_w (o_w_i),
			.o_b (o_b_i)
		);

act_sigmf #(
			.NUM(NUM),
			.WIDTH(WIDTH),
			.FILE_NAME(FILE_NAME)
		) inst_perceptron_f (
			.clk (clk),
			.rst (rst),
			.i_x (i_x),
			.o_a (f),
			.o_w (o_w_f),
			.o_b (o_b_f)
		);

act_sigmf #(
			.NUM(NUM),
			.WIDTH(WIDTH),
			.FILE_NAME(FILE_NAME)
		) inst_perceptron_o (
			.clk (clk),
			.rst (rst),
			.i_x (i_x),
			.o_a (o),
			.o_w (o_w_o),
			.o_b (o_b_o)
		);

// a(t) * i(t)

mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) inst_mult_2in (.i_a(a), .i_b(i), .o(mul_ai));

// f(t) * c(t-1)
mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) inst2_mult_2in (.i_a(f), .i_b(regc), .o(mul_fc));

// o_h = tanh(state(t)  * o
mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) inst3_mult_2in (.i_a(tanh_state_t), .i_b(o), .o(o_h));

//state_t = a(t) * i(t) + f(t) * c(t-1)
adder_2in #(.WIDTH(WIDTH)) inst_adder_2in (.i_a(mul_ai), .i_b(mul_fc), .o(state_t));

multiplexer #(.WIDTH(WIDTH)) inst_multiplexer (.i_a(32'b0), .i_b(mul_fc), .sel(sel), .o(out_reg));

tanh #(.WIDTH(WIDTH), .ONE(ONE)) inst_tanh (.i(state_t), .o(tanh_state_t));


always @(posedge clk or posedge rst)
begin
	if (rst)
		reg_c<=0;
	else 
		reg_c<= out_reg;

	end
end

assign o_c = state_t;

endmodule
