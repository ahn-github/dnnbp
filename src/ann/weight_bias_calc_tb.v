module weight_bias_calc_tb();

// parameters
parameter N_IN = 2;
parameter N_HL_P = 3;
parameter N_OUT = 2;
parameter WIDTH = 32;

// registers
reg clk, rst;
reg en;
reg signed [WIDTH-1:0] i_lr;
reg signed [N_IN*WIDTH-1:0] i_k;
reg signed [N_HL_P*WIDTH-1:0] i_hd_a;
reg signed [N_OUT*WIDTH-1:0] i_dlto;
reg signed [N_HL_P*WIDTH-1:0] i_dlth;

// wires
wire signed [N_OUT*WIDTH-1:0] o_bias_o;
wire signed [N_HL_P*WIDTH-1:0] o_bias_hd;
wire signed [N_HL_P*N_OUT*WIDTH-1:0] o_wght_o;
wire signed [N_HL_P*N_IN*WIDTH-1:0] o_wght_hd;

weight_bias_calc #(
		.N_IN(N_IN),
		.N_HL_P(N_HL_P),
		.N_OUT(N_OUT),
		.WIDTH(WIDTH)
	) dut (
		.clk       (clk),
		.rst       (rst),
		.en        (en),
		.i_lr      (i_lr),
		.i_k       (i_k),
		.i_hd_a    (i_hd_a),
		.i_dlto    (i_dlto),
		.i_dlth    (i_dlth),
		.o_bias_o  (o_bias_o),
		.o_bias_hd (o_bias_hd),
		.o_wght_o  (o_wght_o),
		.o_wght_hd (o_wght_hd)
	);

initial
begin
	clk = 1;
	rst = 1;
	en = 0;
	i_lr = 32'h0019999a;
	// own value
	// 8,8
	i_k = 64'h08000000_08000000;
	i_hd_a = 96'h00e92147_00ef2148_00f37fff;
	i_dlto = 64'hffec4a56_00248272;
	i_dlth = 96'h000218f5_ffffd7c5_000100fe;

	#100;
	rst = 0;
	#400;
	// 8,5
	i_k <= 64'h08000000_05000000;
	i_hd_a <= 96'h00f12665_00e84ffe_00efbfff;
	i_dlto <= 64'h0025eb85_fff3763d;
	i_dlth <= 96'h0001637c_000161a8_ffffedd9;
	#400;
	// 5.8
	i_k <= 64'h05000000_08000000;
	i_hd_a <= 96'h00e6a1eb_00faa147_00db91e9;
	i_dlto <= 64'h0025e634_fff17d21;
	i_dlth <= 96'h000209a1_0000545e_ffffaf73;
	#400;
	// 5,5
	i_k <= 64'h05000000_05000000;
	i_hd_a <= 96'h00ec7ffe_00f37fff_00d13ffd;
	i_dlto <= 64'h0025e71a_fff16db0;
	i_dlth <= 96'h000199d6_0000bead_ffff9be7;
end

always
begin
	#50;
	clk <= !clk;
end

always
begin
	#100;
	en <= !en;
	#100;
	en <= !en;
	#200;
end
endmodule