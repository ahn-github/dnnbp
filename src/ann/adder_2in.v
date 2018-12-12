////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : 2 Input Adder Module
// File Name        : adder_2in.v
// Version          : 1.0
// Description      : 32 bit adder, with 32 bit input and output
//
////////////////////////////////////////////////////////////////////////////////

module adder_2in (i_a, i_b, o);

// parameters
parameter WIDTH = 32;

// input ports
input signed [WIDTH-1:0] i_a, i_b;

// output ports
output signed [WIDTH-1:0] o;

// adding both input
assign o = i_a + i_b;

endmodule