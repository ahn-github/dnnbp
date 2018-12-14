////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : LSTM Delta Calculation
// File Name        : delta.v
// Version          : 1.0
// Description      : Calculate delta in backpropagation
//
////////////////////////////////////////////////////////////////////////////////

module delta(i_d_h_prev, i_h, i_d_c_prev, i_c_prev, i_c, i_t, i_a, i_i, i_f, i_o, 
			 w_a, w_o, w_i, w_f, o_d_tot, o_dgates, o_d_x_now, o_d_h_next, o_d_c_next);

// parameters
parameter WIDTH = 32;
parameter FRAC  = 24;
parameter NUM = 2;

// common ports

// control ports

// input ports
input[WIDTH-1:0] i_t;
input[WIDTH-1:0] i_d_h_prev, i_h;
input[WIDTH-1:0] i_d_c_prev, i_c_prev, i_c;
input[WIDTH-1:0] i_a, i_i, i_f, i_o;
input[(NUM+1)*WIDTH-1:0] w_a, w_o, w_i, w_f;

// output ports
output[WIDTH-1:0] o_d_tot;
output[WIDTH-1:0] o_d_c_next;
output[4*WIDTH-1:0] o_dgates;
output[NUM*WIDTH-1:0] o_d_x_now;
output[WIDTH-1:0] o_d_h_next;



wire[NUM*WIDTH-1:0] d_x_now;
wire[WIDTH-1:0] temp_d_c_next;
wire[WIDTH-1:0] o_tan_c;
wire[WIDTH-1:0] temp_d_s01, temp_d_s02, temp_d_s03, temp_d_s04;
wire[WIDTH-1:0] temp_d_i01, temp_d_i02, temp_d_i03;
wire[WIDTH-1:0] temp_d_a01, temp_d_a02, temp_d_a03;
wire[WIDTH-1:0] temp_d_f01, temp_d_f02, temp_d_f03;
wire[WIDTH-1:0] temp_d_o01, temp_d_o02, temp_d_o03;
wire[4*WIDTH-1:0] temp_d_h01;

//////////////////////////////////////
// START OF δc_next CALCULATION //
//////////////////////////////////////

// Calculate error Δnow
assign o_d_tot = i_h - i_t;

// Calculate delta out and delta c
// δh_now
assign d_h = o_d_tot + i_d_h_prev;

// TANH(c)
tanh #(.WIDTH(WIDTH)) inst_tanh (.i(i_c), .o(o_tan_c));
mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) mult01 (.i_a(d_h), .i_b(i_o), .o(temp_d_s01));

// 1-tanh^2(c_now)
mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) mult02 (.i_a(o_tan_c), .i_b(o_tan_c), .o(temp_d_s02));
assign temp_d_s03 = 32'h01000000 - temp_d_s02;


// Term 1 δc_next
mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) mult03 (.i_a(temp_d_s01), .i_b(temp_d_s03), .o(temp_d_s04));

// Term 2 δc_next
mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) mult04 (.i_a(i_f_prev), .i_b(i_d_c_prev), .o(temp_d_c_next));


assign o_d_c_next = temp_d_c_next;
////////////////////////////////////
// END OF δc_next CALCULATION //
////////////////////////////////////


////////////////////////////////////
// START OF δGATES CALCULATION    //
////////////////////////////////////

// δaa
mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) mult05 (.i_a(temp_d_c_next), .i_b(i_i), .o(temp_d_i01));

// 1-aa^2
mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) mult06 (.i_a(i_a), .i_b(i_a), .o(temp_d_i02));
assign temp_d_i03 = 32'h01000000 - temp_d_i02;

mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) mult07 (.i_a(temp_d_i01), .i_b(temp_d_i03), .o(d_aa));

/*------------------------------------------------------------------------------------------*/

// δai
mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) mult08 (.i_a(temp_d_c_next), .i_b(i_a), .o(temp_d_a01));
mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) mult09 (.i_a(temp_d_a01), .i_b(i_i), .o(temp_d_a02));
//1-ai
assign temp_d_a03 = 32'h01000000 - i_i;
mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) mult10 (.i_a(temp_d_a02), .i_b(temp_d_a03), .o(d_ai));

/*------------------------------------------------------------------------------------------*/

// δaf
mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) mult11 (.i_a(temp_d_c_next), .i_b(c_prev), .o(temp_d_f01));
mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) mult12 (.i_a(temp_d_f01), .i_b(i_f), .o(temp_d_f02));
//1-af
assign temp_d_f03 = 32'h01000000 - i_f;
mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) mult13 (.i_a(temp_d_f02), .i_b(temp_d_f03), .o(d_af));

/*------------------------------------------------------------------------------------------*/

// δao
mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) mult14 (.i_a(temp_d_c_next), .i_b(o_tan_c), .o(temp_d_o01));
mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) mult15 (.i_a(temp_d_o01), .i_b(i_o), .o(temp_d_o02));
//1-ao
assign temp_d_f03 = 32'h01000000 - i_o;
mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) mult16 (.i_a(temp_d_o02), .i_b(temp_d_o03), .o(d_ao));

/*------------------------------------------------------------------------------------------*/


// Calculate δgates
assign dgates = {d_ao, d_af, d_ai, d_aa};

////////////////////////////////////
// END OF δGATES CALCULATION      //
////////////////////////////////////


generate
    genvar i;
    for (i = NUM; i > 0; i = i - 1)
    begin: dx
    	wire[4*WIDTH-1:0] temp1;
    	wire[4*WIDTH-1:0] out_mul_1;
    	
    	//δX_NOW
    	assign temp1 = {w_o[i*WIDTH-1:(i-1)*WIDTH],w_f[i*WIDTH-1:(i-1)*WIDTH],w_i[i*WIDTH-1:(i-1)*WIDTH],w_a[i*WIDTH-1:(i-1)*WIDTH]};
    	mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) mult17[3:0] (.i_a(dgates), .i_b(temp1), .o(out_mul_1));
		adder #(.NUM(NUM), .WIDTH(WIDTH)) add (.i(out_mul_1), .o(o_d_x_now[i*WIDTH-1:(i-1)*WIDTH]));
    end
endgenerate

//ΔH_NEXT
assign temp_d_h01 = {w_o[NUM*WIDTH-1:(NUM-1)*WIDTH],w_f[NUM*WIDTH-1:(NUM-1)*WIDTH],w_i[NUM*WIDTH-1:(NUM-1)*WIDTH],w_a[NUM*WIDTH-1:(NUM-1)*WIDTH]};
mult_2in #(.WIDTH(WIDTH), .FRAC(FRAC)) mult18[3:0] (.i_a(dgates), .i_b(temp_d_h01), .o(out_mul_2));
adder #(.NUM(NUM), .WIDTH(WIDTH)) add (.i(out_mul_2), .o(o_d_h_next));
endmodule