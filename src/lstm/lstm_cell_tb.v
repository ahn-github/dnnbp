module lstm_cell_tb();

// parameters
parameter WIDTH = 32;
parameter NUM = 2; // number of reg layer
parameter NUM_LSTM = 1; // number of LSTM CELL
parameter FILENAMEA="layer1a.list";
parameter FILENAMEI="layer1i.list";
parameter FILENAMEF="layer1f.list";
parameter FILENAMEO="layer1o.list";

// registers
reg clk, rst;
reg wr;
reg signed [(NUM+NUM_LSTM)*WIDTH-1:0] i_x;
reg signed [WIDTH-1:0] i_prev_state;

// wires
wire signed [(NUM+NUM_LSTM)*WIDTH-1:0] o_w_a;
wire signed [(NUM+NUM_LSTM)*WIDTH-1:0] o_w_i;
wire signed [(NUM+NUM_LSTM)*WIDTH-1:0] o_w_f;
wire signed [(NUM+NUM_LSTM)*WIDTH-1:0] o_w_o;
wire signed [WIDTH-1:0] o_b_a;
wire signed [WIDTH-1:0] o_b_i;
wire signed [WIDTH-1:0] o_b_f;
wire signed [WIDTH-1:0] o_b_o;
wire signed [WIDTH-1:0] o_c;
wire signed [WIDTH-1:0] o_h;
wire signed [WIDTH-1:0] o_a;
wire signed [WIDTH-1:0] o_i;
wire signed [WIDTH-1:0] o_f;
wire signed [WIDTH-1:0] o_o;
wire signed [WIDTH-1:0] o_h_prev;

lstm_cell #(
		.WIDTH(WIDTH),
		.NUM(NUM),
		.NUM_LSTM(NUM_LSTM),
		.FILENAMEA(FILENAMEA),
		.FILENAMEI(FILENAMEI),
		.FILENAMEF(FILENAMEF),
		.FILENAMEO(FILENAMEO)
	) inst_lstm_cell (
		.clk          (clk),
		.rst          (rst),
		.wr           (wr),
		.i_x          (i_x),
		.i_prev_state (i_prev_state),
		.i_w_a        (),
		.i_w_i        (),
		.i_w_f        (),
		.i_w_o        (),
		.i_b_a        (),
		.i_b_i        (),
		.i_b_f        (),
		.i_b_o        (),
		.o_w_a        (o_w_a),
		.o_w_i        (o_w_i),
		.o_w_f        (o_w_f),
		.o_w_o        (o_w_o),
		.o_b_a        (o_b_a),
		.o_b_i        (o_b_i),
		.o_b_f        (o_b_f),
		.o_b_o        (o_b_o),
		.o_a          (o_a),
		.o_i          (o_i),
		.o_f          (o_f),
		.o_o          (o_o),
		.o_c          (o_c),
		.o_h          (o_h)
	);

initial begin
	clk = 1;
	rst = 1;
	wr = 0;
	i_x = 96'h00000000_02000000_01000000;
	i_prev_state = 32'h00000000;
	#100;
	rst = 0;
	#100;
	i_x = 96'h00894b9c_03000000_00800000;
	i_prev_state = 32'h00ca01f1;
end

always begin
	#50
	clk = !clk;
end

endmodule