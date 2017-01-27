//-----------------------------------------------------------------------------------------------
//Mulitplexer
//inputs the ain and bin values, and a select, outputs ain or bin based on sel
//Inputs:
//  ain: 16 bit input value in binary
//  bin: 16 bit input value in binary
//  sel: 1 bit input in binary representing an arthematic operation
//Output: out: 16 bit input value in binary result based off sel
//          
//
//-----------------------------------------------------------------------------------------------
module multiplex (sel, ain, bin, out);
  parameter n = 8;
  input[n-1:0] ain, bin;
  input sel;
  output[n-1:0] out;
  
  //output based on select
  assign out = sel ? ain : bin;
  
endmodule