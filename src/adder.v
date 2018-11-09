////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : N Input Adder Module
// File Name        : adder.v
// Version          : 1.0
// Description      : adder N input
//
/////////////////////////////////////////

module adder(i, o);

// parameters
parameter NUM = 2;
parameter WIDTH = 32;

// input ports
input signed [NUM*WIDTH-1:0] i;

// output ports
output signed [WIDTH-1:0] o;

wire[31:0]o_add[NUM:0];

assign o_add[0] = 32'd0;

generate
	genvar j;
	for (j = 0; j < NUM; j = j + 1)
	begin:add
		assign o_add[j+1] = i[WIDTH*j +: WIDTH] + o_add[j];
	end
endgenerate

assign o = o_add[NUM];

endmodule