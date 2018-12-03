////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : Delta Calculation Testbench Module
// File Name        : delta_nn_tb.v
// Version          : 1.0
// Description      : a Testbench for Delta Calculation Module
//
////////////////////////////////////////////////////////////////////////////////

module delta_nn_tb();

// parameters
parameter N_IN = 2;
parameter N_HL_P = 3;
parameter N_OUT = 2;
parameter WIDTH = 32;

// registers
reg signed [N_HL_P*WIDTH-1:0] i_hd_a;
reg signed [N_HL_P*N_IN*WIDTH-1:0] i_out_w;
reg signed [N_OUT*WIDTH-1:0] i_out_a;
reg signed [N_OUT*WIDTH-1:0] i_t;

// wires
wire signed [N_OUT*WIDTH-1:0] o_cost;
wire signed [N_OUT*WIDTH-1:0] o_dlto;
wire signed [N_HL_P*WIDTH-1:0] o_dlth;

delta_nn #(
		.N_IN(N_IN),
		.N_HL_P(N_HL_P),
		.N_OUT(N_OUT),
		.WIDTH(WIDTH)
	) dut (
		.i_hd_a  (i_hd_a),
		.i_out_w  (i_out_w),
		.i_out_a (i_out_a),
		.i_t     (i_t),
		.o_cost  (o_cost),
		.o_dlto  (o_dlto),
		.o_dlth  (o_dlth)
	);

initial
begin
	i_out_w <= 192'h01199999_014ccccc_00800000_00333332_00333332_00b33333;

	// i_out_a <= o2hd3, o1hd3, o2hd2, o1hd2, o2hd1, o1hd1

	// 8,8
	// i_hd_a <= 96'h00e92147_00ef2148_00f37fff;
	// i_out_a <= 64'h00a86d19_00bd0f28;
	// i_t <= 64'h01000000_00000000;

	// 8,5
	// i_hd_a <= 96'h00f12665_00e84ffe_00efbfff;
	// i_out_a <= 64'h00a96e8e_00be4973;
	// i_t <= 64'h00000000_01000000;

	// 5,8
	// i_hd_a <= 96'h00e6a1eb_00faa147_00db91e9;
	// i_out_a <= 64'h00a809fb_00b8223a;
	// i_t <= 64'h00000000_01000000;

	// 5,5
	i_hd_a <= 96'h00ec7ffe_00f37fff_00d13ffd;
	i_out_a <= 64'h00a837e6_00b7f2bc;
	i_t <= 64'h00000000_01000000;

end

endmodule