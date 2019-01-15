////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : Tanh Function 
// File Name        : tanh.v
// Version          : 1.0
// Description      : perceptron-like module with tanh activation
//
////////////////////////////////////////////////////////////////////////////////

module tanh(i, o);

// parameters
parameter WIDTH = 32;

// input ports
input [WIDTH-1:0] i;

// output ports
output[WIDTH-1:0] o;


wire sel_0;
wire sel_1;
wire sel_sign;
wire sel_result;
wire [WIDTH-1:0] out_mux_coef_1;
wire [WIDTH-1:0] out_mux_const_1;
wire [WIDTH-1:0] out_mux_coef_2;
wire [WIDTH-1:0] out_mux_const_2;
wire [WIDTH-1:0] out_mux_region;
wire [WIDTH-1:0] out_add_sub;
wire [WIDTH-1:0] pos;
wire [WIDTH-1:0] quarter_input;
wire [WIDTH-1:0] half_input;


assign pos  = i[WIDTH-1] ? (~i + 1) : i; // choosing positive value
assign quarter_input = i[WIDTH-1] ? {2'b11, i[WIDTH-1:2]} : {2'b00, i[WIDTH-1:2]};
assign half_input = i[WIDTH-1] ? {1'b1, i[WIDTH-1:1]} : {1'b0, i[WIDTH-1:1]};

multiplexer #(.WIDTH(WIDTH)) mux_coef_1 (.i_a( quarter_input), .i_b(half_input), .sel(sel_0), .o(out_mux_coef_1));
multiplexer #(.WIDTH(WIDTH)) mux_const_1 (.i_a(32'h00800000), .i_b(32'h00400000), .sel(sel_0), .o(out_mux_const_1));
multiplexer #(.WIDTH(WIDTH)) mux_coef_2 (.i_a(out_mux_coef_1), .i_b(i), .sel(sel_1), .o(out_mux_coef_2));
multiplexer #(.WIDTH(WIDTH)) mux_const_2 (.i_a(out_mux_const_1), .i_b(0), .sel(sel_1), .o(out_mux_const_2));
addsub #(.WIDTH(WIDTH)) inst_addsub (.i_a(out_mux_coef_2), .i_b(out_mux_const_2), .sel(sel_sign), .o(out_add_sub));
multiplexer #(.WIDTH(WIDTH)) mux_region (.i_a(32'hFF000000), .i_b(32'h01000000), .sel(sel_sign), .o(out_mux_region));
multiplexer #(.WIDTH(WIDTH)) mux_result (.i_a(out_mux_region), .i_b(out_add_sub), .sel(sel_result), .o(o));

assign sel_0 = pos<32'h01000000;
assign sel_1 = pos<32'h00800000;
assign sel_sign = ~i[WIDTH-1];
assign sel_result = pos<32'h02000000;



endmodule