////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : Perceptron Module
// File Name        : perceptron.v
// Version          : 1.0
// Description      : Perceptron with 2 inputs, 2 weight, and 1 bias.
//                    Giving output of activation and z value.
//
////////////////////////////////////////////////////////////////////////////////

module perceptron (i_k0, i_k1, i_w0, i_w1, i_bias, o_a, o_z);

// parameters
parameter WIDTH = 32;

// input ports
input signed [WIDTH-1:0] i_k0;
input signed [WIDTH-1:0] i_k1;
input signed [WIDTH-1:0] i_w0;
input signed [WIDTH-1:0] i_w1;
input signed [WIDTH-1:0] i_bias;

// output ports
output signed [WIDTH-1:0] o_a;
output signed [WIDTH-1:0] o_z;

// wires
wire signed [WIDTH-1:0] o_mult_0, o_mult_1;

mult_2in mult_0 (.i_a(i_w0), .i_b(i_k0), .o(o_mult_0));
mult_2in mult_1 (.i_a(i_w1), .i_b(i_k1), .o(o_mult_1));
adder_3in add (.i_a(o_mult_0), .i_b(o_mult_1), .i_c(i_bias), .o(o_z));
sigmf sigmoid (.i(o_z), .o(o_a));

endmodule