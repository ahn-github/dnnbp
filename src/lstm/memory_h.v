module memory_h1(clk, rst, wr, rd_addr, wr_addr, i, o);

// parameters
parameter WIDTH = 32;
parameter NUM_LSTM = 53;
parameter TIMESTEP = 7;
parameter FILENAME = "memory_h.list";

// common ports
input clk, rst;

// control ports
input wr;
input [8:0] rd_addr, wr_addr;

// input ports
input signed [WIDTH-1:0] i;

// output ports
output signed [NUM_LSTM*WIDTH-1:0] o;

// wires

// registers
reg signed [WIDTH-1:0] memory [0:NUM_LSTM*(TIMESTEP+1)-1];

always @(posedge clk or posedge rst) begin
	if (rst)
	begin
		// Reset
		$readmemh(FILENAME, memory);
	end
	else if (wr)
	begin
		// Add 1 last output Value
		memory[wr_addr] = i;
	end
end

assign o = {memory[rd_addr+52], memory[rd_addr+51], memory[rd_addr+50], memory[rd_addr+49], 
	        memory[rd_addr+48], memory[rd_addr+47], memory[rd_addr+46], memory[rd_addr+45], 
	        memory[rd_addr+44], memory[rd_addr+43], memory[rd_addr+42], memory[rd_addr+41], 
	        memory[rd_addr+40], memory[rd_addr+39], memory[rd_addr+38], memory[rd_addr+37], 
	        memory[rd_addr+36], memory[rd_addr+35], memory[rd_addr+34], memory[rd_addr+33], 
	        memory[rd_addr+32], memory[rd_addr+31], memory[rd_addr+30], memory[rd_addr+29], 
	        memory[rd_addr+28], memory[rd_addr+27], memory[rd_addr+26], memory[rd_addr+25], 
	        memory[rd_addr+24], memory[rd_addr+23], memory[rd_addr+22], memory[rd_addr+21], 
	        memory[rd_addr+20], memory[rd_addr+19], memory[rd_addr+18], memory[rd_addr+17], 
	        memory[rd_addr+16], memory[rd_addr+15], memory[rd_addr+14], memory[rd_addr+13], 
	        memory[rd_addr+12], memory[rd_addr+11], memory[rd_addr+10], memory[rd_addr+9], 
	        memory[rd_addr+8], memory[rd_addr+7], memory[rd_addr+6], memory[rd_addr+5], 
	        memory[rd_addr+4], memory[rd_addr+3], memory[rd_addr+2], memory[rd_addr+1], 
	        memory[rd_addr+0]};



endmodule

module memory_h2(clk, rst, wr, rd_addr, wr_addr, i, o);

// parameters
parameter WIDTH = 32;
parameter NUM_LSTM = 8;
parameter TIMESTEP = 7;
parameter FILENAME = "memory_h.list";

// common ports
input clk, rst;

// control ports
input wr;
input [8:0] rd_addr, wr_addr;

// input ports
input signed [WIDTH-1:0] i;

// output ports
output signed [NUM_LSTM*WIDTH-1:0] o;

// wires

// registers
reg signed [WIDTH-1:0] memory [0:NUM_LSTM*(TIMESTEP+1)-1];

always @(posedge clk or posedge rst) begin
	if (rst)
	begin
		// Reset
		$readmemh(FILENAME, memory);
	end
	else if (wr)
	begin
		// Add 1 last output Value
		memory[wr_addr] = i;
	end
end

assign o = {memory[rd_addr+7], memory[rd_addr+6], memory[rd_addr+5], memory[rd_addr+4], 
			memory[rd_addr+3], memory[rd_addr+2], memory[rd_addr+1], memory[rd_addr+0]};

endmodule