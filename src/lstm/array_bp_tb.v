
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

module array_bp_tb();

// parameters
parameter WIDTH = 32;
parameter FRAC = 24;
parameter NUM = 45;
parameter NUM_LSTM = 8;
parameter NUM_ITERATIONS = 8;
parameter FILENAMEA="mem_wghta";
parameter FILENAMEI="mem_wghti";
parameter FILENAMEF="mem_wghtf";
parameter FILENAMEO="mem_wghto";

reg clk, rst, sel, load_in, load_bp, load_t, load_h;

reg signed [(NUM+NUM_LSTM)*WIDTH-1:0] i_w_a;
reg signed [(NUM+NUM_LSTM)*WIDTH-1:0] i_w_i;
reg signed [(NUM+NUM_LSTM)*WIDTH-1:0] i_w_f;
reg signed [(NUM+NUM_LSTM)*WIDTH-1:0] i_w_o;
reg signed [WIDTH-1:0] i_b_a;
reg signed [WIDTH-1:0] i_b_i;
reg signed [WIDTH-1:0] i_b_f;
reg signed [WIDTH-1:0] i_b_o;
reg signed [WIDTH-1:0] i_addr_t;

wire signed [NUM_LSTM*WIDTH-1:0] o_h;

array_bp #(
        .WIDTH(WIDTH),
        .FRAC(FRAC),
        .NUM(NUM),
        .NUM_LSTM(NUM_LSTM),
        .NUM_ITERATIONS(NUM_ITERATIONS),
		.FILENAMEA(FILENAMEA),
		.FILENAMEI(FILENAMEI),
		.FILENAMEF(FILENAMEF),
		.FILENAMEO(FILENAMEO)
    ) array (
    	.clk      (clk),
		.rst      (rst),
		.sel      (sel),
		.load_in  (load_in),
		.load_bp  (load_bp),
		.load_t   (load_t),
		.load_h   (load_h),
		.i_w_a    (i_w_a),
		.i_w_i    (i_w_i),
		.i_w_f    (i_w_f),
		.i_w_o    (i_w_o),
		.i_b_a    (i_b_a),
		.i_b_i    (i_b_i),
		.i_b_f    (i_b_f),
		.i_b_o    (i_b_o),
		.i_addr_t (i_addr_t),
		.o_h      (o_h)
    );


initial
begin
    // setting
	clk = 1;
	rst <= 1;
	sel <=0;
	load_in <=0;
	load_bp <=0;
	load_h <=0;
	load_t <=0;
   	#100;

    //load t0
	rst <= 0;
    sel <=0; 
	load_in <=0;
	load_bp <=0;
	load_h <=0;
	#4400
   
	load_in <=1;
	load_bp <=1;
	#100 
   // calculating h
	load_in <=0;
	load_bp <=0;
	load_h <=1;
	#100

	load_in <=0;
	load_bp <=0;
	load_h <=0;
	#4300
  // load t1
	load_in <=1;
	load_bp <=1;
        #100
  // calculating h	
	load_in <=0;
	load_bp <=0;
	load_h<=1; 
	sel <=1;
	#100
	
	
        load_in <=0;
        load_bp <=0;
        load_h <=0;
	#4300
 // load t2
	load_in <=1;
	load_bp <=1;
	#100
 // calculating h
	load_in <=0;
	load_bp <=0;
	load_h <=1;
	#100

	load_in <=0;
	load_bp <=0;
	load_h <=0;
	#4300
 // load t3
	load_in <=1;
	load_bp <=1;
	#100
 // calculating h
	load_in <=0;
	load_bp <=0;
	load_h <=1;
	#100
	load_in <=0;
	load_bp <=0;
	load_h <=0;
	#4300
 // load t4
	load_in <=1;
	load_bp <=1;
	#100
 // calculating h
	load_in <=0;
	load_bp <=0;
	load_h <=1;
	#100
	load_in <=0;
	load_bp <=0;
	load_h <=0;
	#4300
 // load t5
	load_in <=1;
	load_bp <=1;
	#100
 // calculating h
	load_in <=0;
	load_bp <=0;
	load_h <=1;
	#100
	load_in <=0;
	load_bp <=0;
	load_h <=0;
	#4300
 // load t6
	load_in <=1;
	load_bp <=1;
	#100
 // calculating h
	load_in <=0;
	load_bp <=0;
	load_h <=1;
	#100
	load_in <=0;
	load_bp <=0;
	load_h <=0;
	#4300
 // load t7
	load_in <=1;
	load_bp <=1;
	#100
 // calculating h
	load_in <=0;
	load_bp <=0;
	load_h <=1;
	#100
	load_in <=0;
	load_bp <=0;
	load_h <=0;
	#4300;

