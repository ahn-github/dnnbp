////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : Output Delta Calculate Module
// File Name        : delta_out.v
// Version          : 1.0
// Description      : calculate output layer delta value
//                    using function: (a-t)*sigmoid'
//
////////////////////////////////////////////////////////////////////////////////

module delta_out (i_a, i_t, o_delta, o_cost);

// parameters
parameter WIDTH = 32;
parameter FRAC = 24;

// input ports
input signed [WIDTH-1:0] i_a;
input signed [WIDTH-1:0] i_t;

// output ports
output signed [WIDTH-1:0] o_delta;
output signed [WIDTH-1:0] o_cost;

// wires
wire signed [WIDTH-1:0] o_sub;
wire signed [WIDTH-1:0] o_sig;

assign o_sub = i_a - i_t;
div_sigmoid #(.WIDTH(WIDTH)) div_sgmd (.i(i_a), .o(o_sig));
// Multiply (a-t) with sigmoid'(a)
mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) mult (.i_a(o_sub), .i_b(o_sig), .o(o_delta));

assign o_cost = o_sub;

endmodule