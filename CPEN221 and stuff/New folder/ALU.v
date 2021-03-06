//-----------------------------------------------------------------------------------------------
//ALU
//inputs the A and B values, and a value representing operation, performs some arthematic
//and outputs the result, if the result is zero, cout is 1 else it is zero
//Inputs:
//  A: 16 bit input value in binary
//  B: 16 bit input value in binary
//  operation: 2 bit input in binary representing an arthematic operation
//Output: out: 16 bit input value in binary result
//          cout: if result is zero then output 1 else output 0
//
//-----------------------------------------------------------------------------------------------
module ALU (A, B, operation, out, cout);
  parameter k = 16;
//inputs 
  input [k-1:0] A,B;
  input [1:0] operation;
  output [k-1:0] out;
  output[2:0] cout;
  
  
  reg [k-1:0] out;
  //reg [2:0] cout;
  wire [2:0] cout;
  
  wire [k-1:0] A;
  wire [k-1:0] B;
  wire [1:0] operation;

  wire ovf;
  wire[k-1:0] sum;
  AddSub #(k) ADDSUB (A,B,operation[0],sum,ovf);

  always@(*)begin
    casex(operation)
      2'b0x: out = sum;
      2'b10: out = A&B;
      2'b11: out = ~A;
      
      //no default statement should be okay
    endcase
  end
  
/*
  //output based on operation
  always@(*)begin
    case(operation)
      2'b00: out = A+B;
      2'b01: out = A-B;
      2'b10: out = A&B;
      2'b11: out = A;
      
      //no default statement should be okay
    endcase
  end
  */
  
  wire zero = ~(|out);

  assign cout[0] = zero ? 1'b1 : 1'b0;
  assign cout[1] = out[k-1] ? 1'b1 : 1'b0;
  assign cout[2] = ovf ? 1'b1 : 1'b0;

  /*
  always@(*)begin
    casex({out,ovf})
    {{16{1'b0}},1'bx}: cout = 3'b001;			//zero flag
    {1'b1,{15{1'bx}},1'bx}: cout = 3'b010;			//negative flag
    {{16{1'bx}},1'b1} : cout = 3'b100;			//outflow flag
    default: cout = 0;
    endcase
   end
  */
  
endmodule

module AddSub(a,b,sub,s,ovf);
	parameter n=16;
	input[n-1:0] a, b;
	input sub;
	output[n-1:0] s;
	output ovf;
	wire c1, c2;
	assign ovf = c1^c2;

	assign {c1, s[n-2:0]} = a[n-2:0] + (b[n-2:0]^{n-1{sub}}) + sub;

	assign {c2, s[n-1]} = a[n-1] + (b[n-1]^sub) + c1;
endmodule