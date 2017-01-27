//-----------------------------------------------------------------------------------------------
//Mulitplexer
//inputs the ain and bin values, and a select, outputs ain or bin based on sel
//Inputs:
//  ain: 16 bit input value in binary
//  bin: 16 bit input value in binary
//  sel: 1 bit input in binary representing an arthematic operation
//  Output: out: 16 bit input value in binary result based off sel
//          
//
//-----------------------------------------------------------------------------------------------
module writebackMUX (ain, bin, cin, din, vsel, out);
  input[15:0] ain, bin, cin, din;
  input[3:0] vsel;
  output[15:0] out;
  
  //output based on vsel
  assign out = ({16{vsel[3]}}&ain) |
		({16{vsel[2]}}&bin) |
		({16{vsel[1]}}&cin) |
		({16{vsel[0]}}&din);
endmodule



