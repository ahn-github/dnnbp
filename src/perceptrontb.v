module perceptrontb();

// parameters
parameter NUM = 2;
parameter WIDTH = 32;
parameter FRAC = 24;

// registers
// reg signed [31:0] k0;
// reg signed [31:0] k1;
// reg signed [31:0] w0;
// reg signed [31:0] w1;
reg signed [NUM*WIDTH-1:0] k;
reg signed [NUM*WIDTH-1:0] w;
reg signed [WIDTH-1:0] b;
wire signed [WIDTH-1:0] z;

// variables
integer f, i;

// perceptron #(.NUM(NUM), .WIDTH(WIDTH)) dut (.i_k({k1, k0}), .i_w({w1, w0}), .i_b(b), .o(z));
perceptron #(.NUM(NUM), .WIDTH(WIDTH)) dut (.i_k(k), .i_w(w), .i_b(b), .o(z));

initial
begin
	f = $fopen("output.txt","w");
	repeat(5)
	begin
		for (i = 1; i <= NUM; i = i + 1)
		begin
			k[i*WIDTH-1 -: 8] = $random%3;
			k[i*WIDTH-9 -: FRAC] = $random;
			$fwrite(f, "%d, %d, ", k[i*WIDTH-1 -: 8], k[i*WIDTH-9 -: FRAC]);
		end

		for (i = 1; i <= NUM; i = i + 1)
		begin
			w[i*WIDTH-1 -: 8] = $random%3;
			w[i*WIDTH-9 -: FRAC] = $random;
			$fwrite(f, "%d, %d, ", w[i*WIDTH-1 -: 8], w[i*WIDTH-9 -: FRAC]);
		end

		b[WIDTH-1:FRAC] = 8'd0;
		b[FRAC-1:0] = $random;
		$fwrite(f, "%d, %d, ", k[WIDTH-1 -: 8], k[FRAC-1 -: FRAC]);
		#50;
		$fwrite(f, "%d, %d\n", z[WIDTH-1 -: 8], z[FRAC-1 -: FRAC]);
	end
	$fclose(f);
end


endmodule