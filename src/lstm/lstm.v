
////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : Long Short Term Memory
// File Name        : lstm.v
// Version          : 2.0
// Description      : top level of long short term memory forward propagation
//                    
//					  
////////////////////////////////////////////////////////////////////////////////

module lstm (clk, rst, sel, load_h, wr, i_x, i_w_a, i_w_i, i_w_f, i_w_o,  
i_b_a, i_b_i,  i_b_f, i_b_o,
o_w_a, o_w_i,  o_w_f, o_w_o,
o_b_a, o_b_i, o_b_f, o_b_o, 
o_a, o_i, o_f, o_o, o_c, o_h,
o_c_x);

// parameters
parameter WIDTH = 32;
parameter NUM = 68;
parameter NUM_LSTM = 8;
parameter FILENAMEA="mem_wghta.list";
parameter FILENAMEI="mem_wghti.list";
parameter FILENAMEF="mem_wghtf.list";
parameter FILENAMEO="mem_wghto.list";

// common ports
input clk, rst;

// control ports
input sel, load_h, wr;

// input ports
input signed [NUM*WIDTH-1:0] i_x;

// input ports for backpropagation
input signed [NUM_LSTM*(NUM+NUM_LSTM)*WIDTH-1:0] i_w_a;
input signed [NUM_LSTM*(NUM+NUM_LSTM)*WIDTH-1:0] i_w_i;
input signed [NUM_LSTM*(NUM+NUM_LSTM)*WIDTH-1:0] i_w_f;
input signed [NUM_LSTM*(NUM+NUM_LSTM)*WIDTH-1:0] i_w_o;
input signed [NUM_LSTM*WIDTH-1:0] i_b_a;
input signed [NUM_LSTM*WIDTH-1:0] i_b_i;
input signed [NUM_LSTM*WIDTH-1:0] i_b_f;
input signed [NUM_LSTM*WIDTH-1:0] i_b_o;


// output ports
output signed [NUM_LSTM*(NUM+NUM_LSTM)*WIDTH-1:0] o_w_a;
output signed [NUM_LSTM*(NUM+NUM_LSTM)*WIDTH-1:0] o_w_i;
output signed [NUM_LSTM*(NUM+NUM_LSTM)*WIDTH-1:0] o_w_f;
output signed [NUM_LSTM*(NUM+NUM_LSTM)*WIDTH-1:0] o_w_o;
output signed [NUM_LSTM*WIDTH-1:0] o_b_a;
output signed [NUM_LSTM*WIDTH-1:0] o_b_i;
output signed [NUM_LSTM*WIDTH-1:0] o_b_f;
output signed [NUM_LSTM*WIDTH-1:0] o_b_o;

output signed [NUM_LSTM*WIDTH-1:0] o_c;
output signed [NUM_LSTM*WIDTH-1:0] o_h;
output signed [NUM_LSTM*WIDTH-1:0] o_a;
output signed [NUM_LSTM*WIDTH-1:0] o_i;
output signed [NUM_LSTM*WIDTH-1:0] o_f;
output signed [NUM_LSTM*WIDTH-1:0] o_o;
output signed [(NUM+NUM_LSTM)*WIDTH-1:0] o_c_x;

