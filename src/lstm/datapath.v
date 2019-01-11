module datapath(clk, rst, wr_h1, wr_h2, wr_c1, wr_c2, wr_x2, wr_layr1, wr_layr2, addr_x1, rd_addr_x2, wr_addr_x2,
                rd_addr_h1, rd_addr_h2, rd_addr_c1, rd_addr_c2,
                wr_addr_h1, wr_addr_h2, wr_addr_c1, wr_addr_c2);

// parameters
parameter WIDTH = 32;
parameter TIMESTEP = 7;
parameter LAYR1_INPUT = 2;
parameter LAYR1_CELL = 2;
parameter LAYR2_CELL = 1;

parameter LAYR1_X = "layer1_x.list";
parameter LAYR1_H = "layer1_h.list";
parameter LAYR1_C = "layer1_c.list";
// This holds weights & biases
parameter LAYR1_A = "layer1_a.list";
parameter LAYR1_I = "layer1_i.list";
parameter LAYR1_F = "layer1_f.list";
parameter LAYR1_O = "layer1_o.list";

parameter LAYR2_X = "layer2_x.list";
parameter LAYR2_H = "layer2_h.list";
parameter LAYR2_C = "layer2_c.list";
// This holds weights & biases
parameter LAYR2_A = "layer2_a.list";
parameter LAYR2_I = "layer2_i.list";
parameter LAYR2_F = "layer2_f.list";
parameter LAYR2_O = "layer2_o.list";

// common ports
input clk, rst;

// control ports
input [WIDTH-1:0] addr_x1;
input [8:0] rd_addr_x2, wr_addr_x2;

input wr_h1;
input [8:0] rd_addr_h1;
input [8:0] wr_addr_h1;
input wr_c1;
input [8:0] rd_addr_c1;
input [8:0] wr_addr_c1;
input wr_layr1;

input wr_x2;
input wr_h2;
input [8:0] rd_addr_h2;
input [8:0] wr_addr_h2;
input wr_c2;
input [8:0] rd_addr_c2;
input [8:0] wr_addr_c2;
input wr_layr2;

// registers
reg signed [WIDTH-1:0] reg_c1, reg_c2;
reg signed [WIDTH-1:0] reg_h1, reg_h2;
wire signed [WIDTH-1:0] prev_c1, prev_c2;
reg signed [(LAYR1_CELL+LAYR1_INPUT)*WIDTH-1:0] layr1_in;
reg signed [(LAYR2_CELL+LAYR1_CELL)*WIDTH-1:0] layr2_in;

// wires
wire signed [LAYR1_INPUT*WIDTH-1:0] data_x1;

wire signed [WIDTH-1:0] i_mem_h1, i_mem_x2, i_mem_h2;
wire signed [WIDTH-1:0] i_mem_c1, i_mem_c2;
wire signed [WIDTH-1:0] o_mem_c1, o_mem_c2;
wire signed [LAYR1_CELL*WIDTH-1:0] o_mem_h1, o_mem_x2;
wire signed [LAYR2_CELL*WIDTH-1:0] o_mem_h2;

wire signed [(LAYR1_CELL+LAYR1_INPUT)*WIDTH-1:0] conc_x1;
wire signed [(LAYR2_CELL+LAYR1_CELL)*WIDTH-1:0] conc_x2;

wire signed [(LAYR1_CELL+LAYR1_INPUT)*WIDTH-1:0] w_a1;
wire signed [(LAYR1_CELL+LAYR1_INPUT)*WIDTH-1:0] w_i1;
wire signed [(LAYR1_CELL+LAYR1_INPUT)*WIDTH-1:0] w_f1;
wire signed [(LAYR1_CELL+LAYR1_INPUT)*WIDTH-1:0] w_o1;
wire signed [(LAYR2_CELL+LAYR1_CELL)*WIDTH-1:0] w_a2;
wire signed [(LAYR2_CELL+LAYR1_CELL)*WIDTH-1:0] w_i2;
wire signed [(LAYR2_CELL+LAYR1_CELL)*WIDTH-1:0] w_f2;
wire signed [(LAYR2_CELL+LAYR1_CELL)*WIDTH-1:0] w_o2;
wire signed [WIDTH-1:0] b_a1, b_a2;
wire signed [WIDTH-1:0] b_i1, b_i2;
wire signed [WIDTH-1:0] b_f1, b_f2;
wire signed [WIDTH-1:0] b_o1, b_o2;
wire signed [WIDTH-1:0] c1, c2;
wire signed [WIDTH-1:0] h1, h2;
wire signed [WIDTH-1:0] a1, a2;
wire signed [WIDTH-1:0] i1, i2;
wire signed [WIDTH-1:0] f1, f2;
wire signed [WIDTH-1:0] o1, o2;


