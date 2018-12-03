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

module delta_h(i_a, i_prevd, i_w, o);

// parameters
parameter NUM = 2;
parameter WIDTH = 32;

// input ports
input signed [NUM*WIDTH-1:0] i_prevd;
input signed [NUM*WIDTH-1:0] i_w;
input signed [WIDTH-1:0] i_a;

// output ports
output signed [WIDTH-1:0] o;

// wires
wire signed [NUM*WIDTH-1:0] o_mul;
wire signed [WIDTH-1:0] o_add;
wire signed [WIDTH-1:0] temp_1;
wire signed [WIDTH-1:0] temp_2;
wire signed [WIDTH-1:0] o_sig;

// registers
wire signed [WIDTH-1:0] o;

// Generate N multiplier, o_mul is an array of multiplier outputs, WIDTH bits each
mult_2in #(.WIDTH(WIDTH)) mult_1[NUM-1:0] (.i_a(i_prevd), .i_b(i_w), .o(o_mul));

// Adding all multiplier output & bias
adder #(.NUM(NUM), .WIDTH(WIDTH)) add (.i(o_mul), .o(o_add));

// Compute differential sigmoid
div_sigmoid #(.WIDTH(WIDTH)) div_sgmd (.i(i_a), .o(o_sig));

// Multiply sum of delta * input * sigmoid'(a)
mult_2in #(.WIDTH(WIDTH)) mult_2 (.i_a(o_add), .i_b(o_sig), .o(o));

endmodule