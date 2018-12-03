////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : DNN Array Module
// File Name        : array.v
// Version          : 1.0
// Description      : DNN Array
//
////////////////////////////////////////////////////////////////////////////////

module array(clk, rst, wr, i, o);

// parameters
parameter N_IN = 2;
parameter N_OUT = 2;
parameter N_HL = 1;
parameter N_HL_P = 3;
parameter WIDTH = 32;

// common ports
input clk, rst;

// control ports
input wr;

// input ports
input signed [N_IN*WIDTH-1:0] i;

// output ports
output signed [N_OUT*WIDTH-1:0] o;

// wires
wire signed [N_IN*WIDTH-1:0] o_in_layr;
wire signed [N_HL_P*WIDTH-1:0] o_hd_layr;
wire signed [N_OUT*WIDTH-1:0] o_out_layr;

wire signed [N_IN*WIDTH-1:0] in_sto_reg;
wire signed [N_HL_P*WIDTH-1:0] hd_sto_reg;

wire load;

// registers
reg signed [N_IN*WIDTH-1:0] reg_in_layr;
reg signed [N_HL_P*WIDTH-1:0] reg_hd_layr;
reg signed [N_OUT*WIDTH-1:0] reg_out_layr;

///////////////////////////////////////////////////////////////////
// input layer, have N_IN input
in #(.NUM(N_IN), .WIDTH(WIDTH)) in_layr (.i(i), .o(o_in_layr));

// Input's Register Layer
always @(posedge clk or posedge rst) begin
	if (rst)
		reg_in_layr <= {N_IN*WIDTH{1'b0}};
	else 
		reg_in_layr <= o_in_layr;
end

// Input's Storage Register
sto_reg #(.WIDTH(N_IN*WIDTH)) in_sto (.clk(clk), .rst(rst), .load(load), .i(o_in_layr), .o(in_sto_reg));

///////////////////////////////////////////////////////////////////
// hidden layer, with N_IN number of inputs, and N_HL_P perceptrons
hidden #(.NUM_INPUT(N_IN), .NUM_PCTN(N_HL_P), .WIDTH(WIDTH)) hd_layr (
	.clk(clk),
	.rst(rst),
	.wr(wr),
	.i_k(reg_in_layr),
	.i_w(),
	.i_b(),
	.o_a (o_hd_layr),
	.o_w (),
	.o_b ()
); 

// Hidden 1's Register Layer
always @(posedge clk or posedge rst) begin
	if (rst)
		reg_hd_layr <= {N_HL_P*WIDTH{1'b0}};
	else 
		reg_hd_layr <= o_hd_layr;
end

// Hidden 1's Storage Register
sto_reg #(.WIDTH(N_HL_P*WIDTH)) hd_sto (.clk(clk), .rst(rst), .load(load), .i(o_hd_layr), .o(hd_sto_reg));

////////////////////////////////////////////////////////////////////
// output layer, with N_HL_P number of inputs, and N_OUT perceptrons
out #(.NUM_INPUT(N_HL_P), .NUM_PCTN(N_OUT), .WIDTH(WIDTH)) ot_layr (
	.clk(clk),
	.rst(rst),
	.wr(wr),
	.i_k(reg_hd_layr),
	.i_w(),
	.i_b(),
	.o(o_out_layr)
);

// Output Register Layer
always @(posedge clk or posedge rst) begin
	if (rst)
		reg_out_layr <= {N_OUT*WIDTH{1'b0}};
	else 
		reg_out_layr <= o_out_layr;
end

assign o = reg_out_layr;
endmodule