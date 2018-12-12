////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : Bias Accumulator
// File Name        : bias_add.v
// Version          : 1.0
// Description      : accumulator for bias 
//
////////////////////////////////////////////////////////////////////////////////

module bias_acc (clk, rst, en, i, o);

// parameters
parameter WIDTH=32;

// input ports 
input signed [WIDTH-1:0] i;

// common ports
input clk;
input rst;

// control ports
input en;

// register ports 
reg signed [WIDTH-1:0] reg_adder;

// output ports
output signed[WIDTH-1:0] o;

wire signed [WIDTH-1:0] o_adder;
wire signed [WIDTH-1:0] o_mux;

multiplexer #(.WIDTH(WIDTH)) mux (.i_a(32'h0), .i_b(i), .sel(en), .o(o_mux));

assign o_adder = reg_adder + o_mux;

always @(posedge clk or posedge rst) begin
	if (rst) begin
		reg_adder <= 32'd0;
	end
	else
		reg_adder <= o_adder;
end

assign o = reg_adder;

endmodule
