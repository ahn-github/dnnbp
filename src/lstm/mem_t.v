
////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : Label Memory
// File Name        : mem_t.v
// Version          : 2.0
// Description      : top level of long short term memory forward propagation
//                    
//            
///////////////////////////////////////////////////////////////////////////////
module  mem_t(addr, data);

// parameters
parameter WIDTH = 32;
parameter NUM = 8;  // number of feature + 1
parameter NUM_ITERATIONS = 2;

input [WIDTH-1:0] addr;
output signed [WIDTH-1:0] data;

reg signed [WIDTH-1:0] input_memory [0:NUM*NUM_ITERATIONS-1];

initial begin
$readmemh("mem_label.list", input_memory);
end

assign data = input_memory[addr];
endmodule
