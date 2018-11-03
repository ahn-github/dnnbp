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

// wires
wire signed [31:0] a_dut;
wire signed [31:0] z_dut;
wire signed [7:0] k0_msb, k1_msb, w0_msb, w1_msb, b_msb, a_msb, z_msb;
wire [23:0] k0_frac, k1_frac, w0_frac, w1_frac, b_frac, a_frac, z_frac;

// registers
reg signed [31:0] k0;
reg signed [31:0] k1;
reg signed [31:0] w0;
reg signed [31:0] w1;
reg signed [31:0] b;

// other variables
integer f;

perceptron dut (.i_k0(k0), .i_k1(k1), .i_w0(w0), .i_w1(w1), .i_bias(b), .o_a(a_dut), .o_z(z_dut));

initial begin
	f = $fopen("output.txt","w");
	repeat(50) begin
		w0[31:24] <= 8'd0;
		w0[23:0] <= $random;
		w1[31:24] <= 8'd0;
		w1[23:0] <= $random;
		b[31:24] <= 8'd0;
		b[23:0] <= $random;
		k0[31:24] <= $random%3;
		k0[23:0] <= $random;
		k1[31:24] <= $random%3;
		k1[23:0] <= $random;
		#50;
		$display("%d, %d, %d, %d, ", k0_msb, k0_frac, w0_msb, w0_frac);
		$display("%d, %d, %d, %d, ", k1_msb, k1_frac, w1_msb, w1_frac);
		$display("%d, %d, %d, %d, ", b_msb,  b_frac,  z_msb,  z_frac);
		$display("%d, %d\n", a_msb,  a_frac);

		$fwrite(f, "%d, %d, %d, %d, ", k0_msb, k0_frac, w0_msb, w0_frac);
		$fwrite(f, "%d, %d, %d, %d, ", k1_msb, k1_frac, w1_msb, w1_frac);
		$fwrite(f, "%d, %d, %d, %d, ", b_msb,  b_frac,  z_msb,  z_frac);
		$fwrite(f, "%d, %d\n", a_msb,  a_frac);
	end
	#50;
	// $display("%d, %d\n", w0[31:24], w0[23:0]);
	$fclose(f);
end

assign k0_msb = k0[31:24]; assign k0_frac = k0[23:0];
assign k1_msb = k1[31:24]; assign k1_frac = k1[23:0];
assign w0_msb = w0[31:24]; assign w0_frac = w0[23:0];
assign w1_msb = w1[31:24]; assign w1_frac = w1[23:0];
assign b_msb  = b[31:24];  assign b_frac  = b[23:0];
assign a_msb  = a_dut[31:24];  assign a_frac  = a_dut[23:0];
assign z_msb  = z_dut[31:24];  assign z_frac  = z_dut[23:0];

endmodule