// new input
	
//load t0
	rst <= 0;
        sel <=0; 
	load_in <=0;
	load_bp <=0;
    	load_h <=0;
	#4400
   
	load_in <=1;
	load_bp <=1;
	#100 
// calculating h
	load_in <=0;
	load_bp <=0;
	load_h <=1;
	#100

	load_in <=0;
	load_bp <=0;
	load_h <=0;
	#4300
  // load t1
	load_in <=1;
	load_bp <=1;
        #100
  // calculating h	
	load_in <=0;
	load_bp <=0;
	load_h<=1; 
	sel <=1;
	#100
	
	
        load_in <=0;
        load_bp <=0;
        load_h <=0;
	#4300
 // load t2
	load_in <=1;
	load_bp <=1;
	#100
 // calculating h
	load_in <=0;
	load_bp <=0;
	load_h <=1;
	#100

	load_in <=0;
	load_bp <=0;
	load_h <=0;
	#4300
 // load t3
	load_in <=1;
	load_bp <=1;
	#100
 // calculating h
	load_in <=0;
	load_bp <=0;
	load_h <=1;
	#100
	load_in <=0;
	load_bp <=0;
	load_h <=0;
	#4300
 // load t4
	load_in <=1;
	load_bp <=1;
	#100
 // calculating h
	load_in <=0;
	load_bp <=0;
	load_h <=1;
	#100
	load_in <=0;
	load_bp <=0;
	load_h <=0;
	#4300
 // load t5
	load_in <=1;
	load_bp <=1;
	#100
 // calculating h
	load_in <=0;
	load_bp <=0;
	load_h <=1;
	#100
	load_in <=0;
	load_bp <=0;
	load_h <=0;
	#4300
 // load t6
	load_in <=1;
	load_bp <=1;
	#100
 // calculating h
	load_in <=0;
	load_bp <=0;
	load_h <=1;
	#100
	load_in <=0;
	load_bp <=0;
	load_h <=0;
	#4300
 // load t7
	load_in <=1;
	load_bp <=1;
	#100;
		
end 


always
begin
    #50;
    clk = !clk;
end

always
begin
	i_addr_t = 0;
	load_t = 1;
	#100;
	i_addr_t = 1;
	#100;
	i_addr_t = 2;
	#100;
	i_addr_t = 3;
	#100;
	i_addr_t = 4;
	#100;
	i_addr_t = 5;
	#100;
	i_addr_t = 6;
	#100;
	i_addr_t = 7;
	load_t = 0;
	#100;

	#35100;
	// tunggu sampe data kedua

	i_addr_t = 8;
	load_t = 1;
	#100;
	i_addr_t = 9;
	#100;
	i_addr_t = 10;
	#100;
	i_addr_t = 11;
	#100;
	i_addr_t = 12;
	#100;
	i_addr_t = 13;
	#100;
	i_addr_t = 14;
	#100;
	i_addr_t = 15;
	load_t = 0;
	#100;

	#35100;
end

// always
// begin
//  #100
//  accu <= !accu;
//  #100
//  accu <= !accu;
//  #200;
// end

endmodule