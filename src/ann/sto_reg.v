module sto_reg(clk, rst, load, i, o);

// parameters
parameter WIDTH = 32;
parameter NUM = 68;

// common ports
input clk;
input rst;

// control ports
input load;

// input ports
input signed [NUM*WIDTH-1:0] i;

// output ports
output signed [NUM*WIDTH-1:0] o;

// wires
wire signed [NUM*WIDTH-1:0] o_mux;

// registers
reg signed [NUM*WIDTH-1:0] o;

multiplexer #(.WIDTH(NUM*WIDTH)) inst_multiplexer (.i_a(o), .i_b(i), .sel(load), .o(o_mux));

always @(posedge clk or posedge rst) begin
	if (rst)
		o <= {(NUM*WIDTH){1'b0}};
	else
		o <= o_mux;
end

endmodule