// Input Memory
// out: data (53*WIDTH)
memory_x #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_INPUT),
		.TIMESTEP(TIMESTEP),
		.FILENAME(LAYR1_X)
	) mem_x1 (
		.clk  (clk),
		.rst  (rst),
		.addr (addr_x1),
		.data (data_x1)
	);

// LAYER 1 Output Memory
// in: i (WIDTH)
// out: o (53*WIDTH)
memory_h1 #(
		.WIDTH(WIDTH),
		.NUM_LSTM(LAYR1_CELL),
		.TIMESTEP(TIMESTEP),
		.FILENAME(LAYR1_H)
	) mem_h1 (
		.clk     (clk),
		.rst     (rst),
		.wr      (wr_h1),
		.rd_addr (rd_addr_h1),
		.wr_addr (wr_addr_h1),
		.i       (i_mem_h1),
		.o       (o_mem_h1)
	);

// Concatenate Input & Last Output
assign conc_x1 = {o_mem_h1, data_x1};

// LAYER 1 Input Pipeline Register
// in: data (106*WIDTH)
// out: conc_x (106*WIDTH)
// always @(posedge clk) 
// begin
// 	layr1_in <= conc_x1;
// end

// LAYER 1 State Memory
// in: i (WIDTH)
// out: o (WIDTH)
memory_c #(
		.WIDTH(WIDTH),
		.NUM_LSTM(LAYR1_CELL),
		.TIMESTEP(TIMESTEP),
		.FILENAME(LAYR1_C)
	) mem_c1 (
		.clk     (clk),
		.rst     (rst),
		.wr      (wr_c1),
		.rd_addr (rd_addr_c1),
		.wr_addr (wr_addr_c1),
		.i       (i_mem_c1),
		.o       (prev_c1)
	);

// LAYER 1 State Pipeline Register
// in: data (WIDTH)
// out: prev_c (WIDTH)
// always @(posedge clk) 
// begin
// 	prev_c1 <= o_mem_c1;
// end

// LAYER 1 LSTM CELL
// in: conc_x (106*WIDTH), prev_c (WIDTH) 
// out: o_a, o_i, o_f, o_o, o_c, o_h (WIDTH)
lstm_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_INPUT),
		.NUM_LSTM(LAYR1_CELL),
		.FILENAMEA(LAYR1_A),
		.FILENAMEI(LAYR1_I),
		.FILENAMEF(LAYR1_F),
		.FILENAMEO(LAYR1_O)
	) layr1_cell (
		.clk          (clk),
		.rst          (rst),
		.wr           (wr_layr1),
		.i_x          (conc_x1),
		.i_prev_state (prev_c1),
		.i_w_a        (),
		.i_w_i        (),
		.i_w_f        (),
		.i_w_o        (),
		.i_b_a        (),
		.i_b_i        (),
		.i_b_f        (),
		.i_b_o        (),
		.o_w_a        (w_a1),
		.o_w_i        (w_i1),
		.o_w_f        (w_f1),
		.o_w_o        (w_o1),
		.o_b_a        (b_a1),
		.o_b_i        (b_i1),
		.o_b_f        (b_f1),
		.o_b_o        (b_o1),
		.o_a          (a1),
		.o_i          (i1),
		.o_f          (f1),
		.o_o          (o1),
		.o_c          (c1),
		.o_h          (h1)
	);

// LAYER 1 Output Pipeline Register
// in: clk, h (WIDTH)
// out: h (WIDTH)
always @(posedge clk) 
begin
	reg_h1 <= h1;
end
assign i_mem_h1 = h1; // Loop to write LAYER 1 Output Memory

// LAYER 1 State Pipeline Register
// in: clk, c (WIDTH)
// out: c (WIDTH)
always @(posedge clk) 
begin
	reg_c1 <= c1;
end
assign i_mem_c1 = c1; // Loop to write LAYER 1 State Memory

//////////////////////////////////////////////////////////////////////

// Write LAYER 2 Input Memory
assign i_mem_x2 = h1; 

