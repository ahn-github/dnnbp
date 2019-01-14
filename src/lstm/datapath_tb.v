module datapath_tb();

// parameters
parameter WIDTH = 32;
parameter TIMESTEP = 7;
parameter LAYR1_INPUT = 53;
parameter LAYR1_CELL = 53;
parameter LAYR2_CELL = 8;

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
reg [8:0] rd_addr_layr1;
reg [8:0] wr_addr_layr1;

reg wr_x2;
reg wr_h2;
reg [8:0] rd_addr_h2;
reg [8:0] wr_addr_h2;
reg wr_c2;
reg [8:0] rd_addr_c2;
reg [8:0] wr_addr_c2;
reg wr_layr2;
reg [8:0] rd_addr_layr2;
reg [8:0] wr_addr_layr2;

	datapath #(
			.WIDTH(WIDTH),
			.TIMESTEP(TIMESTEP),
			.LAYR1_INPUT(LAYR1_INPUT),
			.LAYR1_CELL(LAYR1_CELL),
			.LAYR2_CELL(LAYR2_CELL)
		) inst_datapath (
			.clk           (clk),
			.rst           (rst),
			.wr_h1         (wr_h1),
			.wr_h2         (wr_h2),
			.wr_c1         (wr_c1),
			.wr_c2         (wr_c2),
			.wr_x2         (wr_x2),
			.addr_x1       (addr_x1),
			.rd_addr_x2    (rd_addr_x2),
			.wr_addr_x2    (wr_addr_x2),
			.wr_layr1      (wr_layr1),
			.rd_addr_layr1 (rd_addr_layr1),
			.wr_addr_layr1 (wr_addr_layr1),
			.wr_layr2      (wr_layr2),
			.rd_addr_layr2 (rd_addr_layr2),
			.wr_addr_layr2 (wr_addr_layr2),
			.rd_addr_h1    (rd_addr_h1),
			.rd_addr_h2    (rd_addr_h2),
			.rd_addr_c1    (rd_addr_c1),
			.rd_addr_c2    (rd_addr_c2),
			.wr_addr_h1    (wr_addr_h1),
			.wr_addr_h2    (wr_addr_h2),
			.wr_addr_c1    (wr_addr_c1),
			.wr_addr_c2    (wr_addr_c2)
		);

initial
begin
	clk = 1;
	rst <= 1;
	addr_x1 <= 32'd0; 
	wr_h1 <= 1;
	rd_addr_h1 <= 9'd0; wr_addr_h1 <= 9'd53;
	wr_c1 <= 1;
	rd_addr_c1 <= 9'd0; wr_addr_c1 <= 9'd53;
	wr_layr1 <= 0;
	rd_addr_layr1 <= 9'd0; wr_addr_layr1 <= 9'd0;
	wr_x2 <= 1;
	rd_addr_x2 <= 9'd0; wr_addr_x2 <= 9'd0;
	wr_h2 <= 1; 
	rd_addr_h2 <= 9'd0; wr_addr_h2 <= 9'd8;
	wr_c2 <= 1;
	rd_addr_c2 <= 9'd0; wr_addr_c2 <= 9'd8;
	wr_layr2 <= 0;
	rd_addr_layr2 <= 9'd0; wr_addr_layr2 <= 9'd0;
	#100;
	
	rst <= 0;
	#100;
	
	repeat(52)
	begin
		wr_addr_x2 <= wr_addr_x2 + 9'd1;
		wr_addr_h1 <= wr_addr_h1 + 9'd1;
		wr_addr_c1 <= wr_addr_c1 + 9'd1;
		rd_addr_layr1 <= rd_addr_layr1 + 9'd1;
		rd_addr_layr2 <= 9'd0;
		#100;
	end

	addr_x1 <= 9'd53;	
	rd_addr_h1 <= 9'd53;
	rd_addr_c1 <= 9'd53;
	rd_addr_x2 <= 9'd0;
	rd_addr_h2 <= 9'd0;
	rd_addr_c2 <= 9'd0;

	wr_addr_h2 <= 9'd8;
	wr_addr_c2 <= 9'd8;

	wr_addr_x2 <= 9'd53;
	wr_addr_h1 <= 9'd106;
	wr_addr_c1 <= 9'd106;
	rd_addr_layr1 <= 9'd0;
	rd_addr_layr2 <= 9'd0;
	#100;

	repeat(45)
	begin
		wr_addr_x2 <= wr_addr_x2 + 9'd1;
		wr_addr_h1 <= wr_addr_h1 + 9'd1;
		wr_addr_c1 <= wr_addr_c1 + 9'd1;
		rd_addr_layr1 <= rd_addr_layr1 + 9'd1;
		rd_addr_layr2 <= 9'd0;
		#100;
	end

	repeat(7)
	begin
		wr_addr_x2 <= wr_addr_x2 + 9'd1;
		wr_addr_h1 <= wr_addr_h1 + 9'd1;
		wr_addr_c1 <= wr_addr_c1 + 9'd1;
		rd_addr_layr1 <= rd_addr_layr1 + 9'd1;

		wr_addr_h2 <= wr_addr_h2 + 9'd1;
		wr_addr_c2 <= wr_addr_c2 + 9'd1;
		rd_addr_layr2 <= rd_addr_layr2 + 9'd1;
		#100;
	end

	repeat(6)
	begin
		addr_x1 <= addr_x1 + 9'd53;
		rd_addr_h1 <= rd_addr_h1 + 9'd53;
		rd_addr_c1 <= rd_addr_c1 + 9'd53;
		rd_addr_x2 <= rd_addr_x2 + 9'd53;
		rd_addr_h2 <= rd_addr_h2 + 9'd8;
		rd_addr_c2 <= rd_addr_c2 + 9'd8;
		
		wr_addr_h2 <= wr_addr_h2 + 9'd1;
		wr_addr_c2 <= wr_addr_c2 + 9'd1;
		
		wr_addr_x2 <= wr_addr_x2 + 9'd1;
		wr_addr_h1 <= wr_addr_h1 + 9'd1;
		wr_addr_c1 <= wr_addr_c1 + 9'd1;
		rd_addr_layr1 <= 9'd0;
		rd_addr_layr2 <= 9'd0;
		#100;

		repeat(45)
		begin
			wr_addr_x2 <= wr_addr_x2 + 9'd1;
			wr_addr_h1 <= wr_addr_h1 + 9'd1;
			wr_addr_c1 <= wr_addr_c1 + 9'd1;
			rd_addr_layr1 <= rd_addr_layr1 + 9'd1;
			rd_addr_layr2 <= 9'd0;
			#100;
		end

		repeat(7)
		begin
			wr_addr_x2 <= wr_addr_x2 + 9'd1;
			wr_addr_h1 <= wr_addr_h1 + 9'd1;
			wr_addr_c1 <= wr_addr_c1 + 9'd1;
			rd_addr_layr1 <= rd_addr_layr1 + 9'd1;

			wr_addr_h2 <= wr_addr_h2 + 9'd1;
			wr_addr_c2 <= wr_addr_c2 + 9'd1;
			rd_addr_layr2 <= rd_addr_layr2 + 9'd1;
			#100;
		end
	end
end

always
begin
	#50;
	clk = !clk;
end

endmodule