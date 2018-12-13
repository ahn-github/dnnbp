////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : Delta Weight & Bias Calculate 
// File Name        : wght_bias_calc.v
// Version          : 1.0
// Description      : Module to calculate the weight and bias difference
//                    for LSTM Network with 1 Layer LSTM
//
////////////////////////////////////////////////////////////////////////////////

module wght_bias_calc(clk, rst, en, i_x, i_h, i_da, i_di, i_df, i_do, o_b, o_wa, o_wi, o_wf, o_wo);

// parameters
parameter WIDTH = 32;
parameter FRAC = 24;
parameter N_IN = 2; // Num of Input + 1 for previous Output
parameter N_OUT = 4;

// common ports
input clk, rst;

// control ports
input en;

// input ports
input signed [N_IN*WIDTH-1:0] i_x;
input signed [N_OUT*WIDTH-1:0] i_h;
input signed [N_OUT*WIDTH-1:0] i_da;
input signed [N_OUT*WIDTH-1:0] i_di;
input signed [N_OUT*WIDTH-1:0] i_df;
input signed [N_OUT*WIDTH-1:0] i_do;

// output ports
output signed [4*N_OUT*WIDTH-1:0] o_b;
output signed [N_IN*N_OUT*WIDTH-1:0] o_wa;
output signed [N_IN*N_OUT*WIDTH-1:0] o_wi;
output signed [N_IN*N_OUT*WIDTH-1:0] o_wf;
output signed [N_IN*N_OUT*WIDTH-1:0] o_wo;

generate
    genvar i;
    genvar j;

    ///////////////////////////////////////////////
    // Bias Calculation
    // bias[i] = bias for cell number i in layer
    // o_b structure:
    // n-th cell Bias is placed on left side, while
    // first cell Bias on right
    // [   cell_n    |------|   cell_0    ]
    // [ bo|bf|bi|ba |------| bo|bf|bi|ba ]
    for (i = 0; i < N_OUT; i = i + 1)
    begin:bias
        bias_acc #(
                .WIDTH(WIDTH)
            ) ba (
                .clk(clk), 
                .rst(rst), 
                .en(en), 
                .i(i_da[(i+1)*WIDTH-1:i*WIDTH]), 
                .o(o_b[(i+1)*WIDTH-1:i*WIDTH])
            );
        bias_acc #(
                .WIDTH(WIDTH)
            ) bi (
                .clk(clk), 
                .rst(rst), 
                .en(en), 
                .i(i_di[(i+1)*WIDTH-1:i*WIDTH]), 
                .o(o_b[(i+2)*WIDTH-1:(i+1)*WIDTH])
            );
        bias_acc #(
                .WIDTH(WIDTH)
            ) bf (
                .clk(clk), 
                .rst(rst), 
                .en(en), 
                .i(i_df[(i+1)*WIDTH-1:i*WIDTH]), 
                .o(o_b[(i+3)*WIDTH-1:(i+2)*WIDTH])
            );
        bias_acc #(
                .WIDTH(WIDTH)
            ) bo (
                .clk(clk), 
                .rst(rst), 
                .en(en), 
                .i(i_do[(i+1)*WIDTH-1:i*WIDTH]), 
                .o(o_b[(i+4)*WIDTH-1:(i+3)*WIDTH])
            );
    end

    ////////////////////////////////////////////////////////////////////
    // Weight Calculation (# is either a, i, f, o)
    // w#[i].x[j] = Weight A of input x[j] for cell number i in layer
    // o_w# structure:
    // n-th cell Wa is placed on left side, while first cell Wa on right
    // [     cell_n     |------|     cell_0     ]
    // [ x_n |----| x_0 |------| x_n |----| x_0 ]
    for (i = 0; i < N_OUT; i = i + 1)
    begin:wa
        for (j = 0; j < N_IN; j = j + 1)
        begin:x
            wght_acc #(
                    .WIDTH(WIDTH),
                    .FRAC(FRAC)
                ) w_acc (
                    .clk (clk),
                    .rst (rst),
                    .en  (en),
                    .i_d (i_da[(i+1)*WIDTH-1:i*WIDTH]),
                    .i_x ( i_x[(j+1)*WIDTH-1:j*WIDTH]),
                    .o   (o_wa[(2*i+j+1)*WIDTH-1:(2*i+j)*WIDTH])
                );
        end
    end

    for (i = 0; i < N_OUT; i = i + 1)
    begin:wi
        for (j = 0; j < N_IN; j = j + 1)
        begin:x
            wght_acc #(
                    .WIDTH(WIDTH),
                    .FRAC(FRAC)
                ) w_acc (
                    .clk (clk),
                    .rst (rst),
                    .en  (en),
                    .i_d (i_di[(i+1)*WIDTH-1:i*WIDTH]),
                    .i_x ( i_x[(j+1)*WIDTH-1:j*WIDTH]),
                    .o   (o_wi[(2*i+j+1)*WIDTH-1:(2*i+j)*WIDTH])
                );
        end
    end

    for (i = 0; i < N_OUT; i = i + 1)
    begin:wf
        for (j = 0; j < N_IN; j = j + 1)
        begin:x
            wght_acc #(
                    .WIDTH(WIDTH),
                    .FRAC(FRAC)
                ) w_acc (
                    .clk (clk),
                    .rst (rst),
                    .en  (en),
                    .i_d (i_df[(i+1)*WIDTH-1:i*WIDTH]),
                    .i_x ( i_x[(j+1)*WIDTH-1:j*WIDTH]),
                    .o   (o_wf[(2*i+j+1)*WIDTH-1:(2*i+j)*WIDTH])
                );
        end
    end

    for (i = 0; i < N_OUT; i = i + 1)
    begin:wo
        for (j = 0; j < N_IN; j = j + 1)
        begin:x
            wght_acc #(
                    .WIDTH(WIDTH),
                    .FRAC(FRAC)
                ) w_acc (
                    .clk (clk),
                    .rst (rst),
                    .en  (en),
                    .i_d (i_do[(i+1)*WIDTH-1:i*WIDTH]),
                    .i_x ( i_x[(j+1)*WIDTH-1:j*WIDTH]),
                    .o   (o_wo[(2*i+j+1)*WIDTH-1:(2*i+j)*WIDTH])
                );
        end
    end
endgenerate




/////////////////////
// Combining Outputs

endmodule