wire signed [NUM_LSTM*WIDTH-1:0] o_h_prev;
wire signed [(NUM+NUM_LSTM)*WIDTH-1:0] concatenated_input;
wire signed [NUM_LSTM*WIDTH-1:0] out_multiplexer;
wire signed [NUM_LSTM*WIDTH-1:0] null_num = {NUM_LSTM*WIDTH{1'b0}};

assign concatenated_input = {out_multiplexer, i_x};
assign o_c_x = concatenated_input;

generate
    genvar i;
    ///////////////////////////////////////////////
    // Stacking multiple cell of lstm 
    // o_x[i] = output gate x in cell number i in layer
    // o_x[i] structure
    // n-th cell gates is placed on left side, while
    // first cell gates on right
    // a gates :
    // [ o_a(n)....o_a(3)|o_a(2)|o_a(1)|o_a(0) ]
    // ----the same things happen to another gates-----

    for (i = 0; i < NUM_LSTM; i = i + 1)
	begin:lstm_
		lstm_cell #(
				.WIDTH(WIDTH),
				.NUM(NUM),
				.NUM_LSTM(NUM_LSTM),
				.FILENAMEA("mem_wghta00" + (256 * (i / 10)) + (i % 10)),
				.FILENAMEI("mem_wghti00" + (256 * (i / 10)) + (i % 10)),
				.FILENAMEF("mem_wghtf00" + (256 * (i / 10)) + (i % 10)),
				.FILENAMEO("mem_wghto00" + (256 * (i / 10)) + (i % 10))

			) inst_lstm_cell (
				.clk   (clk),
				.rst   (rst),
				.sel   (sel),
				.load_h(load_h),
				.wr    (wr),
				.i_x   (concatenated_input),
				.i_w_a (i_w_a [ (i+1)*(NUM+NUM_LSTM)*WIDTH-1 : i*(NUM+NUM_LSTM)*WIDTH ] ),
				.i_w_i (i_w_i [ (i+1)*(NUM+NUM_LSTM)*WIDTH-1 : i*(NUM+NUM_LSTM)*WIDTH ] ),
				.i_w_f (i_w_f [ (i+1)*(NUM+NUM_LSTM)*WIDTH-1 : i*(NUM+NUM_LSTM)*WIDTH ] ),
				.i_w_o (i_w_o [ (i+1)*(NUM+NUM_LSTM)*WIDTH-1 : i*(NUM+NUM_LSTM)*WIDTH ] ),
				.i_b_a (i_b_a [(i+1)*WIDTH-1:i*WIDTH]),
				.i_b_i (i_b_i [(i+1)*WIDTH-1:i*WIDTH]),
				.i_b_f (i_b_f [(i+1)*WIDTH-1:i*WIDTH]),
				.i_b_o (i_b_o [(i+1)*WIDTH-1:i*WIDTH]),
				.o_w_a (o_w_a [ (i+1)*(NUM+NUM_LSTM)*WIDTH-1 : i*(NUM+NUM_LSTM)*WIDTH ]),
				.o_w_i (o_w_i [ (i+1)*(NUM+NUM_LSTM)*WIDTH-1 : i*(NUM+NUM_LSTM)*WIDTH ]),
				.o_w_f (o_w_f [ (i+1)*(NUM+NUM_LSTM)*WIDTH-1 : i*(NUM+NUM_LSTM)*WIDTH ]),
				.o_w_o (o_w_o [ (i+1)*(NUM+NUM_LSTM)*WIDTH-1 : i*(NUM+NUM_LSTM)*WIDTH ]),
				.o_b_a (o_b_a [(i+1)*WIDTH-1:i*WIDTH]),
				.o_b_i (o_b_i [(i+1)*WIDTH-1:i*WIDTH]),
				.o_b_f (o_b_f [(i+1)*WIDTH-1:i*WIDTH]),
				.o_b_o (o_b_o [(i+1)*WIDTH-1:i*WIDTH]),
				.o_a   (o_a[(i+1)*WIDTH-1:i*WIDTH]),
				.o_i   (o_i[(i+1)*WIDTH-1:i*WIDTH]),
				.o_f   (o_f[(i+1)*WIDTH-1:i*WIDTH]),
				.o_o   (o_o[(i+1)*WIDTH-1:i*WIDTH]),
				.o_c   (o_c[(i+1)*WIDTH-1:i*WIDTH]),
				.o_h   (o_h[(i+1)*WIDTH-1:i*WIDTH]),
				.o_h_prev (o_h_prev[(i+1)*WIDTH-1:i*WIDTH])
			);

	end
endgenerate

multiplexer #(.WIDTH(NUM_LSTM*WIDTH)) inst_multiplexer (.i_a(null_num), .i_b(o_h_prev), .sel(sel), .o(out_multiplexer));




endmodule



