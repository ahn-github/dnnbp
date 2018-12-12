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
parameter ITER = 50;
parameter NUM = 30;
parameter WIDTH = 32;

// registers
reg signed [NUM*WIDTH-1:0] i;

// wires
wire signed [WIDTH-1:0] o;
reg signed [WIDTH-1:0] reference;

integer k, error, match;

adder #(.NUM(NUM), .WIDTH(WIDTH)) inst_adder (.i(i), .o(o));

initial
begin
	error = ITER;
	match = 0;
	repeat(ITER)
	begin
		reference = 0;
		for (k = 0; k < NUM; k = k+1)
		begin
			i[k*WIDTH +: WIDTH] = $random;
			reference = i[k*WIDTH +: WIDTH] + reference;
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
    $display("Persentase Benar : %d persen", (match*100)/ITER);
    $display(" ");
end

endmodule

