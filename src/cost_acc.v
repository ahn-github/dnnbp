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

module cost_acc(clk, rst, en, i_d1, i_d2, o);

// parameters
parameter WIDTH = 32;
parameter FRAC = 24;

// common ports
input clk;
input rst;

// control ports
input en;

// input ports
input signed [WIDTH-1:0] i_d1;
input signed [WIDTH-1:0] i_d2;

// output ports
output signed [WIDTH-1:0] o;

// registers
reg signed [WIDTH-1:0] acc;

// wires
wire signed [WIDTH-1:0] o_mult_d1;
wire signed [WIDTH-1:0] o_mult_d2;
wire signed [WIDTH-1:0] add_sr;

mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) mult_d1 (.i_a(i_d1), .i_b(i_d1), .o(o_mult_d1));
mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) mult_d2 (.i_a(i_d2), .i_b(i_d2), .o(o_mult_d2));
assign add_sr = (o_mult_d1 + o_mult_d2) >> 1;

always @(posedge clk or posedge rst) begin
	if (rst) begin
		acc = 32'd0;
	end
	else if (en) begin
		acc = acc + add_sr;
	end
end

assign o = acc;
endmodule