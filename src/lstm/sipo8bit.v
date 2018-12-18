module sipo8bit ( din, clk, reset, dout1, dout2, dout3, dout4);

input [7:0] din;
input clk;
input reset;
output [7:0] dout1, dout2, dout3, dout4;

reg [7:0] reg1, reg2, reg3, reg4;

always @ (posedge (clk)) begin 
 if (reset)
  begin
  reg1 <= 8'd0;
  reg2 <= 8'd0;
  reg3 <= 8'd0;
  reg4 <= 8'd0;
  end
 else begin
  reg1 <= din;
  reg2 <= reg1;
  reg3 <= reg2;
  reg4 <= reg3;
 end
end

assign dout1 = reg1;
assign dout2 = reg2;
assign dout3 = reg3;
assign dout4 = reg4;
 

endmodule
