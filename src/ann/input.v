////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : Input Layer Module
// File Name        : input.v
// Version          : 1.0
// Description      : Input layer, 
//
////////////////////////////////////////////////////////////////////////////////

module in(i, o);

// parameters
parameter NUM = 2;
parameter WIDTH = 32;

// input ports
input signed [NUM*WIDTH-1:0] i;

// output ports
output signed [NUM*WIDTH-1:0] o;

assign o = i;

endmodule