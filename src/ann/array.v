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

module array(clk, rst, wr, accu, rst_btch, load, i_k, i_t, i_lr, o_cost, o_1, o_2);

// parameters
parameter N_IN = 2;
parameter N_OUT = 2;
parameter N_HL = 1;
parameter N_HL_P = 3;
parameter WIDTH = 32;
parameter FRAC = 24;

// common ports
input clk, rst;

// control ports
input wr;
input accu;
input rst_btch;
input load;

// input ports
input signed [N_IN*WIDTH-1:0] i_k;
input signed [N_OUT*WIDTH-1:0] i_t;
input signed [WIDTH-1:0] i_lr;

// output ports
// output signed [N_OUT*WIDTH-1:0] o;
output signed [WIDTH-1:0] o_cost;
output signed [WIDTH-1:0] o_1;
output signed [WIDTH-1:0] o_2;

// wires
wire signed [N_IN*WIDTH-1:0] o_in_layr;
wire signed [N_HL_P*WIDTH-1:0] o_hd_layr;
wire signed [N_OUT*WIDTH-1:0] o_o_layr;

wire signed [N_IN*WIDTH-1:0] in_sto_reg;
wire signed [N_HL_P*WIDTH-1:0] hd_sto_reg;

wire signed [N_HL_P*N_OUT*WIDTH-1:0] w_o_layr;
wire signed [N_HL_P*N_IN*WIDTH-1:0] w_hd_layr;
wire signed [N_OUT*WIDTH-1:0] b_o_layr;
wire signed [N_HL_P*WIDTH-1:0] b_hd_layr;

wire signed [N_HL_P*N_OUT*WIDTH-1:0] wght_o_bp;
wire signed [N_HL_P*N_IN*WIDTH-1:0] wght_hd_bp;
wire signed [N_OUT*WIDTH-1:0] bias_o_bp;
wire signed [N_HL_P*WIDTH-1:0] bias_hd_bp;

wire signed [N_HL_P*N_OUT*WIDTH-1:0] wght_o_new;
wire signed [N_HL_P*N_IN*WIDTH-1:0] wght_hd_new;
wire signed [N_OUT*WIDTH-1:0] bias_o_new;
wire signed [N_HL_P*WIDTH-1:0] bias_hd_new;

// registers
reg signed [N_IN*WIDTH-1:0] reg_in_layr;
reg signed [N_HL_P*WIDTH-1:0] reg_hd_layr;
reg signed [N_OUT*WIDTH-1:0] reg_o_layr;

///////////////////////////////////////////////////////////////////
// input layer, have N_IN input
in #(.NUM(N_IN), .WIDTH(WIDTH)) in_layr (.i(i_k), .o(o_in_layr));

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
		.i_w(wght_hd_new),
		.i_b(bias_hd_new),
		.o_a(o_hd_layr),
		.o_w(w_hd_layr),
		.o_b(b_hd_layr)
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
out #(.NUM_INPUT(N_HL_P), .NUM_PCTN(N_OUT), .WIDTH(WIDTH)) o_layr (
		.clk(clk),
		.rst(rst),
		.wr(wr),
		.i_k(reg_hd_layr),
		.i_w(wght_o_new),
		.i_b(bias_o_new),
		.o_a(o_o_layr),
		.o_w(w_o_layr),
		.o_b(b_o_layr)
	);

// Output Register Layer
always @(posedge clk or posedge rst) begin
	if (rst)
		reg_o_layr <= {N_OUT*WIDTH{1'b0}};
	else 
		reg_o_layr <= o_o_layr;
end

// assign o = reg_o_layr;

//////////////////////////////////////////////////////////////////////////////////
// Backpropagation,
bp #(.N_IN(N_IN), .N_HL_P(N_HL_P), .N_OUT(N_OUT), .WIDTH(WIDTH), .FRAC(FRAC)) bp (
		.clk       (clk),
		.rst       (rst),
		.accu      (accu),
		.rst_btch  (rst_btch),
		.i_hd_a    (hd_sto_reg),
		.i_out_w   (w_o_layr),
		.i_out_a   (reg_o_layr),
		.i_t       (i_t),
		.i_lr      (i_lr),
		.i_k       (i_k),
		.o_cost    (o_cost),
		.o_bias_o  (bias_o_bp),
		.o_bias_hd (bias_hd_bp),
		.o_wght_o  (wght_o_bp),
		.o_wght_hd (wght_hd_bp)
	);

// Calculation of new Weight and Bias
adder_2in #(.WIDTH(WIDTH)) add_w_o[N_HL_P*N_OUT-1:0] (.i_a(w_o_layr),  .i_b(wght_o_bp),  .o(wght_o_new));
adder_2in #(.WIDTH(WIDTH)) add_w_hd[N_HL_P*N_IN-1:0] (.i_a(w_hd_layr), .i_b(wght_hd_bp), .o(wght_hd_new));
adder_2in #(.WIDTH(WIDTH)) add_b_o[N_OUT-1:0]   (.i_a(b_o_layr),  .i_b(bias_o_bp),  .o(bias_o_new));
adder_2in #(.WIDTH(WIDTH)) add_b_hd[N_HL_P-1:0] (.i_a(b_hd_layr), .i_b(bias_hd_bp), .o(bias_hd_new));

// Assigning Output
assign o_1 = reg_o_layr[WIDTH-1:0];
assign o_2 = reg_o_layr[2*WIDTH-1:WIDTH];

endmodule