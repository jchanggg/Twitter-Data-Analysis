//-----------------------------------------------------------------------------------------------
//ALU
//inputs the ain and a load, outputs in based on load
//Inputs:
//  ain: 16 bit input value in binary
//  clk: outputs on every rising edge of the clk
//  load: 1 bit input in binary representing an arthematic operation
//Output: out: 16 bit input value in binary result based off load, if load is 1
// then output in if load is 0 then output is the previous value, 
//          
//
//-----------------------------------------------------------------------------------------------
module plregister (in, clk, load, out);
  input[15:0] in;
  input clk;
  input[0:0] load;
  output[15:0] out;
  
  reg[15:0] out;
  wire [15:0] what;
  wire [15:0] connect;
  
  //run through MUX
  assign what = out;
  multiplex #(16) MUX(load, in, what, connect);
 
 //previous state 
  always @(posedge clk)begin
    out = connect;
  end
endmodule