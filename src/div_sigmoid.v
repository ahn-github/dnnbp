////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : Derivatif Sigmoid
// File Name        : div_sigmoid.v
// Version          : 1.0
// Description      : Perceptron with 2 inputs, 2 weight, and 1 bias.
//                    Giving output of activation and z value.
//
////////////////////////////////////////////////////////////////////////////////

module div_sigmoid (i, o);

// parameters
parameter WIDTH=32;

// input ports 
input signed [WIDTH:0] i;

// output ports
output signed[WIDTH:0] o;

wire signed[31:0]invert_a;

wire signed[31:0] adder;
assign invert_a = ~i;
assign adder = invert_a + 32'd2;

assign o= adder * i;

endmodule
