////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : Array with backpropagation Module
// File Name        : array_bp.v
// Version          : 2.0
// Description      : array + bp
//                    
///////////////////////////////////////////////////////////////////////////////

module array_bp (clk, rst, sel, load_in, load_bp, load_t, load_h, i_w_a, i_w_i, i_w_f, i_w_o,  
i_b_a, i_b_i, i_b_f, i_b_o, i_addr_t, o_h);

// parameters
parameter WIDTH = 32;
parameter FRAC = 24;
parameter NUM = 45;
parameter NUM_LSTM = 8;
parameter NUM_ITERATIONS = 8;
parameter FILENAMEA="mem_wghta.list";
parameter FILENAMEI="mem_wghti.list";
parameter FILENAMEF="mem_wghtf.list";
parameter FILENAMEO="mem_wghto.list";

// control ports
input clk, rst, sel, load_in, load_bp, load_t, load_h;

// input ports for backpropagation
input signed [(NUM+NUM_LSTM)*WIDTH-1:0] i_w_a;
input signed [(NUM+NUM_LSTM)*WIDTH-1:0] i_w_i;
input signed [(NUM+NUM_LSTM)*WIDTH-1:0] i_w_f;
input signed [(NUM+NUM_LSTM)*WIDTH-1:0] i_w_o;
input signed [WIDTH-1:0] i_b_a;
input signed [WIDTH-1:0] i_b_i;
input signed [WIDTH-1:0] i_b_f;
input signed [WIDTH-1:0] i_b_o;
input signed [WIDTH-1:0] i_addr_t;

// output ports
output signed [NUM_LSTM*WIDTH-1:0] o_h;

// wires
wire signed [WIDTH-1:0] addrinput;
wire signed [WIDTH-1:0] x_t, t_t;
wire signed [NUM*WIDTH-1:0] temp_input_lstm;
wire signed [NUM*WIDTH-1:0] input_lstm;
wire signed [(NUM+NUM_LSTM)*WIDTH-1:0] c_x;
wire signed [NUM_ITERATIONS*(NUM+NUM_LSTM)*WIDTH-1:0] all_c_x;

wire signed [NUM_LSTM*WIDTH-1:0] o_h;
wire signed [NUM_LSTM*WIDTH-1:0] l_c, l_a, l_i, l_f, l_o;

wire signed [8*WIDTH-1:0] all_t, reg_t;

wire signed [NUM_LSTM*(NUM+NUM_LSTM)*WIDTH-1:0] w_a;
wire signed [NUM_LSTM*(NUM+NUM_LSTM)*WIDTH-1:0] w_i;
wire signed [NUM_LSTM*(NUM+NUM_LSTM)*WIDTH-1:0] w_f;
wire signed [NUM_LSTM*(NUM+NUM_LSTM)*WIDTH-1:0] w_o;
wire signed [WIDTH-1:0] b_a;
wire signed [WIDTH-1:0] b_i;
wire signed [WIDTH-1:0] b_f;
wire signed [WIDTH-1:0] b_o;


////////////////////////////////////////////
// Input Memory
addr_x #(
		.WIDTH(WIDTH),
		.NUM(NUM),
		.NUM_ITERATIONS(NUM_ITERATIONS)
	) addr_gen (
		.clk (clk),
		.rst (rst),
		.count (addrinput)
	);

mem_input_x #(
		.WIDTH(WIDTH),
		.NUM(NUM),
		.NUM_ITERATIONS(NUM_ITERATIONS)
	) in_mem (
		.addr (addrinput),
		.data (x_t)
	);

shift_reg #(
		.NUM_ITERATIONS(NUM),
		.WIDTH(WIDTH)
	) in_sr (
		.clk (clk),
		.rst (rst),
		.i   (x_t),
		.o   (temp_input_lstm)
	);

sto_reg #(.WIDTH(WIDTH), .NUM(NUM)) in_sto (.clk(clk), .rst(rst), .load(load_in), .i(temp_input_lstm), .o(input_lstm));


/////////////////////////////////////////////
// Label Memory
mem_t #(
		.WIDTH(WIDTH),
		.NUM(8),
		.NUM_ITERATIONS(2)
	) mem_t (
		.addr (i_addr_t),
		.data (t_t)
	);

shift_reg_en #(
		.NUM_ITERATIONS(8),
		.WIDTH(WIDTH)
	) t_sr (
		.clk (clk),
		.rst (rst),
		.en (load_t),
		.i   (t_t),
		.o   (all_t)
	);


/////////////////////////////////////////////
// LSTM Layers
lstm #(
		.WIDTH(WIDTH),
		.NUM(NUM),
		.NUM_LSTM(NUM_LSTM)
	) lstm_layr (
		.clk   (clk),
		.rst   (rst),
		.sel   (sel),
		.load_h(load_h),
		.i_x   (input_lstm),
		.i_w_a (i_w_a),
		.i_w_i (i_w_i),
		.i_w_f (i_w_f),
		.i_w_o (i_w_o),
		.i_b_a (i_b_a),
		.i_b_i (i_b_i),
		.i_b_f (i_b_f),
		.i_b_o (i_b_o),
		.o_h   (o_h),
		.o_c   (l_c),
		.o_a   (l_a),
		.o_i   (l_i),
		.o_f   (l_f),
		.o_o   (l_o),
		.o_w_a (w_a),
		.o_w_i (w_i),
 		.o_w_f (w_f),
		.o_w_o (w_o),
		.o_b_a (b_a),
		.o_b_i (b_i),
		.o_b_f (b_f),
		.o_b_o (b_o),
		.o_c_x (c_x)
	);

