////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : Backpropagation Testbench module
// File Name        : bp_tb.v
// Version          : 1.0
// Description      : a Testbench for Backpropagation calculation module
//
////////////////////////////////////////////////////////////////////////////////

module bp_tb();

// parameters
parameter N_IN = 2;
parameter N_HL_P = 3;
parameter N_OUT = 2;
parameter WIDTH = 32;
parameter FRAC = 24;

// register
reg clk, rst;
reg accu;
reg cost_rst;
reg signed [WIDTH-1:0] i_lr;
reg signed [N_HL_P*N_IN*WIDTH-1:0] i_out_w;
reg signed [N_HL_P*WIDTH-1:0] i_hd_a;
reg signed [N_OUT*WIDTH-1:0] i_out_a;
reg signed [N_IN*WIDTH-1:0] i_k;
reg signed [N_OUT*WIDTH-1:0] i_t;

// wires
wire signed [WIDTH-1:0] o_cost;
wire signed [N_OUT*WIDTH-1:0] o_bias_o;
wire signed [N_HL_P*WIDTH-1:0] o_bias_hd;
wire signed [N_HL_P*N_OUT*WIDTH-1:0] o_wght_o;
wire signed [N_HL_P*N_IN*WIDTH-1:0] o_wght_hd;

bp #(
		.N_IN(N_IN),
		.N_HL_P(N_HL_P),
		.N_OUT(N_OUT),
		.WIDTH(WIDTH),
		.FRAC(FRAC)
	) dut (
		.clk       (clk),
		.rst       (rst),
		.accu      (accu),
		.cost_rst  (cost_rst),
		.i_hd_a    (i_hd_a),
		.i_out_w   (i_out_w),
		.i_out_a   (i_out_a),
		.i_t       (i_t),
		.i_lr      (i_lr),
		.i_k       (i_k),
		.o_cost    (o_cost),
		.o_bias_o  (o_bias_o),
		.o_bias_hd (o_bias_hd),
		.o_wght_o  (o_wght_o),
		.o_wght_hd (o_wght_hd)
	);

initial
begin
	clk = 1;
	rst = 1;
	accu = 0;
	i_lr = 32'h0019999a;
	cost_rst <= 1;
	i_out_w <= 192'h01199999_014ccccc_00800000_00333332_00333332_00b33333;

	// i_out_a <= o2hd3, o1hd3, o2hd2, o1hd2, o2hd1, o1hd1

	// own's value
	// 8,8
	i_hd_a = 96'h00e92147_00ef2148_00f37fff;
	i_out_a <= 64'h00a86d19_00bd0f28;
	i_k = 64'h08000000_08000000;
	i_t <= 64'h01000000_00000000;
	#100;
	rst <= 0;
	cost_rst <= 0;
	#300;
	$display("%x, %x, %x, %x, %x\n", o_cost, o_bias_o, o_bias_hd, o_wght_o, o_wght_hd);
	#100;

	// 8,5
	i_hd_a <= 96'h00f12665_00e84ffe_00efbfff;
	i_out_a <= 64'h00a96e8e_00be4973;
	i_k <= 64'h08000000_05000000;
	i_t <= 64'h00000000_01000000;
	#300;
	$display("%x, %x, %x, %x, %x\n", o_cost, o_bias_o, o_bias_hd, o_wght_o, o_wght_hd);
	#100;

	// 5.8
	i_hd_a <= 96'h00e6a1eb_00faa147_00db91e9;
	i_out_a <= 64'h00a809fb_00b8223a;
	i_k <= 64'h05000000_08000000;
	i_t <= 64'h00000000_01000000;
	#300;
	$display("%x, %x, %x, %x, %x\n", o_cost, o_bias_o, o_bias_hd, o_wght_o, o_wght_hd);
	#100;

	// 5,5
	i_hd_a <= 96'h00ec7ffe_00f37fff_00d13ffd;
	i_out_a <= 64'h00a837e6_00b7f2bc;
	i_k <= 64'h05000000_05000000;
	i_t <= 64'h00000000_01000000;
	#300;
	$display("%x, %x, %x, %x, %x\n", o_cost, o_bias_o, o_bias_hd, o_wght_o, o_wght_hd);
	#100;
end

always
begin
	#50
	clk = !clk;
end

always
begin
	#100
	accu <= !accu;
	#100
	accu <= !accu;
	#200;
end

endmodule