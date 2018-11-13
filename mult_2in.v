////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : 2 Input Multiplier Module
// File Name        : mult_2in.v
// Version          : 1.0
// Description      : multiplier 32 bit with output 32 bit
//
////////////////////////////////////////////////////////////////////////////////

module mult_2in (i_a, i_b, o);

// parameters
parameter WIDTH = 32;
parameter FRAC = 24;

// input ports
input signed [WIDTH-1:0] i_a, i_b;

// output ports
output signed [WIDTH-1:0] o;

// wires
wire signed [2*WIDTH-1:0] mult;

// multiplying coefficient and input
// and taking only 32 bits, with 24 bit FRAC
assign mult = i_a * i_b;
assign o = mult[(FRAC+31):FRAC];

endmodule