// LAYER 2 Input Memory
memory_h1 #(
		.WIDTH(WIDTH),
		.NUM_LSTM(LAYR1_CELL),
		.TIMESTEP(TIMESTEP),
		.FILENAME(LAYR2_X)
	) mem_x2 (
		.clk     (clk),
		.rst     (rst),
		.wr      (wr_x2),
		.rd_addr (rd_addr_x2),
		.wr_addr (wr_addr_x2),
		.i       (i_mem_x2),
		.o       (o_mem_x2)
	);

// LAYER 2 Output Memory
// in: clk, rst, wr, rd_addr, wr_addr, i (WIDTH)
// out: o (8*WIDTH)
memory_h2 #(
		.WIDTH(WIDTH),
		.NUM_LSTM(LAYR2_CELL),
		.TIMESTEP(TIMESTEP),
		.FILENAME(LAYR2_H)
	) mem_h2 (
		.clk     (clk),
		.rst     (rst),
		.wr      (wr_h2),
		.rd_addr (rd_addr_h2),
		.wr_addr (wr_addr_h2),
		.i       (i_mem_h2),
		.o       (o_mem_h2)
	);

// Concatenate Input & Last Output
assign conc_x2 = {o_mem_h2, o_mem_x2};

// LAYER 2 Input Pipeline Register
// in: clk, data (61*WIDTH)
// out: conc_x (61*WIDTH)
always @(posedge clk) 
begin
	layr2_in <= conc_x2;
end

// LAYER 2 State Memory
// in: i (WIDTH)
// out: o (WIDTH)
memory_c #(
		.WIDTH(WIDTH),
		.NUM_LSTM(LAYR2_CELL),
		.TIMESTEP(TIMESTEP),
		.FILENAME(LAYR2_C)
	) mem_c2 (
		.clk     (clk),
		.rst     (rst),
		.wr      (wr_c2),
		.rd_addr (rd_addr_c2),
		.wr_addr (wr_addr_c2),
		.i       (i_mem_c2),
		.o       (prev_c2)
	);

// LAYER 2 State Pipeline Register
// in: data (WIDTH)
// out: prev_c (WIDTH)
// always @(posedge clk)
// begin
// 	prev_c2 <= o_mem_c2;
// end

// LAYER 2 LSTM CELL
// in: clk, rst, sel, wr, i_x(conc_x), i_prev_state(prev_c), 
//     i_w_a, i_w_i, i_w_f, i_w_o, i_b_a, i_b_i,  i_b_f, i_b_o
// out: o_a, o_i, o_f, o_o, o_c, o_h,
//      o_w_a, o_w_i,  o_w_f, o_w_o,  o_b_a, o_b_i, o_b_f, o_b_o,  
lstm_cell #(
		.WIDTH(WIDTH),
		.NUM(LAYR1_CELL),
		.NUM_LSTM(LAYR2_CELL),
		.FILENAMEA(LAYR2_A),
		.FILENAMEI(LAYR2_I),
		.FILENAMEF(LAYR2_F),
		.FILENAMEO(LAYR2_O)
	) layr2_cell (
		.clk          (clk),
		.rst          (rst),
		.wr           (wr_layr2),
		.i_x          (conc_x2),
		.i_prev_state (prev_c2),
		.i_w_a        (),
		.i_w_i        (),
		.i_w_f        (),
		.i_w_o        (),
		.i_b_a        (),
		.i_b_i        (),
		.i_b_f        (),
		.i_b_o        (),
		.o_w_a        (w_a2),
		.o_w_i        (w_i2),
		.o_w_f        (w_f2),
		.o_w_o        (w_o2),
		.o_b_a        (b_a2),
		.o_b_i        (b_i2),
		.o_b_f        (b_f2),
		.o_b_o        (b_o2),
		.o_a          (a2),
		.o_i          (i2),
		.o_f          (f2),
		.o_o          (o2),
		.o_c          (c2),
		.o_h          (h2)
	);

// LAYER 2 Output Register
// in: clk, h (WIDTH)
// out: h (WIDTH)
always @(posedge clk) 
begin
	reg_h2 <= h2;
end
assign i_mem_h2 = h2; // Loop to write LAYER 2 Output Memory

// LAYER 2 State Register
// in: clk, c (WIDTH)
// out: c (WIDTH)
always @(posedge clk) 
begin
	reg_c2 <= c2;
end
assign i_mem_c2 = c2; // Loop to write LAYER 2 State Memory

endmodule