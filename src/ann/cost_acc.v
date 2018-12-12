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

module cost_acc(clk, rst, en, i_d, o);

// parameters
parameter WIDTH = 32;
parameter FRAC = 24;
parameter N_OUT = 2;

// common ports
input clk;
input rst;

// control ports
input en;

// input ports
input signed [N_OUT*WIDTH-1:0] i_d;

// output ports
output signed [WIDTH-1:0] o;

// register
reg signed [WIDTH-1:0] reg_adder;

// wires
wire signed [N_OUT*WIDTH-1:0] o_mult;
wire signed [WIDTH-1:0] o_add;
wire signed [WIDTH-1:0] sr;
wire signed [WIDTH-1:0] o_mux;
wire signed [WIDTH-1:0] o_adder;

mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) mult[N_OUT-1:0] (.i_a(i_d), .i_b(i_d), .o(o_mult));

adder #(.NUM(N_OUT), .WIDTH(WIDTH)) add (.i(o_mult), .o(o_add));

assign sr = (o_add) >> 1;

multiplexer #(.WIDTH(WIDTH)) mux (.i_a(32'h0), .i_b(sr), .sel(en), .o(o_mux));

assign o_adder = reg_adder + o_mux;

always @(posedge clk or posedge rst) begin
	if (rst)
		reg_adder <= 32'd0;
	else
		reg_adder <= o_adder;
end

assign o = reg_adder;

endmodule