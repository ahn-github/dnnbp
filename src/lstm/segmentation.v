
////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : Segmentation Module
// File Name        : segmentation.v
// Version          : 1.0
// Description      : Based on input segmentation, gives control signal and
//                    middle level
//
////////////////////////////////////////////////////////////////////////////////

module segmentation (i, o_ctrl, o_mid);

// parameters
parameter WIDTH = 32;

// input ports
input [WIDTH-1:0] i;

// output ports
output [2:0] o_ctrl;
output [WIDTH-1:0] o_mid;

// wires
wire [7:0] pos;
wire [WIDTH-1:0] twos_com;

// registers
reg [2:0] reg_ctrl;
reg [WIDTH-1:0] reg_mid;

// Taking the always positive value of i by:
assign twos_com = ~i + 1; // 2's complement value of i
assign pos = i[WIDTH-1] ? twos_com[31:24] : i[31:24]; // choosing positive value

// Gives output based on pos value
always@(pos)
begin
	if (pos<8'd1)
	begin
		reg_ctrl <= 3'b000;
//      reg_mid  <= 32'b0000_0000_0000_0000_0000_0000_0000_0000; // Centre = 0
		reg_mid  <= 32'b0000_0000_1000_0000_0000_0000_0000_0000; // Centre = 0,5
	end
	else if (pos<8'd2)
	begin
		reg_ctrl <= 3'b001;
		reg_mid  <= 32'b0000_0001_1000_0000_0000_0000_0000_0000; // Centre = 1,5
	end
	else if (pos<8'd3)
	begin
		reg_ctrl <= 3'b010;
		reg_mid  <= 32'b0000_0010_1000_0000_0000_0000_0000_0000; // Centre = 2,5
	end
	else if (pos<8'd4)
	begin
		reg_ctrl <= 3'b011;
		reg_mid  <= 32'b0000_0011_1000_0000_0000_0000_0000_0000; // Centre = 3,5
	end
	else if (pos<8'd6)
	begin
		reg_ctrl <= 3'b100;
		reg_mid  <= 32'b0000_1001_0000_0000_0000_0000_0000_0000; // Centre = 5
	end
	else begin
		reg_ctrl <= 3'b111;
		reg_mid  <= 32'b0000_0000_0000_0000_0000_0000_0000_0000;
	end
end

assign o_ctrl = reg_ctrl;
assign o_mid  = reg_mid;

endmodule
