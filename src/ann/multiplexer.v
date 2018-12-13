module multiplexer (i_a, i_b, sel, o);             
 
// parameters
parameter WIDTH = 32;

// input ports
input signed [WIDTH-1:0] i_a;
input signed [WIDTH-1:0] i_b;

// control ports
input sel;

// output ports
output signed [WIDTH-1:0] o;

assign o = sel ? i_b : i_a;
 
endmodule
 