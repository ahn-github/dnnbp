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
///////////////////////////////////////////////////////////////////////////////
module  mem_input_y(clk, rst, addr, labels);

// parameters
parameter WIDTH = 32;
parameter NUM = 68;  // number of feature + 1
parameter NUM_ITERATIONS = 8;

// common ports
input clk, rst;
input [WIDTH-1:0] addr;

// output ports
output signed labels;

reg signed wght_mem [0:NUM_ITERATIONS*NUM];

initial begin
	$readmemh('mem_y', wght_mem);
end

// To read value from RAM
assign labels = wght_mem[addr];
endmodule 
