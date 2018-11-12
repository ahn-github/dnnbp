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

// wires
wire signed [WIDTH-1:0] o_add [NUM*2-2:0];

// assign o_add[0] = 32'd0;

generate
	genvar j;

	// set input as the first NUM
	for (j = 0; j < NUM; j = j + 1)
	begin:init
		assign o_add[j] = i[j*WIDTH +: WIDTH];
	end

	// adding adjacent o_add
	for (j = 0; j < NUM - 1; j = j + 1 )
	begin:add
		assign o_add[NUM+j] = o_add[j*2] + o_add[j*2+1];
	end
endgenerate

assign o = o_add[NUM*2-2];

endmodule