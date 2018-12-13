////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : Array Testbench Module
// File Name        : array_tb.v
// Version          : 1.0
// Description      : a Testbench to test arry with backpropagation
//
////////////////////////////////////////////////////////////////////////////////

module array_tb();

// parameters
parameter N_IN = 2;
parameter N_OUT = 2;
parameter N_HL = 1;
parameter N_HL_P = 3;
parameter WIDTH = 32;
parameter FRAC = 24;

reg clk, rst;
reg wr;
reg accu;
reg rst_btch;
reg load;
reg signed [N_IN*WIDTH-1:0] i_k;
reg signed [N_OUT*WIDTH-1:0] i_t;
reg signed [WIDTH-1:0] i_lr;
wire signed [WIDTH-1:0] o_cost;
wire signed [WIDTH-1:0] o_1;
wire signed [WIDTH-1:0] o_2;

integer i;

array #(
		.N_IN(N_IN),
		.N_OUT(N_OUT),
		.N_HL(N_HL),
		.N_HL_P(N_HL_P),
		.WIDTH(WIDTH),
		.FRAC(FRAC)
	) inst_array (
		.clk      (clk),
		.rst      (rst),
		.wr       (wr),
		.accu     (accu),
		.rst_btch (rst_btch),
		.load     (load),
		.i_k      (i_k),
		.i_t      (i_t),
		.i_lr     (i_lr),
		.o_cost   (o_cost),
		.o_1      (o_1),
		.o_2      (o_2)
	);

initial
begin
	// TRAINING
	clk = 1;
	rst <= 1;
	wr <= 0;
	accu <= 0;
	load <= 1;
	i_lr <= 32'hffe66666;
	rst_btch <= 1;
	i = 0;

	i_k <= 64'h08000000_08000000;
	i_t <= 64'h00000000_01000000;
	#100;
	rst <= 0;
	rst_btch <= 0;
	#300;
	accu <= 1;
	#100;
	accu <= 0;

	repeat(10000)
	begin
		// 8,5
		i_k <= 64'h08000000_05000000;
		i_t <= 64'h01000000_00000000;
		#300;
		accu <= 1;
		#100;
		accu <= 0;

		// 5.8
		i_k <= 64'h05000000_08000000;
		i_t <= 64'h01000000_00000000;
		#300;
		accu <= 1;
		#100;
		accu <= 0;

		// 5,5
		i_k <= 64'h05000000_05000000;
		i_t <= 64'h01000000_00000000;
		#300;
		accu <= 1;
		#100;
		accu <= 0;

		// Update Weight
		wr <= 1;
		#100;
		wr <= 0;
		i = i + 1;
		$display("%d, %x", i, o_cost);
		if (i == 10000)
			$display("FINAL COST: %x", o_cost);
		rst_btch <= 1;
		#100; // delay for write to memory & reset cost
		rst_btch <= 0;

		// 8,8
		i_k = 64'h08000000_08000000;
		i_t <= 64'h00000000_01000000;
		#300;
		accu <= 1;
		#100;
		accu <= 0;
	end

	$display("TRAINING ENDED");
	// TESTING
	// clk = 1;
	// rst <= 1;
	// wr <= 0;
	// accu <= 0;
	// load <= 1;
	// i_lr <= 32'hffe66666;
	// rst_btch <= 1;
	// i = 1;

	// Resetting
	rst = 1;
	rst_btch = 1;
	#100;
	rst = 0;
	rst_btch = 0;

	i_k = 64'h08000000_08000000;
	i_t <= 64'h00000000_01000000;
	#100;
	rst <= 0;
	rst_btch <= 0;
	#300;
	accu <= 1;
	#100;
	accu <= 0;
	#500;
	// Printing output of 8,8
	$display("input= k1=8, k2=8");
	$display("a1=%x, a2=%x", o_1, o_2);
	$display("cost=%x", o_cost);

	// Resetting
	rst = 1;
	rst_btch = 1;
	#100;
	rst = 0;
	rst_btch = 0;

	// 8,5
	i_k <= 64'h08000000_05000000;
	i_t <= 64'h01000000_00000000;
	#300;
	accu <= 1;
	#100;
	accu <= 0;
	#500;
	$display("input= k1=8, k2=5");
	$display("a1=%x, a2=%x", o_1, o_2);
	$display("cost=%x", o_cost);

	// Resetting
	rst = 1;
	rst_btch = 1;
	#100;
	rst = 0;
	rst_btch = 0;

	// 5.8
	i_k <= 64'h05000000_08000000;
	i_t <= 64'h01000000_00000000;
	#300;
	accu <= 1;
	#100;
	accu <= 0;
	#500;
	$display("input= k1=5, k2=8");
	$display("a1=%x, a2=%x", o_1, o_2);
	$display("cost=%x", o_cost);

	// Resetting
	rst = 1;
	rst_btch = 1;
	#100;
	rst = 0;
	rst_btch = 0;

	// 5,5
	i_k <= 64'h05000000_05000000;
	i_t <= 64'h01000000_00000000;
	#300;
	accu <= 1;
	#100;
	accu <= 0;
	#500;
	$display("input= k1=5, k2=5");
	$display("a1=%x, a2=%x", o_1, o_2);
	$display("cost=%x", o_cost);

end

always
begin
	#50
	clk = !clk;
end

// always
// begin
// 	#100
// 	accu <= !accu;
// 	#100
// 	accu <= !accu;
// 	#200;
// end

endmodule