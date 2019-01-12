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

module array_bp (clk, rst, sel, load_in, load_bp, load_t, load_h, wr, i_addr_t, o_h, o_cost);

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
input clk, rst, sel, load_in, load_bp, load_t, load_h, wr;

// input ports for backpropagation
input signed [WIDTH-1:0] i_addr_t;

// output ports
output signed [NUM_LSTM*WIDTH-1:0] o_h;
output signed [WIDTH-1:0] o_cost;

// wires
wire signed [WIDTH-1:0] addrinput;
wire signed [WIDTH-1:0] x_t, t_t;
wire signed [NUM*WIDTH-1:0] temp_input_lstm;
wire signed [NUM*WIDTH-1:0] input_lstm;
wire signed [(NUM+NUM_LSTM)*WIDTH-1:0] c_x;
wire signed [NUM_ITERATIONS*(NUM+NUM_LSTM)*WIDTH-1:0] all_c_x;

wire signed [NUM_LSTM*WIDTH-1:0] o_h;
wire signed [NUM_LSTM*WIDTH-1:0] l_c, l_a, l_i, l_f, l_o;

wire signed [8*WIDTH-1:0] all_t;

wire signed [NUM_LSTM*(NUM+NUM_LSTM)*WIDTH-1:0] w_a, d_w_a, lr_w_a, n_w_a;
wire signed [NUM_LSTM*(NUM+NUM_LSTM)*WIDTH-1:0] w_i, d_w_i, lr_w_i, n_w_i;
wire signed [NUM_LSTM*(NUM+NUM_LSTM)*WIDTH-1:0] w_f, d_w_f, lr_w_f, n_w_f;
wire signed [NUM_LSTM*(NUM+NUM_LSTM)*WIDTH-1:0] w_o, d_w_o, lr_w_o, n_w_o;

wire signed [NUM_LSTM*WIDTH-1:0] d_b_a, n_b_a, lr_b_a;
wire signed [NUM_LSTM*WIDTH-1:0] d_b_i, n_b_i, lr_b_i;
wire signed [NUM_LSTM*WIDTH-1:0] d_b_f, n_b_f, lr_b_f;
wire signed [NUM_LSTM*WIDTH-1:0] d_b_o, n_b_o, lr_b_o;

wire signed [NUM_LSTM*4*WIDTH-1:0] d_b;
wire signed [NUM_LSTM*WIDTH-1:0] b_a;
wire signed [NUM_LSTM*WIDTH-1:0] b_i;
wire signed [NUM_LSTM*WIDTH-1:0] b_f;
wire signed [NUM_LSTM*WIDTH-1:0] b_o;
wire signed [NUM_LSTM*WIDTH-1:0] d_loss;
wire signed [NUM_LSTM*WIDTH-1:0] mult_d_loss;
wire signed [WIDTH-1:0] temp_cost_function;
wire signed [WIDTH-1:0] cost_function;
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
		.wr     (wr),
		.i_x   (input_lstm),
		.i_w_a (n_w_a),
		.i_w_i (n_w_i),
		.i_w_f (n_w_f),
		.i_w_o (n_w_o),
		.i_b_a (n_b_a),
		.i_b_i (n_b_i),
		.i_b_f (n_b_f),
		.i_b_o (n_b_o),
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
			.i_wa (w_a  [ (i+1)*(NUM+NUM_LSTM)*WIDTH-1 : i*(NUM+NUM_LSTM)*WIDTH ]),
			.i_wo (w_o  [ (i+1)*(NUM+NUM_LSTM)*WIDTH-1 : i*(NUM+NUM_LSTM)*WIDTH ]),
			.i_wi (w_i  [ (i+1)*(NUM+NUM_LSTM)*WIDTH-1 : i*(NUM+NUM_LSTM)*WIDTH ]),
			.i_wf (w_f  [ (i+1)*(NUM+NUM_LSTM)*WIDTH-1 : i*(NUM+NUM_LSTM)*WIDTH ]),
			.o_b  (d_b  [ (i+1)*4*WIDTH-1 : i*4*WIDTH ]),
			.o_wa (d_w_a[ (i+1)*(NUM+NUM_LSTM)*WIDTH-1 : i*(NUM+NUM_LSTM)*WIDTH ]),
			.o_wi (d_w_i[ (i+1)*(NUM+NUM_LSTM)*WIDTH-1 : i*(NUM+NUM_LSTM)*WIDTH ]),
			.o_wf (d_w_f[ (i+1)*(NUM+NUM_LSTM)*WIDTH-1 : i*(NUM+NUM_LSTM)*WIDTH ]),
			.o_wo (d_w_o[ (i+1)*(NUM+NUM_LSTM)*WIDTH-1 : i*(NUM+NUM_LSTM)*WIDTH ]),
			.o_d_loss (d_loss[ (i+1)*WIDTH-1 : i*WIDTH ])
		);
	end

	for (i = 0; i < NUM_LSTM; i = i + 1)
	begin:parse_b
		assign d_b_a [ (i+1)*WIDTH-1 : i*WIDTH ] = d_b [ (i*4+1+0)*WIDTH-1 : (i*4+0)*WIDTH ];
		assign d_b_i [ (i+1)*WIDTH-1 : i*WIDTH ] = d_b [ (i*4+1+1)*WIDTH-1 : (i*4+1)*WIDTH ];
		assign d_b_f [ (i+1)*WIDTH-1 : i*WIDTH ] = d_b [ (i*4+1+2)*WIDTH-1 : (i*4+2)*WIDTH ];
		assign d_b_o [ (i+1)*WIDTH-1 : i*WIDTH ] = d_b [ (i*4+1+3)*WIDTH-1 : (i*4+3)*WIDTH ];
	end
