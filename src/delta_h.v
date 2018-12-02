////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : Delta Function for Hidden Layer
// File Name        : delta_h.v
// Version          : 1.0
// Description      : 
//
////////////////////////////////////////////////////////////////////////////////

module delta_h(clk, rst, en, i_a, i_prevd, i_w, o);

// parameters
parameter NUM = 2;
parameter WIDTH = 32;

// common ports
input clk, rst, en;

// input ports
input signed [NUM*WIDTH-1:0] i_prevd;
input signed [NUM*WIDTH-1:0] i_w;
input signed [NUM*WIDTH-1:0] i_a;

// output ports
output signed [WIDTH-1:0] o;

// wires
wire signed [NUM*WIDTH-1:0] o_mul;
wire signed [WIDTH-1:0] o_add;
wire signed [WIDTH-1:0] temp1;
wire signed [WIDTH-1:0] temp2;
wire signed [WIDTH-1:0] o_sig;

// registers
reg signed [WIDTH-1:0] o;

always @(posedge clk or posedge rst)
begin
	if (rst)
	begin
		// Initialization
		o <= 32'b0;
	end
	else
		o <= temp2;
end

// Select adder input
assign temp1 = en ? o : 32'b0;

// Generate N multiplier, o_mul is an array of multiplier outputs, WIDTH bits each
mult_2in #(.WIDTH(WIDTH)) mult[NUM-1:0] (.i_a(i_prevd), .i_b(i_w), .o(o_mul));

// Adding all multiplier output & bias
adder #(.NUM(NUM), .WIDTH(WIDTH)) add (.i(o_mul), .o(o_add));

// Compute differential sigmoid
div_sigmoid #(.WIDTH(WIDTH)) div_sgmd (.i(i_a), .o(o_sig));

// Multiply sum of delta * input * sigmoid'(a)
mult_2in #(.WIDTH(WIDTH)) mult[NUM:0] (.i_a(o_add), .i_b(i_sig), .o(o_mul));

// Accumulate
adder #(.NUM(NUM), .WIDTH(WIDTH)) acc (.i({o_add, temp1}), .o(temp2));

// Output
endmodule