module tsdt(clk, rst, i, o);

input clk, rst;

input [1:0] i;
output reg [1:0] o;

always @(posedge clk) begin
	o <= i;
end

endmodule