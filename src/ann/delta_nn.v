////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : Delta Calculation Module
// File Name        : delta_nn.v
// Version          : 1.0
// Description      : Delta Calculation module for neural network
//
////////////////////////////////////////////////////////////////////////////////

module delta_nn(i_hd_a, i_out_w, i_out_a, i_t, o_cost, o_dlto, o_dlth);

// parameters
parameter N_IN = 2;
parameter N_HL_P = 3;
parameter N_OUT = 2;
parameter WIDTH = 32;
parameter FRAC = 24;

// input ports
input signed [N_HL_P*WIDTH-1:0] i_hd_a;
input signed [N_HL_P*N_IN*WIDTH-1:0] i_out_w;
input signed [N_OUT*WIDTH-1:0] i_out_a;
input signed [N_OUT*WIDTH-1:0] i_t;

// output ports
output signed [N_OUT*WIDTH-1:0] o_cost;
output signed [N_OUT*WIDTH-1:0] o_dlto;
output signed [N_HL_P*WIDTH-1:0] o_dlth;

// wires
wire signed [WIDTH-1:0] i_hd_a1;
wire signed [WIDTH-1:0] i_hd_a2;
wire signed [WIDTH-1:0] i_hd_a3;
// i_out_wX_Y: X = hidden perceptron, Y = output perceptron
wire signed [WIDTH-1:0] i_out_w1_1;
wire signed [WIDTH-1:0] i_out_w1_2;
wire signed [WIDTH-1:0] i_out_w1_3;
wire signed [WIDTH-1:0] i_out_w2_1;
wire signed [WIDTH-1:0] i_out_w2_2;
wire signed [WIDTH-1:0] i_out_w2_3;
wire signed [WIDTH-1:0] i_out_a1;
wire signed [WIDTH-1:0] i_out_a2;
wire signed [WIDTH-1:0] i_t1;
wire signed [WIDTH-1:0] i_t2;
wire signed [WIDTH-1:0] o_dlto_1;
wire signed [WIDTH-1:0] o_dlto_2;
wire signed [WIDTH-1:0] o_cost_1;
wire signed [WIDTH-1:0] o_cost_2;
wire signed [WIDTH-1:0] o_dlth_1;
wire signed [WIDTH-1:0] o_dlth_2;
wire signed [WIDTH-1:0] o_dlth_3;

// Parsing Inputs
assign i_hd_a1 = i_hd_a[1*WIDTH-1 : 0];
assign i_hd_a2 = i_hd_a[2*WIDTH-1 : 1*WIDTH];
assign i_hd_a3 = i_hd_a[3*WIDTH-1 : 2*WIDTH];

assign i_out_w1_1 = i_out_w[1*WIDTH-1 : 0];
assign i_out_w1_2 = i_out_w[2*WIDTH-1 : 1*WIDTH];
assign i_out_w1_3 = i_out_w[3*WIDTH-1 : 2*WIDTH];
assign i_out_w2_1 = i_out_w[4*WIDTH-1 : 3*WIDTH];
assign i_out_w2_2 = i_out_w[5*WIDTH-1 : 4*WIDTH];
assign i_out_w2_3 = i_out_w[6*WIDTH-1 : 5*WIDTH];

assign i_out_a1 = i_out_a[1*WIDTH-1 : 0];
assign i_out_a2 = i_out_a[2*WIDTH-1 : 1*WIDTH];

assign i_t1 = i_t[1*WIDTH-1 : 0];
assign i_t2 = i_t[2*WIDTH-1 : 1*WIDTH];

// Calculate Output Layer's Delta
delta_out #(.WIDTH(WIDTH), .FRAC(FRAC)) dlto_1 (.i_a(i_out_a1), .i_t(i_t1), .o_delta(o_dlto_1), .o_cost(o_cost_1));
delta_out #(.WIDTH(WIDTH), .FRAC(FRAC)) dlto_2 (.i_a(i_out_a2), .i_t(i_t2), .o_delta(o_dlto_2), .o_cost(o_cost_2));

// Calculate Hidden Layer's Delta
delta_h #(.NUM(N_IN), .WIDTH(WIDTH)) dlth_1 (.i_a(i_hd_a1), .i_prevd({o_dlto_2, o_dlto_1}), .i_w({i_out_w2_1, i_out_w1_1}), .o(o_dlth_1));
delta_h #(.NUM(N_IN), .WIDTH(WIDTH)) dlth_2 (.i_a(i_hd_a2), .i_prevd({o_dlto_2, o_dlto_1}), .i_w({i_out_w2_2, i_out_w1_2}), .o(o_dlth_2));
delta_h #(.NUM(N_IN), .WIDTH(WIDTH)) dlth_3 (.i_a(i_hd_a3), .i_prevd({o_dlto_2, o_dlto_1}), .i_w({i_out_w2_3, i_out_w1_3}), .o(o_dlth_3));

// Combining Outputs
assign o_cost = {o_cost_2, o_cost_1};
assign o_dlto = {o_dlto_2, o_dlto_1};
assign o_dlth = {o_dlth_3, o_dlth_2, o_dlth_1};

endmodule