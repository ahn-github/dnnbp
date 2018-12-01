////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : Perceptron Module
// File Name        : perceptron.v
// Version          : 2.0
// Description      : Perceptron with NUM inputs, NUM weight, and 1 bias.
//                    Giving output of activation and weight value for
//					  backpropagation purpose.
//
////////////////////////////////////////////////////////////////////////////////

module perceptron (clk, rst, wr, i_k, i_w, i_b, o_a, o_w);

// parameters
parameter NUM = 2;
parameter WIDTH = 32;
parameter FILE_NAME = "mem_wght.list";

// common ports
input clk, rst;

// control ports
input wr;

// input ports
input signed [NUM*WIDTH-1:0] i_k;
input signed [NUM*WIDTH-1:0] i_w;
input signed [WIDTH-1:0] i_b;

// output ports
output signed [WIDTH-1:0] o_a;
output signed [NUM*WIDTH-1:0] o_w;

// wires
wire signed [NUM*WIDTH-1:0] o_mul;
wire signed [WIDTH-1:0] o_add;

// registers
reg signed [(NUM+1)*WIDTH-1:0] wght_mem [0:0];
reg signed [NUM*WIDTH-1:0] wght;

reg signed [WIDTH-1:0] bias;

always @(posedge clk or posedge rst)
begin
	if (rst)
	begin
		// RAM initialization
		$readmemb(FILE_NAME, wght_mem);
	end
	else if (wr)
	begin
		// To add new value to RAM
		wght_mem[0] <= i_w;
	end
	else
	begin
		// To read value from RAM
		wght <= wght_mem[0][NUM*WIDTH-1:0];
		bias <= wght_mem[0][(NUM+1)*WIDTH-1:NUM*WIDTH];
	end
end

// Generate N multiplier, o_mul is an array of multiplier outputs, WIDTH bits each
mult_2in #(.WIDTH(WIDTH)) mult[NUM-1:0] (.i_a(i_k), .i_b(wght), .o(o_mul));

// Adding all multiplier output & bias
adder #(.NUM(NUM+1), .WIDTH(WIDTH)) add (.i({bias, o_mul}), .o(o_add));

// Using sigmoid function for the Activation value
sigmf sigmoid (.i(o_add), .o(o_a));

// Tap the weight value to output port
assign o_w = wght;

endmodule