endgenerate

	// Multiply δ Bias & Weight with Learning rate
	mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) lr_mul_d_b_a[NUM_LSTM-1:0] (.i_a({NUM_LSTM{32'hff_e66667}}), .i_b(d_b_a), .o(lr_b_a));
	mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) lr_mul_d_b_i[NUM_LSTM-1:0] (.i_a({NUM_LSTM{32'hff_e66667}}), .i_b(d_b_i), .o(lr_b_i));
	mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) lr_mul_d_b_f[NUM_LSTM-1:0] (.i_a({NUM_LSTM{32'hff_e66667}}), .i_b(d_b_f), .o(lr_b_f));
	mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) lr_mul_d_b_o[NUM_LSTM-1:0] (.i_a({NUM_LSTM{32'hff_e66667}}), .i_b(d_b_o), .o(lr_b_o));

	mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) lr_mul_d_w_a[NUM_LSTM*(NUM+NUM_LSTM)-1:0] (.i_a({NUM_LSTM*(NUM+NUM_LSTM){32'hff_e66667}}), .i_b(d_w_a), .o(lr_w_a));
	mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) lr_mul_d_w_i[NUM_LSTM*(NUM+NUM_LSTM)-1:0] (.i_a({NUM_LSTM*(NUM+NUM_LSTM){32'hff_e66667}}), .i_b(d_w_i), .o(lr_w_i));
	mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) lr_mul_d_w_f[NUM_LSTM*(NUM+NUM_LSTM)-1:0] (.i_a({NUM_LSTM*(NUM+NUM_LSTM){32'hff_e66667}}), .i_b(d_w_f), .o(lr_w_f));
	mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) lr_mul_d_w_o[NUM_LSTM*(NUM+NUM_LSTM)-1:0] (.i_a({NUM_LSTM*(NUM+NUM_LSTM){32'hff_e66667}}), .i_b(d_w_o), .o(lr_w_o));

	// Calculate new Weights & Biases
	adder_2in #(.WIDTH(WIDTH)) add_n_b_a[NUM_LSTM-1:0] (.i_a(lr_b_a), .i_b(b_a), .o(n_b_a));
	adder_2in #(.WIDTH(WIDTH)) add_n_b_i[NUM_LSTM-1:0] (.i_a(lr_b_i), .i_b(b_i), .o(n_b_i));
	adder_2in #(.WIDTH(WIDTH)) add_n_b_f[NUM_LSTM-1:0] (.i_a(lr_b_f), .i_b(b_f), .o(n_b_f));
	adder_2in #(.WIDTH(WIDTH)) add_n_b_o[NUM_LSTM-1:0] (.i_a(lr_b_o), .i_b(b_o), .o(n_b_o));

	adder_2in #(.WIDTH(WIDTH)) add_n_w_a[NUM_LSTM*(NUM+NUM_LSTM)-1:0] (.i_a(lr_w_a), .i_b(w_a), .o(n_w_a));
	adder_2in #(.WIDTH(WIDTH)) add_n_w_i[NUM_LSTM*(NUM+NUM_LSTM)-1:0] (.i_a(lr_w_i), .i_b(w_i), .o(n_w_i));
	adder_2in #(.WIDTH(WIDTH)) add_n_w_f[NUM_LSTM*(NUM+NUM_LSTM)-1:0] (.i_a(lr_w_f), .i_b(w_f), .o(n_w_f));
	adder_2in #(.WIDTH(WIDTH)) add_n_w_o[NUM_LSTM*(NUM+NUM_LSTM)-1:0] (.i_a(lr_w_o), .i_b(w_o), .o(n_w_o));

	// Calculate cost function
	mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) mul_d_loss [NUM_LSTM-1:0] (.i_a(d_loss), .i_b(d_loss), .o(mult_d_loss));
	adder #(.NUM(NUM_LSTM), .WIDTH(WIDTH)) add (.i(mult_d_loss), .o(temp_cost_function));
	mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) inst_mult_2in (.i_a(temp_cost_function), .i_b(32'h00800000), .o(cost_function));

	assign o_cost = cost_function;
endmodule