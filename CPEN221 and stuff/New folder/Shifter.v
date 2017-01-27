//-----------------------------------------------------------------------------------------------
//ALU
//inputs in, and a value representing operation, shifts the value according to the operation,
//and outputs the result
//Inputs:
//  in: 16 bit input value in binary
//  operation: 2 bit input in binary representing a shifting operation
//Output: out: 16 bit input value in binary result
//          
//
//-----------------------------------------------------------------------------------------------
module Shifter (in, operation, out);
// inputs and outputs of the shifter
  input [15:0] in;
  input [1:0] operation;
  output [15:0] out;
  
  
  reg [15:0] out;
  
  //output based on case
  always@(*)begin
    case(operation)
      0: out = in;
      1: out = in << 1;
      2: out = in >> 1;
      3: out = {in[0], in[15:1]};
      //no default statement should be okay
    endcase
  end
endmodule
//module end