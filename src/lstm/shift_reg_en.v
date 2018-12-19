////////////////////////////////////////////////////////////////////////////////
//
// By : Joshua, Teresia Savera, Yashael Faith
// 
// Module Name      : Long Short Term Memory
// File Name        : lstm.v
// Version          : 2.0
// Description      : top level of long short term memory forward propagation
//                    
//					  
////////////////////////////////////////////////////////////////////////////////

module shift_reg_en (clk, rst, en, i, o);

parameter NUM_ITERATIONS = 68;
parameter WIDTH = 32;

// common ports
input clk, rst;

// control ports
input en;

// input ports
input signed [WIDTH-1:0] i;

// output ports
output signed [NUM_ITERATIONS*WIDTH-1:0] o;

// register
reg signed [NUM_ITERATIONS*WIDTH-1:0] reg_shift;



always @(posedge clk or rst)
begin
	if (rst)
  		begin
	  		reg_shift= {WIDTH{1'b0}};
			
		end
	else if (en)
		begin
			reg_shift= {i, reg_shift[(NUM_ITERATIONS)*WIDTH-1:WIDTH]};
	 		
		end

end

assign o = reg_shift;

endmodule
