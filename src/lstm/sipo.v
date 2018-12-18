
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
////////////////////////////////////////////////////////////////////////////////

module sipo (clk, rst, o);

parameter WIDTH = 32;
parameter NUM = 69;
parameter NUM_ITERATIONS = 8;

input clk, rst;
output [(NUM-1)*WIDTH-1:0]  o;

wire [WIDTH-1:0] addrinput;
wire [WIDTH-1:0] x_t;



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
		.NUM_ITERATIONS(NUM-1),
		.WIDTH(WIDTH)
	) inst_shift_reg (
		.clk (clk),
		.rst (rst),
		.i   (x_t),
		.o   (o)
	);

endmodule
