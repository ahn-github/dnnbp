////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : Backpropagation module
// File Name        : bp.v
// Version          : 1.0
// Description      : LSTM Backpropagation calculation include:
//                    calculation of delta, dweight, dbias, and cost
//
////////////////////////////////////////////////////////////////////////////////

module bp (i_x, i_t, i_h, i_c, i_a, i_i, i_f, i_o, i_wa, i_wo, i_wi, i_wf,
           o_b, o_wa, o_wi, o_wf, o_wo);

// parameters
parameter WIDTH = 32;
parameter FRAC = 24;
parameter TIMESTEP = 4;
parameter NUM = 2; // Number of Inputs
parameter NUM_LSTM = 1;

// common ports

// control ports

// input ports
input signed [TIMESTEP*WIDTH-1:0] i_t, i_h, i_c, i_a, i_i, i_f, i_o;
input signed [TIMESTEP*(NUM+NUM_LSTM)*WIDTH-1:0] i_x;
input signed [(NUM+NUM_LSTM)*WIDTH-1:0] i_wa, i_wo, i_wi, i_wf;

// output ports
output signed [4*WIDTH-1:0] o_b;
output signed [(NUM+NUM_LSTM)*WIDTH-1:0] o_wa;
output signed [(NUM+NUM_LSTM)*WIDTH-1:0] o_wi;
output signed [(NUM+NUM_LSTM)*WIDTH-1:0] o_wf;
output signed [(NUM+NUM_LSTM)*WIDTH-1:0] o_wo;

// registers

// wires
wire signed [TIMESTEP*WIDTH-1:0] d_c_next_pass, d_f_prev_pass, d_loss;
wire signed [TIMESTEP*WIDTH-1:0] d_d_h_prev_pass, d_d_c_prev_pass, d_d_h_next_pass, d_d_c_next_pass;

// d_gates structure:
// [   delta_tn  |------|   delta_t0  ]
// [ do|df|di|da |------| do|df|di|da ]
wire signed [TIMESTEP*4*WIDTH-1:0] d_gates;

