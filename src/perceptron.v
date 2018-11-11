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

module perceptron (i_k, i_w, i_b, o);

// parameters
parameter NUM = 2;
parameter WIDTH = 32;

// input ports
input signed [NUM*WIDTH-1:0] i_k;
input signed [NUM*WIDTH-1:0] i_w;
input signed [WIDTH-1:0] i_b;

// output ports
output signed [WIDTH-1:0] o;
// output signed [WIDTH-1:0] z;

// wires
wire signed [WIDTH*NUM-1:0] o_mul;
wire signed [WIDTH-1:0] o_add;

mult_2in #(.WIDTH(WIDTH)) mult[NUM-1:0] (.i_a(i_k), .i_b(i_w), .o(o_mul));
adder #(.NUM(NUM+1), .WIDTH(WIDTH)) add (.i({i_b, o_mul}), .o(o));
// sigmf sigmoid (.i(o_add), .o(o));

// assign z = o_add;

endmodule