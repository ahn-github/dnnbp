////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : Backpropagation Testbench module
// File Name        : bp_tb.v
// Version          : 1.0
// Description      : a testbench to test LSTM Backpropagation Module
//
////////////////////////////////////////////////////////////////////////////////

module bp_tb();

// parameters
parameter WIDTH = 32;
parameter FRAC = 24;
parameter TIMESTEP = 2;
parameter NUM = 3; // Number of Inputs + 1 (prev Output)

// common ports

// control ports

// registers
reg signed [TIMESTEP*WIDTH-1:0] i_t, i_h, i_c, i_a, i_i, i_f, i_o;
reg signed [TIMESTEP*NUM*WIDTH-1:0] i_x;
reg signed [NUM*WIDTH-1:0] i_wa, i_wo, i_wi, i_wf;

// wires
wire signed [4*WIDTH-1:0] o_b;
wire signed [NUM*WIDTH-1:0] o_wa;
wire signed [NUM*WIDTH-1:0] o_wi;
wire signed [NUM*WIDTH-1:0] o_wf;
wire signed [NUM*WIDTH-1:0] o_wo;

bp #(
		.WIDTH(WIDTH),
		.FRAC(FRAC),
		.TIMESTEP(TIMESTEP),
		.NUM(NUM)
	) inst_bp (
		.i_x      (i_x),
		.i_t      (i_t),
		.i_h      (i_h),
		.i_c      (i_c),
		.i_a      (i_a),
		.i_i      (i_i),
		.i_f      (i_f),
		.i_o      (i_o),
		.i_wa     (i_wa),
		.i_wo     (i_wo),
		.i_wi     (i_wi),
		.i_wf     (i_wf),
		.o_b      (o_b),
		.o_wa     (o_wa),
		.o_wi     (o_wi),
		.o_wf     (o_wf),
		.o_wo     (o_wo)
	);

initial
begin
	i_x <= 192'h00894b9c_03000000_00800000_00000000_02000000_01000000;
	i_wa <= 96'h00266666_00400000_00733333;
	i_wi <= 96'h00cccccc_00cccccc_00f33333;
	i_wf <= 96'h00199999_00733333_00b33333;
	i_wo <= 96'h00400000_00666666_00999999;

	i_t <= 64'h01400000_00800000;
	i_h <= 64'h00c59fd3_00894b9c;
	i_c <= 64'h0184816f_00c924f2;//fffdcbbd
	i_a <= 64'h00d98c7e_00d15810;
	i_i <= 64'h00fb2e9c_00f5f8f4;
	i_f <= 64'h00decbfb_00da1965;
	i_o <= 64'h00d99503_00d14c44;
	#500;
end

// tap wire
wire signed [WIDTH-1:0] bo, bf, bi, ba;
assign bo = o_b[ 4*WIDTH-1 : 3*WIDTH ];
assign bf = o_b[ 3*WIDTH-1 : 2*WIDTH ];
assign bi = o_b[ 2*WIDTH-1 : 1*WIDTH ];
assign ba = o_b[ 1*WIDTH-1 : 0*WIDTH ];

generate
	genvar i;
	for (i = NUM; i > 0; i = i - 1)
	begin:weights
		wire signed [WIDTH-1:0] wo, wf, wi, wa;
		assign wo = o_wo[ i*WIDTH-1 : (i-1)*WIDTH ];
		assign wf = o_wf[ i*WIDTH-1 : (i-1)*WIDTH ];
		assign wi = o_wi[ i*WIDTH-1 : (i-1)*WIDTH ];
		assign wa = o_wa[ i*WIDTH-1 : (i-1)*WIDTH ];
	end
endgenerate

endmodule