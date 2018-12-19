
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
parameter NUM = 45;
parameter NUM_LSTM = 8;
parameter NUM_ITERATIONS = 8;
parameter WIDTH = 32;

reg clk, rst, sel,load;
reg [WIDTH-1:0] temp_x, count;
reg [(NUM-1)*WIDTH-1:0] x; //register declaration for storing each line of file.

integer mem_input;

wire signed [(NUM+NUM_LSTM)*WIDTH-1:0] o_w_a;
wire signed [(NUM+NUM_LSTM)*WIDTH-1:0] o_w_i;
wire signed [(NUM+NUM_LSTM)*WIDTH-1:0] o_w_f;
wire signed [(NUM+NUM_LSTM)*WIDTH-1:0] o_w_o;
wire signed [WIDTH-1:0] o_b_a;
wire signed [WIDTH-1:0] o_b_i;
wire signed [WIDTH-1:0] o_b_f;
wire signed [WIDTH-1:0] o_b_o;


wire signed [NUM_LSTM*WIDTH-1:0] o_h;

integer i;

array #(
        .WIDTH(WIDTH),
        .NUM(NUM),
        .NUM_LSTM(NUM_LSTM),
        .NUM_ITERATIONS(NUM_ITERATIONS)
    ) inst_array (
        .clk   (clk),
        .rst   (rst),
        .sel   (sel),
        .load  (load),
        .i_w_a (i_w_a),
        .i_w_i (i_w_i),
        .i_w_f (i_w_f),
        .i_w_o (i_w_o),
        .i_b_a (i_b_a),
        .i_b_i (i_b_i),
        .i_b_f (i_b_f),
        .i_b_o (i_b_o),
        .o_h   (o_h)
    );


initial
begin
    
    
    // TESTING
    	clk = 1;
    	rst <= 1;
    	sel <=0;
	load <=0;
        #100
	rst <= 0;
        sel <=0; 
	load <=0;
	#4400
	load <=1;
	#100
	load <=0;
	rst <=0;
	sel <=0;
	#4400
	load <=1;
	sel<=1;
	#100
        load <=0;
	rst <=0;
	sel <=0;
	#4400
	load <=1;
	sel<=1;
        #100
        load <=0;
	rst <=0;
	sel <=0;
	#4400
	load <=1;
	sel<=1;
        #100
        load <=0;
	rst <=0;
	sel <=0;
	#4400
	load <=1;
	sel<=1;
        #100
        load <=0;
	rst <=0;
	sel <=0;
	#4400
	load <=1;
	sel<=1;
        #100
        load <=0;
	rst <=0;
	sel <=0;
	#4400
	load <=1;
	sel<=1;
	#100
        load <=0;
	rst <=0;
	sel <=0;
	#4400
	load <=1;
	sel<=1;


		
end 


always
begin
    #50
    clk = !clk;
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