/////////////////////////////////////////////////
// Registers for concatenated inputs
shift_reg_en #(
	.NUM_ITERATIONS(NUM_ITERATIONS), .WIDTH((NUM+NUM_LSTM)*WIDTH)
) inst_shift_reg_en (
	.clk (clk), 
	.rst (rst), 
	.en  (load_bp),
	.i   (c_x),
	.o   (all_c_x)
);


generate
	genvar i;

	////////////////////////////////////////////////
	// Registers for gates output
	for (i = 0; i < NUM_LSTM; i = i + 1)
	begin:bp_mod

		wire signed [NUM_ITERATIONS*WIDTH-1:0] all_h, all_c, all_a, all_i, all_f, all_o;

		// Registers for h
		shift_reg_en #(
			.NUM_ITERATIONS(NUM_ITERATIONS), .WIDTH(WIDTH)
		) h_sr (
			.clk (clk), .rst (rst), .en  (load_bp),
			.i   (o_h [ (i+1)*WIDTH-1 : i*WIDTH ]),
			.o   (all_h)
		);

		// Registers for c
		shift_reg_en #(
			.NUM_ITERATIONS(NUM_ITERATIONS), .WIDTH(WIDTH)
		) c_sr (
			.clk (clk), .rst (rst), .en  (load_bp),
			.i   (l_c [ (i+1)*WIDTH-1 : i*WIDTH ]),
			.o   (all_c)
		);

		// Registers for a
		shift_reg_en #(
				.NUM_ITERATIONS(NUM_ITERATIONS), .WIDTH(WIDTH)
			) a_sr (
				.clk (clk), .rst (rst), .en(load_bp),
				.i   (l_a [ (i+1)*WIDTH-1 : i*WIDTH ]),
				.o (all_a)
			);

		// Registers for i
		shift_reg_en #(
				.NUM_ITERATIONS(NUM_ITERATIONS), .WIDTH(WIDTH)
			) i_sr (
				.clk (clk), .rst (rst), .en(load_bp),
				.i   (l_i [ (i+1)*WIDTH-1 : i*WIDTH ]),
				.o (all_i)
			);

		// Registers for f
		shift_reg_en #(
				.NUM_ITERATIONS(NUM_ITERATIONS), .WIDTH(WIDTH)
			) f_sr (
				.clk (clk), .rst (rst), .en(load_bp),
				.i   (l_f [ (i+1)*WIDTH-1 : i*WIDTH ]),
				.o (all_f)
			);

		// Registers for o
		shift_reg_en #(
				.NUM_ITERATIONS(NUM_ITERATIONS), .WIDTH(WIDTH)
			) o_sr (
				.clk (clk), .rst (rst), .en(load_bp),
				.i   (l_o [ (i+1)*WIDTH-1 : i*WIDTH ]),
				.o (all_o)
			);

		wire signed [4*WIDTH-1:0] b;
		wire signed [(NUM+NUM_LSTM)*WIDTH-1:0] wa;
		wire signed [(NUM+NUM_LSTM)*WIDTH-1:0] wi;
		wire signed [(NUM+NUM_LSTM)*WIDTH-1:0] wf;
		wire signed [(NUM+NUM_LSTM)*WIDTH-1:0] wo;

		bp #(
			.WIDTH(WIDTH),
			.FRAC(FRAC),
			.TIMESTEP(NUM_ITERATIONS),
			.NUM(NUM),
			.NUM_LSTM(NUM_LSTM)
		) bp (
			.i_x  (all_c_x),
			.i_t  ({NUM_ITERATIONS{all_t[ (i+1)*WIDTH-1 : i*WIDTH ]}}),
			.i_h  (all_h),
			.i_c  (all_c),
			.i_a  (all_a),
			.i_i  (all_i),
			.i_f  (all_f),
			.i_o  (all_o),
			.i_wa (w_a[ (i+1)*(NUM+NUM_LSTM)*WIDTH-1 : i*(NUM+NUM_LSTM)*WIDTH ]),
			.i_wo (w_o[ (i+1)*(NUM+NUM_LSTM)*WIDTH-1 : i*(NUM+NUM_LSTM)*WIDTH ]),
			.i_wi (w_i[ (i+1)*(NUM+NUM_LSTM)*WIDTH-1 : i*(NUM+NUM_LSTM)*WIDTH ]),
			.i_wf (w_f[ (i+1)*(NUM+NUM_LSTM)*WIDTH-1 : i*(NUM+NUM_LSTM)*WIDTH ]),
			.o_b  (b),
			.o_wa (wa),
			.o_wi (wi),
			.o_wf (wf),
			.o_wo (wo)
		);
	end
endgenerate


endmodule