// Signal to pass on to next delta module
assign d_c_next_pass = {i_c[(TIMESTEP-1)*WIDTH-1:0], {WIDTH{1'b0}}};
assign d_f_prev_pass = {{WIDTH{1'b0}}, i_f[TIMESTEP*WIDTH-1:WIDTH]};

assign d_d_h_prev_pass[TIMESTEP*WIDTH-1:(TIMESTEP-1)*WIDTH] = {WIDTH{1'b0}};
assign d_d_c_prev_pass[TIMESTEP*WIDTH-1:(TIMESTEP-1)*WIDTH] = {WIDTH{1'b0}};

assign d_d_h_prev_pass[(TIMESTEP-1)*WIDTH-1:0] = d_d_h_next_pass[TIMESTEP*WIDTH-1:WIDTH];
assign d_d_c_prev_pass[(TIMESTEP-1)*WIDTH-1:0] = d_d_c_next_pass[TIMESTEP*WIDTH-1:WIDTH];

generate
    genvar i;
    genvar j;
    for (i = TIMESTEP; i > 0; i = i - 1)
    begin:timestep

        delta #(
            .WIDTH(WIDTH),
            .FRAC(FRAC),
            .NUM(NUM),
            .NUM_LSTM(NUM_LSTM)
        ) d (
            .i_d_h_prev (d_d_h_prev_pass[i*WIDTH-1:(i-1)*WIDTH]),
            .i_h        (i_h            [i*WIDTH-1:(i-1)*WIDTH]),
            .i_d_c_prev (d_d_c_prev_pass[i*WIDTH-1:(i-1)*WIDTH]),
            .i_c_next   (d_c_next_pass  [i*WIDTH-1:(i-1)*WIDTH]),
            .i_c        (i_c            [i*WIDTH-1:(i-1)*WIDTH]),
            .i_t        (i_t            [i*WIDTH-1:(i-1)*WIDTH]),
            .i_a        (i_a            [i*WIDTH-1:(i-1)*WIDTH]),
            .i_i        (i_i            [i*WIDTH-1:(i-1)*WIDTH]),
            .i_f        (i_f            [i*WIDTH-1:(i-1)*WIDTH]),
            .i_o        (i_o            [i*WIDTH-1:(i-1)*WIDTH]),
            .i_f_prev   (d_f_prev_pass  [i*WIDTH-1:(i-1)*WIDTH]),
            .w_a        (i_wa           [(NUM+NUM_LSTM)*WIDTH-1:0]),
            .w_o        (i_wo           [(NUM+NUM_LSTM)*WIDTH-1:0]),
            .w_i        (i_wi           [(NUM+NUM_LSTM)*WIDTH-1:0]),
            .w_f        (i_wf           [(NUM+NUM_LSTM)*WIDTH-1:0]),
            .o_d_tot    (d_loss         [i*WIDTH-1:(i-1)*WIDTH]),
            .o_dgates   (d_gates        [4*i*WIDTH-1:4*(i-1)*WIDTH]),
            .o_d_x_now  (),
            .o_d_h_next (d_d_h_next_pass[i*WIDTH-1:(i-1)*WIDTH]),
            .o_d_c_next (d_d_c_next_pass[i*WIDTH-1:(i-1)*WIDTH])
        );
    end

    // Calculate multiplication of δa, δi, δf, δo with inputs
    wire signed [TIMESTEP*(NUM+NUM_LSTM)*WIDTH-1:0] o_mult_a, o_mult_i, o_mult_f, o_mult_o;

    // i stands for number of inputs
    for (i = 0; i < (NUM+NUM_LSTM); i = i + 1)
    begin:x
        // j stands for number of timesteps
        for (j = 0; j < TIMESTEP; j = j + 1)
        begin:mult
            mult_2in #(
                .WIDTH(WIDTH),
                .FRAC(FRAC)
            ) m_a (
                .i_a( d_gates   [ (4*j+1)*WIDTH-1 : (4*j+0)*WIDTH ] ),
                .i_b( i_x       [ (((NUM+NUM_LSTM)*j)+i+1)*WIDTH-1 : (((NUM+NUM_LSTM)*j)+i)*WIDTH] ),
                .o( o_mult_a    [ ((TIMESTEP*i)+j+1)*WIDTH-1 : ((TIMESTEP*i)+j)*WIDTH] )
            );
            mult_2in #(
                .WIDTH(WIDTH),
                .FRAC(FRAC)
            ) m_i (
                .i_a( d_gates   [ (4*j+2)*WIDTH-1 : (4*j+1)*WIDTH ] ),
                .i_b( i_x       [ (((NUM+NUM_LSTM)*j)+i+1)*WIDTH-1 : (((NUM+NUM_LSTM)*j)+i)*WIDTH] ),
                .o( o_mult_i    [ ((TIMESTEP*i)+j+1)*WIDTH-1 : ((TIMESTEP*i)+j)*WIDTH] )
            );
            mult_2in #(
                .WIDTH(WIDTH),
                .FRAC(FRAC)
            ) m_f (
                .i_a( d_gates   [ (4*j+3)*WIDTH-1 : (4*j+2)*WIDTH ] ),
                .i_b( i_x       [ (((NUM+NUM_LSTM)*j)+i+1)*WIDTH-1 : (((NUM+NUM_LSTM)*j)+i)*WIDTH] ),
                .o( o_mult_f    [ ((TIMESTEP*i)+j+1)*WIDTH-1 : ((TIMESTEP*i)+j)*WIDTH] )
            );
            mult_2in #(
                .WIDTH(WIDTH),
                .FRAC(FRAC)
            ) m_o (
                .i_a( d_gates   [ (4*j+4)*WIDTH-1 : (4*j+3)*WIDTH ] ),
                .i_b( i_x       [ (((NUM+NUM_LSTM)*j)+i+1)*WIDTH-1 : (((NUM+NUM_LSTM)*j)+i)*WIDTH] ),
                .o( o_mult_o    [ ((TIMESTEP*i)+j+1)*WIDTH-1 : ((TIMESTEP*i)+j)*WIDTH] )
            );
        end
    end

    // Adding signals for W
    for (i = 0; i < NUM; i = i + 1)
    begin:weight
        adder #(
            .NUM(TIMESTEP),
            .WIDTH(WIDTH)
        ) add_a (
            .i( o_mult_a    [ (i+1)*TIMESTEP*WIDTH-1 : i*TIMESTEP*WIDTH ] ),
            .o( o_wa        [ (i+1)*WIDTH-1 : i*WIDTH ] )
        );
        adder #(
            .NUM(TIMESTEP),
            .WIDTH(WIDTH)
        ) add_i (
            .i( o_mult_i    [ (i+1)*TIMESTEP*WIDTH-1 : i*TIMESTEP*WIDTH ] ),
            .o( o_wi        [ (i+1)*WIDTH-1 : i*WIDTH ] )
        );
        adder #(
            .NUM(TIMESTEP),
            .WIDTH(WIDTH)
        ) add_f (
            .i( o_mult_f    [ (i+1)*TIMESTEP*WIDTH-1 : i*TIMESTEP*WIDTH ] ),
            .o( o_wf        [ (i+1)*WIDTH-1 : i*WIDTH ] )
        );
        adder #(
            .NUM(TIMESTEP),
            .WIDTH(WIDTH)
        ) add_o (
            .i( o_mult_o    [ (i+1)*TIMESTEP*WIDTH-1 : i*TIMESTEP*WIDTH ] ),
            .o( o_wo        [ (i+1)*WIDTH-1 : i*WIDTH ] )
        );
    end

    // Adding signals for U
    for (i = NUM; i < NUM+NUM_LSTM; i = i + 1)
    begin:U
        adder #(
            .NUM(TIMESTEP),
            .WIDTH(WIDTH)
        ) add_a (
            .i( o_mult_a    [ ((i+1)*TIMESTEP)*WIDTH-1 : i*TIMESTEP*WIDTH ] ),
            .o( o_wa        [ (i+1)*WIDTH-1 : i*WIDTH ] )
        );
        adder #(
            .NUM(TIMESTEP),
            .WIDTH(WIDTH)
        ) add_i (
            .i( o_mult_i    [ ((i+1)*TIMESTEP)*WIDTH-1 : i*TIMESTEP*WIDTH ] ),
            .o( o_wi        [ (i+1)*WIDTH-1 : i*WIDTH ] )
        );
        adder #(
            .NUM(TIMESTEP),
            .WIDTH(WIDTH)
        ) add_f (
            .i( o_mult_f    [ ((i+1)*TIMESTEP)*WIDTH-1 : i*TIMESTEP*WIDTH ] ),
            .o( o_wf        [ (i+1)*WIDTH-1 : i*WIDTH ] )
        );
        adder #(
            .NUM(TIMESTEP),
            .WIDTH(WIDTH)
        ) add_o (
            .i( o_mult_o    [ ((i+1)*TIMESTEP)*WIDTH-1 : i*TIMESTEP*WIDTH ] ),
            .o( o_wo        [ (i+1)*WIDTH-1 : i*WIDTH ] )
        );
    end

    // Calculate B
    wire signed [TIMESTEP*WIDTH-1:0] da, di, df, do;

    for (i = 0; i < TIMESTEP; i = i + 1)
    begin:bias
        assign da[(i+1)*WIDTH-1:i*WIDTH] = d_gates[ (4*i+1)*WIDTH-1 : (4*i+0)*WIDTH ];
        assign di[(i+1)*WIDTH-1:i*WIDTH] = d_gates[ (4*i+2)*WIDTH-1 : (4*i+1)*WIDTH ];
        assign df[(i+1)*WIDTH-1:i*WIDTH] = d_gates[ (4*i+3)*WIDTH-1 : (4*i+2)*WIDTH ];
        assign do[(i+1)*WIDTH-1:i*WIDTH] = d_gates[ (4*i+4)*WIDTH-1 : (4*i+3)*WIDTH ];
    end

    adder #(.NUM(TIMESTEP),.WIDTH(WIDTH)) ba (.i( da ), .o( o_b[1*WIDTH-1:0*WIDTH] ));
    adder #(.NUM(TIMESTEP),.WIDTH(WIDTH)) bi (.i( di ), .o( o_b[2*WIDTH-1:1*WIDTH] ));
    adder #(.NUM(TIMESTEP),.WIDTH(WIDTH)) bf (.i( df ), .o( o_b[3*WIDTH-1:2*WIDTH] ));
    adder #(.NUM(TIMESTEP),.WIDTH(WIDTH)) bo (.i( do ), .o( o_b[4*WIDTH-1:3*WIDTH] ));

endgenerate

endmodule