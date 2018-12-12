////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : Delta Weight & Bias Calculate Module
// File Name        : delta_weight_bias_calc.v
// Version          : 1.0
// Description      : Module to calculate the weight and bias difference
//                    in Neural Network
//
////////////////////////////////////////////////////////////////////////////////

module weight_bias_calc(clk, rst, en, i_lr, i_k, i_hd_a, i_dlto, i_dlth, o_bias_o, o_bias_hd, o_wght_o, o_wght_hd);

// parameters
parameter N_IN = 2;
parameter N_HL_P = 3;
parameter N_OUT = 2;
parameter WIDTH = 32;

// common ports
input clk, rst;

// control ports
input en;

// input ports
input signed [WIDTH-1:0] i_lr;
input signed [N_IN*WIDTH-1:0] i_k;
input signed [N_HL_P*WIDTH-1:0] i_hd_a;
input signed [N_OUT*WIDTH-1:0] i_dlto;
input signed [N_HL_P*WIDTH-1:0] i_dlth;

// output ports
output signed [N_OUT*WIDTH-1:0] o_bias_o;
output signed [N_HL_P*WIDTH-1:0] o_bias_hd;
output signed [N_HL_P*N_OUT*WIDTH-1:0] o_wght_o;
output signed [N_HL_P*N_IN*WIDTH-1:0] o_wght_hd;

// wire ports
// parsed inputs
wire signed [WIDTH-1:0] i_k1;
wire signed [WIDTH-1:0] i_k2;
wire signed [WIDTH-1:0] i_hd_a1;
wire signed [WIDTH-1:0] i_hd_a2;
wire signed [WIDTH-1:0] i_hd_a3;
wire signed [WIDTH-1:0] i_dlto_1;
wire signed [WIDTH-1:0] i_dlto_2;
wire signed [WIDTH-1:0] i_dlth_1;
wire signed [WIDTH-1:0] i_dlth_2;
wire signed [WIDTH-1:0] i_dlth_3;
// bias wires
wire signed [WIDTH-1:0] o_bias_out_1;
wire signed [WIDTH-1:0] o_bias_out_2;
wire signed [WIDTH-1:0] o_bias_hd_1;
wire signed [WIDTH-1:0] o_bias_hd_2;
wire signed [WIDTH-1:0] o_bias_hd_3;
// wight wires
wire signed [WIDTH-1:0] o_wght_out_11;
wire signed [WIDTH-1:0] o_wght_out_12;
wire signed [WIDTH-1:0] o_wght_out_13;
wire signed [WIDTH-1:0] o_wght_out_21;
wire signed [WIDTH-1:0] o_wght_out_22;
wire signed [WIDTH-1:0] o_wght_out_23;
wire signed [WIDTH-1:0] o_wght_hd_11;
wire signed [WIDTH-1:0] o_wght_hd_12;
wire signed [WIDTH-1:0] o_wght_hd_21;
wire signed [WIDTH-1:0] o_wght_hd_22;
wire signed [WIDTH-1:0] o_wght_hd_31;
wire signed [WIDTH-1:0] o_wght_hd_32;

////////////////////////////////////////////
// Parsing Input
assign i_k1 = i_k[1*WIDTH-1:0];
assign i_k2 = i_k[2*WIDTH-1:1*WIDTH];

assign i_hd_a1 = i_hd_a[1*WIDTH-1:0];
assign i_hd_a2 = i_hd_a[2*WIDTH-1:1*WIDTH];
assign i_hd_a3 = i_hd_a[3*WIDTH-1:2*WIDTH];

assign i_dlto_1 = i_dlto[1*WIDTH-1:0];
assign i_dlto_2 = i_dlto[2*WIDTH-1:1*WIDTH];

assign i_dlth_1 = i_dlth[1*WIDTH-1:0];
assign i_dlth_2 = i_dlth[2*WIDTH-1:1*WIDTH];
assign i_dlth_3 = i_dlth[3*WIDTH-1:2*WIDTH];

///////////////////////////////////////////////
// Bias Calculation
// o_1: output layer 1st perceptron
bias_acc #(.WIDTH(WIDTH)) calc_bias_o_1  (
        .clk(clk),
        .rst(rst),
        .en(en),
        .i_d(i_dlto_1),
        .i_lr(i_lr),
        .o(o_bias_out_1)
    );

bias_acc #(.WIDTH(WIDTH)) calc_bias_o_2  (
        .clk(clk),
        .rst(rst),
        .en(en),
        .i_d(i_dlto_2),
        .i_lr(i_lr),
        .o(o_bias_out_2)
    );

bias_acc #(.WIDTH(WIDTH)) calc_bias_hd_1 (
        .clk(clk),
        .rst(rst),
        .en(en),
        .i_d(i_dlth_1),
        .i_lr(i_lr),
        .o(o_bias_hd_1)
    );

bias_acc #(.WIDTH(WIDTH)) calc_bias_hd_2 (
        .clk(clk),
        .rst(rst),
        .en(en),
        .i_d(i_dlth_2),
        .i_lr(i_lr),
        .o(o_bias_hd_2)
    );

