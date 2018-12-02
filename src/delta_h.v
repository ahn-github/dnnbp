////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : Delta Function for Hidden Layer
// File Name        : delta_h.v
// Version          : 1.0
// Description      : Computes delta, which is dC/dZ, for hidden layer.
//					  Takes the weight perceptron and delta from
//					  previous layer delta = sum(predelta*weight)*div_sigmoid
//
////////////////////////////////////////////////////////////////////////////////

module delta_h(clk, rst, en, i_a, i_prevd, i_w, o);

// parameters
parameter NUM = 2;
parameter WIDTH = 32;

// common ports
input clk, rst, en;

// input ports
input signed [NUM*WIDTH-1:0] i_prevd;
input signed [NUM*WIDTH-1:0] i_w;
input signed [WIDTH-1:0] i_a;

// output ports
output signed [WIDTH-1:0] o;

// wires
wire signed [NUM*WIDTH-1:0] o_mul_1;
wire signed [WIDTH-1:0] o_mul_2;
wire signed [WIDTH-1:0] o_add;
wire signed [WIDTH-1:0] temp_1;
wire signed [WIDTH-1:0] temp_2;
wire signed [WIDTH-1:0] o_sig;

// registers
reg signed [WIDTH-1:0] o;

always @(posedge clk or posedge rst)
begin
	if (rst)
	begin
		// Initialization
		o <= 32'b0;
	end
	else
		o <= temp_2;
end

// Select adder input
assign temp_1 = en ? o : 32'b0;

// Generate N multiplier, o_mul is an array of multiplier outputs, WIDTH bits each
mult_2in #(.WIDTH(WIDTH)) mult_1[NUM-1:0] (.i_a(i_prevd), .i_b(i_w), .o(o_mul_1));

// Adding all multiplier output & bias
adder #(.NUM(NUM), .WIDTH(WIDTH)) add (.i(o_mul_1), .o(o_add));

// Compute differential sigmoid
div_sigmoid #(.WIDTH(WIDTH)) div_sgmd (.i(i_a), .o(o_sig));

// Multiply sum of delta * input * sigmoid'(a)
mult_2in #(.WIDTH(WIDTH)) mult_2 (.i_a(o_add), .i_b(o_sig), .o(o_mul_2));

// Accumulate
adder #(.NUM(2), .WIDTH(WIDTH)) acc (.i({o_mul_2, temp_1}), .o(temp_2));

// Output
endmodule