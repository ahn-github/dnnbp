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
module  mem_input(addr, data);

// parameters
parameter WIDTH = 32;
parameter NUM = 3;
parameter NUM_ITERATIONS = 5

input signed [WIDTH-1:0] addr;
output [NUM*WIDTH-1:0] data;

reg signed [NUM*WIDTH-1:0] input_memory [0:NUM*NUM_ITERATIONS-1];

initial begin
$readmemh("mem_input.list", input_memory);
end

assign data = input_memory[addr];
endmodule