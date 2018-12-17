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

module lstm (clk, rst, sel, i_x, i_w_a, i_w_i, i_w_f, i_w_o,  
i_b_a, i_b_i,  i_b_f, i_b_o,
o_w_a, o_w_i,  o_w_f, o_w_o,
o_b_a, o_b_i, o_b_f, o_b_o, 
o_a, o_i, o_f, o_o, o_c, o_h);

// parameters
parameter WIDTH = 32;
parameter NUM = 3;
parameter NUM_LSTM = 5;
parameter FILENAMEA="mem_wghta.list";
parameter FILENAMEI="mem_wghti.list";
parameter FILENAMEF="mem_wghtf.list";
parameter FILENAMEO="mem_wghto.list";

// common ports
input clk, rst;

// control ports
input sel;

// input ports
input signed [(NUM-1)*WIDTH-1:0] i_x;

// input ports for backpropagation
input signed [NUM*WIDTH-1:0] i_w_a;
input signed [NUM*WIDTH-1:0] i_w_i;
input signed [NUM*WIDTH-1:0] i_w_f;
input signed [NUM*WIDTH-1:0] i_w_o;
input signed [WIDTH-1:0] i_b_a;
input signed [WIDTH-1:0] i_b_i;
input signed [WIDTH-1:0] i_b_f;
input signed [WIDTH-1:0] i_b_o;


// output ports
output signed [NUM*WIDTH-1:0] o_w_a;
output signed [NUM*WIDTH-1:0] o_w_i;
output signed [NUM*WIDTH-1:0] o_w_f;
output signed [NUM*WIDTH-1:0] o_w_o;
output signed [WIDTH-1:0] o_b_a;
output signed [WIDTH-1:0] o_b_i;
output signed [WIDTH-1:0] o_b_f;
output signed [WIDTH-1:0] o_b_o;

output signed [NUM_LSTM*WIDTH-1:0] o_c;
output signed [NUM_LSTM*WIDTH-1:0] o_h;
output signed [NUM_LSTM*WIDTH-1:0] o_a;
output signed [NUM_LSTM*WIDTH-1:0] o_i;
output signed [NUM_LSTM*WIDTH-1:0] o_f;
output signed [NUM_LSTM*WIDTH-1:0] o_o;

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
				.FILENAMEA("mem_weighta00" + (256 * (i / 10)) + (i % 10)),
				.FILENAMEI("mem_weighti00" + (256 * (i / 10)) + (i % 10)),
				.FILENAMEF("mem_weightf00" + (256 * (i / 10)) + (i % 10)),
				.FILENAMEO("mem_weighto00" + (256 * (i / 10)) + (i % 10))

			) inst_lstm_cell (
				.clk   (clk),
				.rst   (rst),
				.sel   (sel),
				.i_x   (i_x),
				.i_w_a (i_w_a),
				.i_w_i (i_w_i),
				.i_w_f (i_w_f),
				.i_w_o (i_w_o),
				.i_b_a (i_b_a),
				.i_b_i (i_b_i),
				.i_b_f (i_b_f),
				.i_b_o (i_b_o),
				.o_w_a (o_w_a),
				.o_w_i (o_w_i),
				.o_w_f (o_w_f),
				.o_w_o (o_w_o),
				.o_b_a (o_b_a),
				.o_b_i (o_b_i),
				.o_b_f (o_b_f),
				.o_b_o (o_b_o),
				.o_a   (o_a[(i+1)*WIDTH-1:i*WIDTH]),
				.o_i   (o_i[(i+1)*WIDTH-1:i*WIDTH]),
				.o_f   (o_f[(i+1)*WIDTH-1:i*WIDTH]),
				.o_o   (o_o[(i+1)*WIDTH-1:i*WIDTH]),
				.o_c   (o_c[(i+1)*WIDTH-1:i*WIDTH]),
				.o_h   (o_h[(i+1)*WIDTH-1:i*WIDTH])
			);
	end
endgenerate

endmodule



