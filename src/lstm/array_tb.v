
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
parameter NUM = 35;
parameter NUM_LSTM = 1;
parameter WIDTH = 32;
parameter FRAC = 24;

reg clk, rst, sel;
reg [WIDTH-1:0] temp_x, count;
reg [(NUM-1)*WIDTH-1:0] x; //register declaration for storing each line of file.

integer mem_input;

wire signed [NUM*WIDTH-1:0] o_w_a;
wire signed [NUM*WIDTH-1:0] o_w_i;
wire signed [NUM*WIDTH-1:0] o_w_f;
wire signed [NUM*WIDTH-1:0] o_w_o;
wire signed [WIDTH-1:0] o_b_a;
wire signed [WIDTH-1:0] o_b_i;
wire signed [WIDTH-1:0] o_b_f;
wire signed [WIDTH-1:0] o_b_o;

wire signed [NUM_LSTM*WIDTH-1:0] o_c;
wire signed [NUM_LSTM*WIDTH-1:0] o_h;
wire signed [NUM_LSTM*WIDTH-1:0] o_a;
wire signed [NUM_LSTM*WIDTH-1:0] o_i;
wire signed [NUM_LSTM*WIDTH-1:0] o_f;
wire signed [NUM_LSTM*WIDTH-1:0] o_o;

integer i;

lstm #(
        .WIDTH(WIDTH),
        .NUM(NUM),
        .NUM_LSTM(NUM_LSTM)
        
    ) inst_lstm (
        .clk   (clk),
        .rst   (rst),
        .sel   (sel),
        .i_x   (x),
        .i_w_a (i_w_a),
        .i_w_i (i_w_i),
        .i_w_f (i_w_f),
        .i_w_o (i_w_o),
        .i_b_a (i_b_a),
        .i_b_i (i_b_i),
        .i_b_f (i_b_f),
        .i_b_o (i_b_o),
        .o_w_a (o_w_a),
        .o_w_i (o_w_i),
        .o_w_f (o_w_f),
        .o_w_o (o_w_o),
        .o_b_a (o_b_a),
        .o_b_i (o_b_i),
        .o_b_f (o_b_f),
        .o_b_o (o_b_o),
        .o_a   (o_a),
        .o_i   (o_i),
        .o_f   (o_f),
        .o_o   (o_o),
        .o_c   (o_c),
        .o_h   (o_h)
    );


initial
begin
    
    	mem_input=$fopen("mem_x.txt","r");   //"r" means reading and "w" means writing
    	x <= 1088'h0;
    	count <=32'h0;
    
    // TESTING
    	clk = 1;
    	rst <= 1;
    	sel <=0;
	while (! $feof(mem_input)) 
    	begin 
		count <=0;
		rst <=0;
		sel =1;
		while (count<=NUM-1)
		begin
        		rst <= 1;
            		sel <=0;
        		$fscanf(mem_input,"%h\n", temp_x);
        		x= {temp_x, x[(NUM-1)*WIDTH-1:WIDTH]};
        		#10
			count<= count+1;
		end
	end
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