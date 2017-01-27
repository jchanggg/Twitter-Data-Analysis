//-----------------------------------------------------------------------------------------------
//statusregister
//inputs the ain and load values, outputs 1 or 0 based on ain everytime the 
//rising edge of the clock changes
//Inputs:
//  ain: 1 bit input value in binary
//  
//  load: 1 bit input in binary representing an arthematic operation
//  clk: standard clock
//Output: out: 1 input value in binary result based off if ain is 1 then 1 if 
//ain is 0 then 0
//          
//
//-----------------------------------------------------------------------------------------------
module statusregister (in, clk, load, out);
  input[2:0] in;
  input clk;
  input load;
  output[2:0] out;
  
  reg [2:0] out;
  wire [2:0] preVal;
  wire [2:0] next;
 
 // run through multplexer 
  assign preVal = out;
  
  multiplex #(3) MUX(load, in, preVal, next);
  
 // output changes on rising edge of clk
  always @(posedge clk)begin
    out = next;
  end
endmodule
// module end