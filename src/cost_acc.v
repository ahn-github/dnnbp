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

// wires
wire signed [WIDTH-1:0] o_mult_d1;
wire signed [WIDTH-1:0] o_mult_d2;
wire signed [WIDTH-1:0] o_add;
wire signed [WIDTH-1:0] sr;
wire signed [WIDTH-1:0] temp2;
wire signed [WIDTH-1:0] temp1;

// registers
reg signed [WIDTH-1:0] o;

mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) mult_d1 (.i_a(i_d1), .i_b(i_d1), .o(o_mult_d1));
mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) mult_d2 (.i_a(i_d2), .i_b(i_d2), .o(o_mult_d2));

adder #(.NUM(NUM), .WIDTH(WIDTH)) add (.i({o_mult_d1, o_mult_d2}), .o(o_add));
assign sr = (o_add) >> 1;

adder #(.NUM(NUM), .WIDTH(WIDTH)) acc (.i({sr, temp1}), .o(temp2));

always @(posedge clk or posedge rst) begin
	if (rst) begin
		o <= 32'd0;
	end
	else
		o <= temp2;
end

assign temp1 = en ? o : 32'd0;

endmodule