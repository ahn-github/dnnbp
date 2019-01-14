
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
parameter NUM = 53;
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

assign data = {memory[addr+52], memory[addr+51], memory[addr+50], memory[addr+49], 
	           memory[addr+48], memory[addr+47], memory[addr+46], memory[addr+45], 
	           memory[addr+44], memory[addr+43], memory[addr+42], memory[addr+41], 
	           memory[addr+40], memory[addr+39], memory[addr+38], memory[addr+37], 
	           memory[addr+36], memory[addr+35], memory[addr+34], memory[addr+33], 
	           memory[addr+32], memory[addr+31], memory[addr+30], memory[addr+29], 
	           memory[addr+28], memory[addr+27], memory[addr+26], memory[addr+25], 
	           memory[addr+24], memory[addr+23], memory[addr+22], memory[addr+21], 
	           memory[addr+20], memory[addr+19], memory[addr+18], memory[addr+17], 
	           memory[addr+16], memory[addr+15], memory[addr+14], memory[addr+13], 
	           memory[addr+12], memory[addr+11], memory[addr+10], memory[addr+9], 
	           memory[addr+8], memory[addr+7], memory[addr+6], memory[addr+5], 
	           memory[addr+4], memory[addr+3], memory[addr+2], memory[addr+1], 
	           memory[addr+0]};

endmodule
