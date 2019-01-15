////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : Tanh Function 
// File Name        : tanh.v
// Version          : 1.0
// Description      : perceptron-like module with tanh activation
//
////////////////////////////////////////////////////////////////////////////////

module old_tanh(i, o);

// parameters
parameter WIDTH = 32;

// input ports
input [WIDTH-1:0] i;

// output ports
output[WIDTH-1:0] o;

// wires
wire [2:0] ctrl_seg;
wire [WIDTH-1:0] mid_seg;
wire [WIDTH-1:0] pos, var_x;
wire [WIDTH-1:0] coef0_coef_sel, coef1_coef_sel, coef2_coef_sel;
wire [WIDTH-1:0] o_mul2, o_mul3, o_add;

// Calculate variable x, a taylor series input
assign pos  = i[WIDTH-1] ? (~i + 1) : i; // choosing positive value
assign var_x = pos - mid_seg; 

// Choosing middle value
segmentation seg (.i(i), .o_ctrl(ctrl_seg), .o_mid(mid_seg));

// and taylor series coefficient based on input
tanh_coef coef_sel (
    .i_sel(ctrl_seg),
    .o_coef0(coef0_coef_sel),
    .o_coef1(coef1_coef_sel),
    .o_coef2(coef2_coef_sel)
);

// multiplying and adding for taylor series
mult_2in mul2 (.i_a(coef1_coef_sel), .i_b(var_x), .o(o_mul2));
mult_3in mul3 (.i_a(coef2_coef_sel), .i_b(var_x), .i_c(var_x), .o(o_mul3));
adder_3in add (.i_a(coef0_coef_sel), .i_b(o_mul2), .i_c(o_mul3), .o(o_add));

assign o = i[WIDTH-1] ? (~o_add+1) : o_add; 

endmodule

