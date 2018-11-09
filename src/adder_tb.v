////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : Testbench for N Input Adder Module
// File Name        : adder_tb.v
// Version          : 1.0
// Description      : testbench for adder N input
//
/////////////////////////////////////////

module adder_tb();

// parameters
parameter ITER = 5;
parameter NUM = 9;
parameter WIDTH = 32;

// registers
reg signed [NUM*WIDTH-1:0] i;

// wires
wire signed [WIDTH-1:0] o;
wire signed [WIDTH-1:0] reference;

integer k, error, match;

adder #(.NUM(NUM), .WIDTH(WIDTH)) inst_adder (.i(i), .o(o));

initial
begin
	error = ITER;
	match = 0;
	repeat(ITER)
	begin
		for (k = 0; k < NUM; k = k+1)
		begin
			i[k*WIDTH +: WIDTH] = $random;
		end
		#50;
		if (o == (reference)) begin
			match = match + 1;
		end
		error = ITER - match;
	end
	$monitor("## Simulasi Modul adder ##");
    $display(" ");
    $display("Pengujian Benar : %d", match);
    $display("Pengujian Salah : %d", error);
    $display("Persentase Benar : %d persen", (match*100)/5);
    $display(" ");
end

generate
	genvar j;
	for (j = 0; j < NUM; j = j + 1)
	begin:number
		wire signed [WIDTH-1:0] x;
		assign x = i[j*WIDTH +: WIDTH];
	end
endgenerate

assign reference = number[0].x + number[1].x + number[2].x +
				   number[3].x + number[4].x + number[5].x +
				   number[6].x + number[7].x + number[8].x;
endmodule

