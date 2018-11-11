////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name		: Perceptron Testbench
// File Name		: perceptron_tb.v
// Version			: 1.0
// Description		: Testbench for perceptron module
//
////////////////////////////////////////////////////////////////////////////////

module percepton_tb();

// parameters
parameter NUM = 2;
parameter WIDTH = 32;
parameter FRAC = 24;
parameter DIV = 16777215;

// wires
wire signed [31:0] a_dut;
// wire signed [31:0] z_dut;
// wire signed [7:0] k0_msb, k1_msb, w0_msb, w1_msb, b_msb, a_msb, z_msb;
// wire [23:0] k0_frac, k1_frac, w0_frac, w1_frac, b_frac, a_frac, z_frac;

// registers
reg signed [NUM*WIDTH-1:0] k;
reg signed [NUM*WIDTH-1:0] w;
reg signed [WIDTH-1:0] b;

// other variables
integer f, i;

perceptron #(.NUM(NUM), .WIDTH(WIDTH)) dut (.i_k(k), .i_w(w), .i_b(b), .o(a_dut));

initial begin
	f = $fopen("output.txt","w");
	k[31:0] = $random;
	k[63:32] = $random;
	w = $random;
	b = $random;
	// b[WIDTH-1:0] = 32'b0000_0000_0010_0000_0000_0000_0000_0000;
	// k[WIDTH-1:FRAC] = 32'd5;
	// k[FRAC-1:0] = 32'd0;
	// k[2*WIDTH-1:WIDTH+FRAC] = -32'd3;
	// k[WIDTH+FRAC:WIDTH] = -32'd0;
	// w[WIDTH-1:0] = 32'b0000_0000_0100_0000_0000_0000_0000_0000;
	// w[2*WIDTH-1:WIDTH] = 32'b0000_0000_0010_0000_0000_0000_0000_0000;
	#50;
	$fwrite(f, "%d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d, %d\n",
			k[31-:8], k[0+:24], w[31-:8], w[0+:24],
			k[63-:8], k[32+:24], w[63-:8], w[32+:24],
			b[31-:8], b[0+:24], a_dut[31-:8], a_dut[0+:24]
	);
	// repeat(50) begin
	// 	for (i = 0; i < NUM; i = i+1)
	// 	begin
	// 		k[(i+1)*WIDTH-1 -: 8] = $random%3;
	// 		k[i*WIDTH +: FRAC] = $random;

	// 		w[i*WIDTH +: WIDTH] = 32'd0;
	// 		w[i*WIDTH +: FRAC] = $random;
	// 		$display("%d, %d, %d, %d, %d, %d, ", 
	// 				k[(i+1)*WIDTH-1 -: 8], k[i*WIDTH +: FRAC],
	// 				w[(i+1)*WIDTH-1 -: 8], w[i*WIDTH +: FRAC],
	// 				b[WIDTH-1 -: 8]      , b[FRAC-1:0]
	// 		);
	// 		$fwrite(f, "%d, %d, %d, %d, %d, %d, ", 
	// 				k[(i+1)*WIDTH-1 -: 8], k[i*WIDTH +: FRAC],
	// 				w[(i+1)*WIDTH-1 -: 8], w[i*WIDTH +: FRAC],
	// 				b[WIDTH-1 -: 8]      , b[FRAC-1:0]
	// 		);
	// 	end
	// 	$display("---");
	// 	#50;

	// 	// $display("%d, %d, %d, %d, ", k1_msb, k1_frac, w1_msb, w1_frac);
	// 	// $display("%d, %d, %d, %d, ", b_msb,  b_frac,  z_msb,  z_frac);
	// 	// $display("%d, %d\n", a_msb,  a_frac);

	// 	// $fwrite(f, "%d, %d, %d, %d, ", k0_msb, k0_frac, w0_msb, w0_frac);
	// 	// $fwrite(f, "%d, %d, %d, %d, ", k1_msb, k1_frac, w1_msb, w1_frac);
	// 	// $fwrite(f, "%d, %d, %d, %d, ", b_msb,  b_frac,  z_msb,  z_frac);
	// 	$fwrite(f, "%d, %d\n", a_dut[WIDTH-1 -: 8], a_dut[FRAC-1:0]);
	// end
	// #50;
	// $display("%d, %d\n", w0[31:24], w0[23:0]);
	$fclose(f);
end

// assign k0_msb = k0[31:24]; assign k0_frac = k0[23:0];
// assign k1_msb = k1[31:24]; assign k1_frac = k1[23:0];
// assign w0_msb = w0[31:24]; assign w0_frac = w0[23:0];
// assign w1_msb = w1[31:24]; assign w1_frac = w1[23:0];
// assign b_msb  = b[31:24];  assign b_frac  = b[23:0];
// assign a_msb  = a_dut[31:24];  assign a_frac  = a_dut[23:0];
// assign z_msb  = z_dut[31:24];  assign z_frac  = z_dut[23:0];

endmodule