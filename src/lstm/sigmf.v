//Sigmoid function approach using partial linearization
//with 3 gradient value 0,1/4, and 1/8

module sigmf( i,o);

// parameters
parameter WIDTH = 32;

// input ports
input [WIDTH-1:0] i;

// output ports
output[WIDTH-1:0] o;

  wire [WIDTH-1:0] outmux0, outmux1, outmux2, outmux3;
  wire [WIDTH-1:0] result;
  wire slc0, slc1, slc4; //slc12=slc1 ; slc3 = slc0
  
  assign eight_input = i[WIDTH-1] ? {2'b111, i[WIDTH-1:3]} : {2'b000, i[WIDTH-1:3]};
  assign quarter_input = i[WIDTH-1] ? {2'b11, i[WIDTH-1:2]} : {2'b00, i[WIDTH-1:2]};

  //Linear region
  //mux0 : Constant selector  y1 = 0.375 or y3 = 0.625
  assign outmux0 = slc0 ? 32'h00600000 : 32'h00A00000;
  //mux1 : Constant selector outmux1 = c (outmux0 or 0.5)
  assign outmux1 = slc1 ? outmux0 : 32'h00800000;
  //mux2 : Gradien selector mx (x/8) or (x/4) 
  assign outmux2 = slc1 ? eight_input : quarter_input;
  //adder to calculate output function
  assign result = outmux2 + outmux1; //mx + c
  
  //Saturation
  //mux3 : Saturation selector (0 or 0.999(approximately 1))
  assign outmux3 = slc0 ? 32'h0 : 32'h00FD7A3;
  //mux4 : Output selector
  assign o = slc4 ? outmux3 : result;
  
  //Select wire assignment
  assign slc0 = i[WIDTH-1];                           // slc0 : 1 if negative
  assign slc1 = (i<32'hFF000000)&&(i>32'hFF000000); // slc1 = (in<-1.0)||(in>1.0)
  assign slc4 = (i<32'h03000000)&&(i>32'h03000000); // slc4 = (in<-3.0)||(in>3.0)
endmodule