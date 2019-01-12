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
///////////////////////////////////////////////////////////////////////////////

module addr_x (clk, rst, count);   

// parameters
parameter WIDTH = 32;
parameter NUM = 3;
parameter NUM_ITERATIONS = 5;

// common ports 
input clk, rst;  
output [WIDTH-1:0] count;      
reg [WIDTH-1:0] count;         

always @(posedge clk or rst)  
begin   
  if (rst==1'b1) 
    count <= 0;
  else if (count > 359)
  	count <= 0;
  else
    count <= count +1;
end

endmodule