bias_acc #(.WIDTH(WIDTH)) calc_bias_hd_3 (
        .clk(clk),
        .rst(rst),
        .en(en),
        .i_d(i_dlth_3),
        .i_lr(i_lr),
        .o(o_bias_hd_3)
    );

///////////////////////////////////////////////////////////////
// Weight Calculation
// o_11: output layer 1st perceptron to hd layer 1st perceptron
wght_acc #(
        .WIDTH(WIDTH)
    ) calc_wght_o_11 (
        .clk  (clk),
        .rst  (rst),
        .en   (en),
        .i_d  (i_dlto_1),
        .i_a  (i_hd_a1),
        .i_lr (i_lr),
        .o    (o_wght_out_11)
    );

wght_acc #(
        .WIDTH(WIDTH)
    ) calc_wght_o_12 (
        .clk  (clk),
        .rst  (rst),
        .en   (en),
        .i_d  (i_dlto_1),
        .i_a  (i_hd_a2),
        .i_lr (i_lr),
        .o    (o_wght_out_12)
    );

wght_acc #(
        .WIDTH(WIDTH)
    ) calc_wght_o_13 (
        .clk  (clk),
        .rst  (rst),
        .en   (en),
        .i_d  (i_dlto_1),
        .i_a  (i_hd_a3),
        .i_lr (i_lr),
        .o    (o_wght_out_13)
    );

wght_acc #(
        .WIDTH(WIDTH)
    ) calc_wght_o_21 (
        .clk  (clk),
        .rst  (rst),
        .en   (en),
        .i_d  (i_dlto_2),
        .i_a  (i_hd_a1),
        .i_lr (i_lr),
        .o    (o_wght_out_21)
    );

wght_acc #(
        .WIDTH(WIDTH)
    ) calc_wght_o_22 (
        .clk  (clk),
        .rst  (rst),
        .en   (en),
        .i_d  (i_dlto_2),
        .i_a  (i_hd_a2),
        .i_lr (i_lr),
        .o    (o_wght_out_22)
    );

wght_acc #(
        .WIDTH(WIDTH)
    ) calc_wght_o_23 (
        .clk  (clk),
        .rst  (rst),
        .en   (en),
        .i_d  (i_dlto_2),
        .i_a  (i_hd_a3),
        .i_lr (i_lr),
        .o    (o_wght_out_23)
    );

wght_acc #(
        .WIDTH(WIDTH)
    ) calc_wght_hd_11 (
        .clk  (clk),
        .rst  (rst),
        .en   (en),
        .i_d  (i_dlth_1),
        .i_a  (i_k1),
        .i_lr (i_lr),
        .o    (o_wght_hd_11)
    );

wght_acc #(
        .WIDTH(WIDTH)
    ) calc_wght_hd_12 (
        .clk  (clk),
        .rst  (rst),
        .en   (en),
        .i_d  (i_dlth_1),
        .i_a  (i_k2),
        .i_lr (i_lr),
        .o    (o_wght_hd_12)
    );

wght_acc #(
        .WIDTH(WIDTH)
    ) calc_wght_hd_21 (
        .clk  (clk),
        .rst  (rst),
        .en   (en),
        .i_d  (i_dlth_2),
        .i_a  (i_k1),
        .i_lr (i_lr),
        .o    (o_wght_hd_21)
    );

wght_acc #(
        .WIDTH(WIDTH)
    ) calc_wght_hd_22 (
        .clk  (clk),
        .rst  (rst),
        .en   (en),
        .i_d  (i_dlth_2),
        .i_a  (i_k2),
        .i_lr (i_lr),
        .o    (o_wght_hd_22)
    );

wght_acc #(
        .WIDTH(WIDTH)
    ) calc_wght_hd_31 (
        .clk  (clk),
        .rst  (rst),
        .en   (en),
        .i_d  (i_dlth_3),
        .i_a  (i_k1),
        .i_lr (i_lr),
        .o    (o_wght_hd_31)
    );

wght_acc #(
        .WIDTH(WIDTH)
    ) calc_wght_hd_32 (
        .clk  (clk),
        .rst  (rst),
        .en   (en),
        .i_d  (i_dlth_3),
        .i_a  (i_k2),
        .i_lr (i_lr),
        .o    (o_wght_hd_32)
    );

/////////////////////
// Combining Outputs
assign o_bias_o = {o_bias_out_2, o_bias_out_1};
assign o_bias_hd = {o_bias_hd_3, o_bias_hd_2, o_bias_hd_1};
assign o_wght_o = {o_wght_out_23, o_wght_out_22, o_wght_out_21, o_wght_out_13, o_wght_out_12, o_wght_out_11};
assign o_wght_hd = {o_wght_hd_32, o_wght_hd_31, o_wght_hd_22, o_wght_hd_21, o_wght_hd_12, o_wght_hd_11};
endmodule