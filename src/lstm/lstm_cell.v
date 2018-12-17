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

module lstm_cell (clk, rst, sel, i_x, i_w_a, i_w_i, i_w_f, i_w_o,  
i_b_a, i_b_i,  i_b_f, i_b_o,
o_w_a, o_w_i,  o_w_f, o_w_o, 
o_b_a, o_b_i, o_b_f, o_b_o, 
o_a, o_i, o_f, o_o, o_c, o_h);

// parameters
parameter WIDTH = 32;
parameter NUM = 3;
parameter FILENAMEA="mem_wghta.list";
parameter FILENAMEI="mem_wghti.list";
parameter FILENAMEF="mem_wghtf.list";
parameter FILENAMEO="mem_wghto.list";


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
reg signed [WIDTH-1:0] reg_c;
reg signed [WIDTH-1:0] reg_input;

wire signed [NUM*WIDTH-1:0] concatenated_input;
wire signed [WIDTH-1:0] temp_a;
wire signed [WIDTH-1:0] temp_i;
wire signed [WIDTH-1:0] temp_f;
wire signed [WIDTH-1:0] temp_o;
wire signed [WIDTH-1:0] temp_h;

wire signed [WIDTH-1:0] mul_ai;
wire signed [WIDTH-1:0] mul_fc;
wire signed [WIDTH-1:0] state_t;
wire signed [WIDTH-1:0] out_multiplexer_c;
wire signed [WIDTH-1:0] out_multiplexer_h;
wire signed [WIDTH-1:0] tanh_state_t;

assign concatenated_input ={out_multiplexer_h, i_x};



act_tanh #(
			.NUM(NUM),
			.WIDTH(WIDTH),
			.FILE_NAME(FILENAMEA)
		) 	inst_act_tanh (
			.clk (clk),
			.rst (rst),
			.wr  (wr),
			.i_k (concatenated_input),
			.i_w(i_w_a),
			.i_b(i_b_a),
			.o_a (temp_a),
			.o_w (o_w_a),
			.o_b (o_b_a)
		);


act_sigmoid #(
			.NUM(NUM),
			.WIDTH(WIDTH),
			.FILE_NAME(FILENAMEI)
		) inst_perceptron_i (
			.clk (clk),
			.rst (rst),
			.wr(wr),
			.i_k (concatenated_input),
			.i_w(i_w_i),
			.i_b(i_b_i),
			.o_a (temp_i),
			.o_w (o_w_i),
			.o_b (o_b_i)
		);

act_sigmoid #(
			.NUM(NUM),
			.WIDTH(WIDTH),
			.FILE_NAME(FILENAMEF)
		) inst_perceptron_f (
			.clk (clk),
			.rst (rst),
			.wr(wr),
			.i_k (concatenated_input),
			.i_w(i_w_f),
			.i_b(i_b_f),
			.o_a (temp_f),
			.o_w (o_w_f),
			.o_b (o_b_f)
		);

act_sigmoid #(
			.NUM(NUM),
			.WIDTH(WIDTH),
			.FILE_NAME(FILENAMEO)
		) inst_perceptron_o (
			.clk (clk),
			.rst (rst),
			.wr(wr),
			.i_k (concatenated_input),
			.i_w(i_w_o),
			.i_b(i_b_o),
			.o_a (temp_o),
			.o_w (o_w_o),
			.o_b (o_b_o)
		);

// a(t) * i(t)

mult_2in #(.WIDTH(WIDTH), .FRAC(24)) inst_mult_2in (.i_a(temp_a), .i_b(temp_i), .o(mul_ai));

// f(t) * c(t-1)
mult_2in #(.WIDTH(WIDTH), .FRAC(24)) inst2_mult_2in (.i_a(temp_f), .i_b(out_multiplexer_c), .o(mul_fc));

// o_h = tanh(state(t)  * o
mult_2in #(.WIDTH(WIDTH), .FRAC(24)) inst3_mult_2in (.i_a(tanh_state_t), .i_b(temp_o), .o(temp_h));

//state_t = a(t) * i(t) + f(t) * c(t-1)
adder_2in #(.WIDTH(WIDTH)) inst_adder_2in (.i_a(mul_ai), .i_b(mul_fc), .o(state_t));

multiplexer #(.WIDTH(WIDTH)) inst_multiplexer_c (.i_a(32'b0), .i_b(reg_c), .sel(sel), .o(out_multiplexer_c));

multiplexer #(.WIDTH(WIDTH)) inst_multiplexer_h (.i_a(32'b0), .i_b(reg_input), .sel(sel), .o(out_multiplexer_h));

tanh #(.WIDTH(WIDTH)) inst_tanh (.i(state_t), .o(tanh_state_t));


always @(posedge clk or rst)
begin
	if (rst)
	begin
		reg_c<=0;
  	end
	else
  	begin 
		reg_c<= state_t;
	end
end

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

assign o_c = state_t;
assign o_a = temp_a;
assign o_i = temp_i;
assign o_f = temp_f;
assign o_o = temp_o;
assign o_h = temp_h;

endmodule
