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
///////////////////////////////////////////////////////////////////////////////

module array (clk, rst, sel, load, load_h, i_w_a, i_w_i, i_w_f, i_w_o,  
i_b_a, i_b_i,  i_b_f, i_b_o, o_h);

// parameters
parameter WIDTH = 32;
parameter NUM = 68;
parameter NUM_LSTM = 8;
parameter NUM_ITERATIONS = 8;
parameter FILENAMEA="mem_wghta.list";
parameter FILENAMEI="mem_wghti.list";
parameter FILENAMEF="mem_wghtf.list";
parameter FILENAMEO="mem_wghto.list";

// control ports
input clk, rst, sel, load, load_h;


// input ports for backpropagation
input signed [(NUM+NUM_LSTM)*WIDTH-1:0] i_w_a;
input signed [(NUM+NUM_LSTM)*WIDTH-1:0] i_w_i;
input signed [(NUM+NUM_LSTM)*WIDTH-1:0] i_w_f;
input signed [(NUM+NUM_LSTM)*WIDTH-1:0] i_w_o;
input signed [WIDTH-1:0] i_b_a;
input signed [WIDTH-1:0] i_b_i;
input signed [WIDTH-1:0] i_b_f;
input signed [WIDTH-1:0] i_b_o;

// output ports
output signed [NUM_LSTM*WIDTH-1:0] o_h;



// wires
wire signed [WIDTH-1:0] addrinput;
wire signed [WIDTH-1:0] x_t;
wire signed [NUM*WIDTH-1:0] temp_input_lstm;
wire signed [NUM*WIDTH-1:0] input_lstm;

lstm #(
		.WIDTH(WIDTH),
		.NUM(NUM),
		.NUM_LSTM(NUM_LSTM)
	) inst_lstm (
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
		.o_h   (o_h)
	);


mem_input_x #(
		.WIDTH(WIDTH),
		.NUM(NUM),
		.NUM_ITERATIONS(NUM_ITERATIONS)
	) inst_mem_input (
		.addr (addrinput),
		.data (x_t)
	);

addr_x #(
		.WIDTH(WIDTH),
		.NUM(NUM),
		.NUM_ITERATIONS(NUM_ITERATIONS)
	) inst_addr_input (
		.clk (clk),
		.rst (rst),
		.count (addrinput)
	);

shift_reg #(
		.NUM_ITERATIONS(NUM),
		.WIDTH(WIDTH)
	) inst_shift_reg (
		.clk (clk),
		.rst (rst),
		.i   (x_t),
		.o   (temp_input_lstm)
	);

sto_reg #(.WIDTH(WIDTH), .NUM(NUM)) inst_sto_reg (.clk(clk), .rst(rst), .load(load), .i(temp_input_lstm), .o(input_lstm));


endmodule












