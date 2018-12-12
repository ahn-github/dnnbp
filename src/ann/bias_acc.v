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

module bias_acc (clk, rst, en, i_d, i_lr, o);

// parameters
parameter WIDTH=32;

// input ports 
input signed [WIDTH-1:0] i_d;
input signed [WIDTH-1:0] i_lr;

// common ports
input clk;
input rst;

// control ports
input en;

// register ports 
reg signed [WIDTH-1:0] reg_adder;

// output ports
output signed[WIDTH-1:0] o;

wire signed [WIDTH-1:0] adder;
wire signed [WIDTH-1:0] outmult;
wire signed [WIDTH-1:0] outmux;

mult_2in #(.WIDTH(WIDTH), .FRAC(24)) mult (.i_a(i_d), .i_b(i_lr), .o(outmult));
multiplexer #(.WIDTH(WIDTH)) mux (.i_a(32'h0), .i_b(outmult), .sel(en), .o(outmux));

assign adder = reg_adder + outmux;

always @(posedge clk or posedge rst) begin
	if (rst) begin
		reg_adder <= 32'd0;
	end
	else
		reg_adder <= adder;
end

assign o = reg_adder;

endmodule
