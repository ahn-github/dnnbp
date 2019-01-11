
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
module memory_x(clk, rst, addr, data);

// parameters
parameter WIDTH = 32;
parameter NUM = 2;
parameter TIMESTEP = 7;
parameter FILENAME = "layer1_x.list";

// common ports
input clk, rst;

// control ports
input [WIDTH-1:0] addr;

// output ports
output signed [NUM*WIDTH-1:0] data;

// wires

// registers
reg signed [WIDTH-1:0] memory [0:NUM*TIMESTEP*2-1];

always @(posedge clk or posedge rst) begin
	if (rst)
	begin
		// reset
		$readmemh(FILENAME, memory);
	end
end

assign data = {memory[addr+1], memory[addr]};

endmodule
