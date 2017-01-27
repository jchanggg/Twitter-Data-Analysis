//-----------------------------------------------------------------------------------------------
// Instructructional Decoder
// A Decoder which takes in a 16 bit input and decodes it into instructions for the FSM and 
// the datapath
// Input 16 bit instruction to input into decoder from PC, and nsel from FSM for the MUX
// Output: Instructions for the FSM and datapath out
//
//-----------------------------------------------------------------------------------------------

module Instructdecode (in, opcode, op, ALUop, sximm5, sximm8, shift, readnum, writenum, nsel, cond);

  input [15:0] in;
  input [2:0] nsel;
  output [1:0] ALUop, shift, op; 
  output [15:0] sximm5, sximm8;
  output [2:0] readnum, writenum, opcode, cond;
  
  wire[2:0] Rn, Rd, Rm, Rout;
  wire[0:0] sign5, sign8;
  
  
  reg[15:0] sximm5, sximm8;
  
 // decoding the instructions directly bitwise
assign opcode = in[15:13];
assign op = in[12:11];
assign ALUop = in[12:11];
assign shift = in[4:3];

assign Rn = in[10:8];
assign Rd = in[7:5];
assign Rm = in[2:0];
assign cond = in[10:8];


// This MUx decodes the reg to be worked with
MUX3_3 M1(Rn, Rd, Rm, nsel, Rout);

assign readnum = Rout;
assign writenum = Rout;
assign sign5 = in[4];
assign sign8 = in[7];

// sign extensions based on the bit 5 of in
always@(*)begin
  case(sign5)
  0: sximm5 = {11'b0, in[4:0]};
  1: sximm5 = {11'b1, in[4:0]};
  default: sximm5 = 16'b0;
  endcase
end 
// sign extensions based on bit 8 of in
always@(*)begin
  case(sign8)
  0: sximm8 = {11'b0, in[7:0]};
  1: sximm8 = {11'b1, in[7:0]};
  default: sximm8 = 16'b0;
  endcase
end
endmodule 

module MUX3_3 (ain, bin, cin, vsel, dout);
  input[2:0] ain, bin, cin;
  input[2:0] vsel;
  output[2:0] dout;

  reg[2:0] dout;
  // output of MUX based on vsel
  always@(*)begin
  case(vsel)
  3'b001: dout = ain;
  3'b010: dout = bin;
  3'b100: dout = cin;
  default: dout = 3'b0;
  endcase
end
endmodule
