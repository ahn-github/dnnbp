////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : Weight Accumulator
// File Name        : wght_acc.v
// Version          : 1.0
// Description      : accumulator for weight
//
////////////////////////////////////////////////////////////////////////////////

module wght_acc (clk, rst, en, i_d, i_x, o);

// parameters
parameter WIDTH = 32;
parameter FRAC = 24;

// input ports 
input signed [WIDTH-1:0] i_d;
input signed [WIDTH-1:0] i_x;

// common ports
input clk, rst;

// control ports
input en;

// register ports 
reg signed [WIDTH-1:0] reg_adder;

// output ports
output signed[WIDTH-1:0] o;

wire signed [WIDTH-1:0] o_adder;
wire signed [WIDTH-1:0] o_mult;
wire signed [WIDTH-1:0] o_mux;

mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) mult (.i_a(i_d), .i_b(i_x), .o(o_mult));
multiplexer #(.WIDTH(WIDTH)) mux (.i_a(32'h0), .i_b(o_mult), .sel(en), .o(o_mux));

assign o_adder = reg_adder + o_mux;

always @(posedge clk or posedge rst) begin
	if (rst)
		reg_adder <= 32'd0;
	else
		reg_adder <= o_adder;
end

assign o = reg_adder;

endmodule