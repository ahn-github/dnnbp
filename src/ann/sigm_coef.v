////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name		: Sigmoid Coefficient Selector Module
// File Name		: sigm_coef.v
// Version			: 1.0
// Description		: Outputs taylor series coefficients by selector
//                    Variable format cX_YZ
//                    X : coefficient  number
//                    YZ: segment, input between Y and Z (def: default)
//
////////////////////////////////////////////////////////////////////////////////

module sigm_coef (i_sel, o_coef0, o_coef1, o_coef2);

// parameters
parameter WIDTH = 32;

// parameter c0_01 = 32'b0000_0000_1000_0000_0000_0000_0000_0000 ; 
parameter c0_01 = 32'b0000_0000_1001_1111_0011_1011_0110_0100 ; 
parameter c0_12 = 32'b0000_0000_1101_0001_0100_0000_0000_0000 ;
parameter c0_23 = 32'b0000_0000_1110_1100_1000_0000_0000_0000 ;
parameter c0_34 = 32'b0000_0000_1111_1000_0100_0000_0000_0000 ;
parameter c0_46 = 32'b0000_0000_1111_1110_0100_0000_0000_0000 ;
parameter c0_def = 32'b0000_0001_0000_0000_0000_0000_0000_0000 ;

// parameter c1_01 = 32'b0000_0000_0100_0000_0000_0000_0000_0000 ;
parameter c1_01 = 32'b0000_0000_0011_1100_0010_1000_1111_0101 ;
parameter c1_12 = 32'b0000_0000_0010_0110_0000_0000_0000_0000 ;
parameter c1_23 = 32'b0000_0000_0001_0001_1100_0000_0000_0000 ;
parameter c1_34 = 32'b0000_0000_0000_0111_0100_0000_0000_0000 ;
parameter c1_46 = 32'b0000_0000_0000_0001_1000_0000_0000_0000 ;
parameter c1_def = 32'b0000_0000_0000_0000_0000_0000_0000_0000 ;

// parameter c2_01 = 32'b0000_0000_0000_0000_0000_0000_0000_0000 ;
parameter c2_01 = 32'b1111_1111_1111_0001_0100_0111_1010_1111 ;
parameter c2_12 = 32'b1111_1111_1111_0100_0000_0000_0000_0000 ;
parameter c2_23 = 32'b1111_1111_1111_1000_1000_0000_0000_0000 ;
parameter c2_34 = 32'b1111_1111_1111_1100_1100_0000_0000_0000 ;
parameter c2_46 = 32'b1111_1111_1111_1111_0100_0000_0000_0000 ;
parameter c2_def = 32'b0000_0000_0000_0000_0000_0000_0000_0000 ;

// input ports
input [2:0] i_sel;

// output ports
output [WIDTH-1:0] o_coef0, o_coef1, o_coef2;

// registers
reg [WIDTH-1:0] reg_coef0, reg_coef1, reg_coef2;

// gives coefficient based on input
always@(i_sel)
begin
  case (i_sel)
  0 : 
  begin 
    reg_coef0 = c0_01; 
    reg_coef1 = c1_01; 
    reg_coef2 = c2_01; 
  end 
	1 : 
	begin 
	 reg_coef0 = c0_12; 
	 reg_coef1 = c1_12; 
	 reg_coef2 = c2_12; 
	end
	2 : 
	begin 
	 reg_coef0 = c0_23; 
	 reg_coef1 = c1_23; 
	 reg_coef2 = c2_23;
	end
	3 : 
	begin
	 reg_coef0 = c0_34; 
	 reg_coef1 = c1_34; 
	 reg_coef2 = c2_34; 
	end
	4 : 
	begin 
	 reg_coef0 = c0_46; 
	 reg_coef1 = c1_46; 
	 reg_coef2 = c2_46;
	end
	default : begin reg_coef0 = c0_def; reg_coef1 = c1_def; reg_coef2 = c2_def; end
  endcase
end

assign o_coef0 = reg_coef0;
assign o_coef1 = reg_coef1;
assign o_coef2 = reg_coef2;

endmodule