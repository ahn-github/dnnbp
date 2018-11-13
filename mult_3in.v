////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : 3 Input Multiplier Module
// File Name        : mult_3in.v
// Version          : 1.0
// Description      : multiplying 3 inputs, multiplier 32 bit with output 32 bit
//
////////////////////////////////////////////////////////////////////////////////

module mult_3in (i_a, i_b, i_c, o);

// parameters
parameter WIDTH = 32;
parameter FRAC = 24;

// input ports
input signed [WIDTH-1:0] i_a, i_b, i_c;

// output ports
output signed [WIDTH-1:0] o;

// wires
wire signed [3*WIDTH-1:0] mult;

// multiplying coefficient and input
// and taking only 32 bits, with 24 bit FRAC
assign mult = i_a * i_b * i_c;
assign o = mult[(2*FRAC+31):(2*FRAC)];

endmodule