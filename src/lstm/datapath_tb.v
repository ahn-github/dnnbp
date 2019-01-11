module datapath_tb();

// parameters
parameter WIDTH = 32;
parameter TIMESTEP = 7;
parameter LAYR1_INPUT = 2;
parameter LAYR1_CELL = 2;
parameter LAYR2_CELL = 1;

// common ports
reg clk, rst;

// control ports
reg [WIDTH-1:0] addr_x1;
reg [8:0] rd_addr_x2, wr_addr_x2;

reg wr_h1;
reg [8:0] rd_addr_h1;
reg [8:0] wr_addr_h1;
reg wr_c1;
reg [8:0] rd_addr_c1;
reg [8:0] wr_addr_c1;
reg wr_layr1;

reg wr_x2;
reg wr_h2;
reg [8:0] rd_addr_h2;
reg [8:0] wr_addr_h2;
reg wr_c2;
reg [8:0] rd_addr_c2;
reg [8:0] wr_addr_c2;
reg wr_layr2;

datapath #(
		.WIDTH(WIDTH),
		.TIMESTEP(TIMESTEP),
		.LAYR1_INPUT(LAYR1_INPUT),
		.LAYR1_CELL(LAYR1_CELL),
		.LAYR2_CELL(LAYR2_CELL)
	) inst_datapath (
		.clk        (clk),
		.rst        (rst),
		.wr_h1      (wr_h1),
		.wr_h2      (wr_h2),
		.wr_c1      (wr_c1),
		.wr_c2      (wr_c2),
		.wr_x2      (wr_x2),
		.wr_layr1   (wr_layr1),
		.wr_layr2   (wr_layr2),
		.addr_x1    (addr_x1),
		.rd_addr_x2 (rd_addr_x2),
		.wr_addr_x2 (wr_addr_x2),
		.rd_addr_h1 (rd_addr_h1),
		.rd_addr_h2 (rd_addr_h2),
		.rd_addr_c1 (rd_addr_c1),
		.rd_addr_c2 (rd_addr_c2),
		.wr_addr_h1 (wr_addr_h1),
		.wr_addr_h2 (wr_addr_h2),
		.wr_addr_c1 (wr_addr_c1),
		.wr_addr_c2 (wr_addr_c2)
	);

initial
begin
	clk = 1;
	rst <= 1;
	addr_x1 <= 32'd0; 
	wr_h1 <= 1;
	rd_addr_h1 <= 9'd0; wr_addr_h1 <= 9'd2;
	wr_c1 <= 1;
	rd_addr_c1 <= 9'd0; wr_addr_c1 <= 9'd2;
	wr_layr1 <= 0;
	wr_x2 <= 1;
	rd_addr_x2 <= 9'd0; wr_addr_x2 <= 9'd0;
	wr_h2 <= 1; 
	rd_addr_h2 <= 9'd0; wr_addr_h2 <= 9'd1;
	wr_c2 <= 1;
	rd_addr_c2 <= 9'd0; wr_addr_c2 <= 9'd1;
	wr_layr2 <= 0;
	#100;
	rst <= 0;
	#100;
	wr_addr_x2 <= 9'd0;
	wr_addr_h1 <= 9'd2;
	wr_addr_c1 <= 9'd2;
	#100;
	wr_addr_x2 <= 9'd1;
	wr_addr_h1 <= 9'd3;
	wr_addr_c1 <= 9'd3;
	#100;

	addr_x1 <= 9'd2;
	wr_addr_x2 <= 9'd2;
	wr_addr_h1 <= 9'd4;
	wr_addr_c1 <= 9'd4;
	rd_addr_x2 <= 9'd0;
	rd_addr_h1 <= 9'd2;
	rd_addr_c1 <= 9'd2;
	wr_addr_h2 <= 9'd1;
	wr_addr_c2 <= 9'd1;
	rd_addr_h2 <= 9'd0;
	rd_addr_c2 <= 9'd0;
	#100;
	wr_addr_x2 <= 9'd3;
	wr_addr_h1 <= 9'd5;
	wr_addr_c1 <= 9'd5;
	wr_addr_h2 <= 9'd2;
	wr_addr_c2 <= 9'd2;
	#100;

	repeat(6)
	begin
		addr_x1 <= addr_x1 + 9'd2;
		wr_addr_x2 <= wr_addr_x2 + 9'd1;
		wr_addr_h1 <= wr_addr_h1 + 9'd1;
		wr_addr_c1 <= wr_addr_c1 + 9'd1;
		rd_addr_x2 <= rd_addr_x2 + 9'd2;
		rd_addr_h1 <= rd_addr_h1 + 9'd2;
		rd_addr_c1 <= rd_addr_c1 + 9'd2;
		wr_addr_h2 <= wr_addr_h2 + 9'd1;
		wr_addr_c2 <= wr_addr_c2 + 9'd1;
		rd_addr_h2 <= rd_addr_h2 + 9'd1;
		rd_addr_c2 <= rd_addr_c2 + 9'd1;
		#100;
		wr_addr_x2 <= wr_addr_x2 + 9'd1;
		wr_addr_h1 <= wr_addr_h1 + 9'd1;
		wr_addr_c1 <= wr_addr_c1 + 9'd1;
		#100;
	end
end

always
begin
	#50;
	clk = !clk;
end

endmodule