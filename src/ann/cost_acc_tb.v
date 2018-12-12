////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : Cost Calculate Module
// File Name        : cost_acc_tb.v
// Version          : 1.0
// Description      : a testbench for Cost Calculate Module
//
////////////////////////////////////////////////////////////////////////////////

module cost_acc_tb();
// parameters
parameter WIDTH = 32;
parameter FRAC = 24;
parameter N_OUT = 2;

reg clk;
reg rst;
reg en;
reg signed [N_OUT*WIDTH-1:0] i_d;
wire signed [WIDTH-1:0] o;

endmodule