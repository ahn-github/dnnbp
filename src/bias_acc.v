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

module bias_acc (clk, en, i, o);

// parameters
parameter WIDTH=32;

// input ports 
input signed [WIDTH-1:0] i;

// common ports
input clk;

// control ports
input en;

// register ports 
reg signed [WIDTH-1:0] reg_adder;

// output ports
output signed[WIDTH-1:0] o;

wire signed [WIDTH-1:0] adder;
wire signed [WIDTH-1:0] outmux;

// module
multiplexer #(.WIDTH(32)) inst_multiplexer (.input_a(32'h0), .input_b(reg_adder), .sel(en), .o(outmux));

assign adder = i+ outmux;

always @(posedge clk or en)
begin
	reg_adder <= adder;
end;

assign o = reg_adder;

endmodule
