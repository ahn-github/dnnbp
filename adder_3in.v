////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : 3 Input Adder Module
// File Name        : adder_3in.v
// Version          : 1.0
// Description      : adder 3 input
//
////////////////////////////////////////////////////////////////////////////////

module adder_3in(i_a, i_b, i_c, o);

// parameters
parameter DWIDTH=32;
parameter FRAC=24;

// input ports
input signed [DWIDTH-1:0] i_a, i_b, i_c;

// output ports
output signed [DWIDTH-1:0] o;

// adding i_a, i_b, and i_c
assign o = i_a + i_b + i_c;

endmodule