module o_mem(clk, rst, addr, wr, i, o);

// parameters
parameter WIDTH = 32;

// common ports
input clk, rst;

// control ports
input [7:0] addr;
input wr;

// input ports
input signed [WIDTH-1:0] i;

// output ports
output signed [WIDTH-1:0] o;

// registers
reg signed [WIDTH-1:0] o;
reg signed [WIDTH-1:0] memory [7:0];

always @(posedge clk or posedge rst)
begin
	if (rst)
	begin
		$readmemh("mem_o.list", memory);
	end
	else if (wr)
	begin
		memory[addr] <= i;
	end
	else
		o <= memory[addr];
end

endmodule