////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : Backpropagation module
// File Name        : bp.v
// Version          : 1.0
// Description      : backpropagation calculation include:
//                    calculation of delta, dweight, dbias, and cost
//
////////////////////////////////////////////////////////////////////////////////

module bp(clk, rst, accu, i_hd_a, i_out_w, i_out_a, i_t, i_lr, i_k, o_cost, o_bias_o, o_bias_hd, o_wght_o, o_wght_hd);

// parameters
parameter N_IN = 2;
parameter N_HL_P = 3;
parameter N_OUT = 2;
parameter WIDTH = 32;
parameter FRAC = 24;

// common ports
input clk, rst;

// control ports
input accu;

// input ports
input signed [N_HL_P*WIDTH-1:0] i_hd_a;
input signed [N_HL_P*N_IN*WIDTH-1:0] i_out_w;
input signed [N_OUT*WIDTH-1:0] i_out_a;
input signed [N_OUT*WIDTH-1:0] i_t;

input signed [WIDTH-1:0] i_lr;
input signed [N_IN*WIDTH-1:0] i_k;

// output ports
output signed [WIDTH-1:0] o_cost;
output signed [N_OUT*WIDTH-1:0] o_bias_o;
output signed [N_HL_P*WIDTH-1:0] o_bias_hd;
output signed [N_HL_P*N_OUT*WIDTH-1:0] o_wght_o;
output signed [N_HL_P*N_IN*WIDTH-1:0] o_wght_hd;

// registers

// wires
wire signed [N_OUT*WIDTH-1:0] o_cost_dlt;
wire signed [N_OUT*WIDTH-1:0] o_dlto_dlt;
wire signed [N_HL_P*WIDTH-1:0] o_dlth_dlt;

delta_nn #(
		.N_IN(N_IN),
		.N_HL_P(N_HL_P),
		.N_OUT(N_OUT),
		.WIDTH(WIDTH)
	) dlt (
		.i_hd_a  (i_hd_a),
		.i_out_w (i_out_w),
		.i_out_a (i_out_a),
		.i_t     (i_t),
		.o_cost  (o_cost_dlt),
		.o_dlto  (o_dlto_dlt),
		.o_dlth  (o_dlth_dlt)
	);

cost_acc #(
		.WIDTH(WIDTH),
		.FRAC(FRAC),
		.N_OUT(N_OUT)
	) cost_calc (
		.clk (clk),
		.rst (rst),
		.en  (accu),
		.i_d (o_cost_dlt),
		.o   (o_cost)
	);

weight_bias_calc #(
		.N_IN(N_IN),
		.N_HL_P(N_HL_P),
		.N_OUT(N_OUT),
		.WIDTH(WIDTH)
	) wb_calc (
		.clk       (clk),
		.rst       (rst),
		.en        (accu),
		.i_lr      (i_lr),
		.i_k       (i_k),
		.i_hd_a    (i_hd_a),
		.i_dlto    (o_dlto_dlt),
		.i_dlth    (o_dlth_dlt),
		.o_bias_o  (o_bias_o),
		.o_bias_hd (o_bias_hd),
		.o_wght_o  (o_wght_o),
		.o_wght_hd (o_wght_hd)
	);


endmodule