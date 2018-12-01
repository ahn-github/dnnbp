module multiplexer ( input_a, input_b, sel, o);             
 
// parameters
parameter WIDTH = 32;

// input ports
input signed [WIDTH-1:0] input_a;
input signed [WIDTH-1:0] input_b;

// control ports
input sel;

// output ports
output signed [WIDTH-1:0] o;

assign o = sel ? input_b : input_a;
 
endmodule
 