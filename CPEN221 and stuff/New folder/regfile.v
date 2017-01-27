//specifies the index range of each register in a wire of [127:0]
`define R0L 15
`define R0R 0

`define R1L 31
`define R1R 16

`define R2L 47
`define R2R 32

`define R3L 63
`define R3R 48

`define R4L 79
`define R4R 64

`define R5L 95 
`define R5R 80

`define R6L 111
`define R6R 96

`define R7L 127
`define R7R 112

//module regfile
//writes data to and reads number from 8 registers
//writing data is clock dependent, but reading number is combinational 
//input: data_in - data that we wish to write to either one of 8 registers
//	writenum - the register that we wish to write to
//	write - if it is 1, then writing is enabled, but if it is 0, it is disabled
//	readnum - the register that we want to read from
//	clk - on the rising edge of the clock, data gets written on to one of the 8 registers
//output: data_out

module regfile (data_in, writenum, write, readnum, clk, data_out);
	input [15:0] data_in;
	input [2:0] writenum;
	input write;
	input [2:0] readnum;
	input clk;
	output [15:0] data_out;
	
	//decode writenum from 3 to 8 bits - in other words, one-hot code
	wire[7:0] writenum_decoded;
	Dec #(3,8) U1(writenum, writenum_decoded);
	
	//specify load enable for each of 8 registers
	wire [7:0] loadR;
	assign loadR = {(writenum_decoded[7]&write),	//R7
			(writenum_decoded[6]&write),	//R6
			(writenum_decoded[5]&write),	//...
			(writenum_decoded[4]&write),
			(writenum_decoded[3]&write),
			(writenum_decoded[2]&write),	//...
			(writenum_decoded[1]&write),	//R1
			(writenum_decoded[0]&write)};	//R0
	
	//store data_in in the corresponding register if load is enabled (loadR) at the rising edge of the clock
	wire [127:0] outR; //the output of 8 registers of 16 bits each

	//implementation of 8 registers
	register registerImplementation(data_in, loadR, clk, outR);

	//decode readnum from 3 to 8 bits, in other words to one-hot code
	wire[7:0] readnum_decoded;
	Dec #(3,8) U2(readnum, readnum_decoded);

	//combinational logic - assign data_out to the value of the output of a register specified by readnum
	assign data_out = ({16{readnum_decoded[0]}} & outR[`R0L:`R0R]) |		//read from R0
				({16{readnum_decoded[1]}} & outR[`R1L:`R1R]) |		//read from R1
				({16{readnum_decoded[2]}} & outR[`R2L:`R2R]) |		//...
				({16{readnum_decoded[3]}} & outR[`R3L:`R3R]) |
				({16{readnum_decoded[4]}} & outR[`R4L:`R4R]) |
				({16{readnum_decoded[5]}} & outR[`R5L:`R5R]) |		//...
				({16{readnum_decoded[6]}} & outR[`R6L:`R6R]) |		//read from R6
				({16{readnum_decoded[7]}} & outR[`R7L:`R7R]);		//read from R7
	
endmodule	//regfile

//module register
//implementation of load-enable registers - only update the register with a new value when load is enabled
//it is clock-dependent; updates the register with either a new value or its previous value on the rising edge of the clock
//input: in - the new value that we want to write
//	loadR - specifies whether the new value or the register's previous value is going to update the register's output
//	clock - the register's output is updated on the rising edge of the clock
//	out - the output for each register
module register (in, loadR, clock, out);
	input [15:0] in;
	input [7:0]loadR;
	input clock;
	output [127:0] out;
	
	wire[127:0] present_value, previous_value; //8 values of 16 bits each
	assign previous_value = out;	//previous_value is equal to the output
	
	//implement load enable - for each register, present_value is updated to in if loadR is 1, and if loadR is 0, it is updated to its previous_value
	MUXreg loadEnable(in, previous_value, loadR, present_value);

	//implement clock - present_value is copied to out on the rising edge of the clock
	ClockImpl #(128) clockImplentation(clock, present_value, out);
endmodule //register

//module ClockImpl
//inspired by presentation slide of CPEN 211, UBC
//on the rising edge of the clock, present_value is copied to the wire out
module ClockImpl(clock, present_value, out);
	parameter n = 1;
	input clock;
	input [n-1:0] present_value;
	output [n-1:0] out; 
	reg [n-1:0] out;
	
	always @ (posedge clock)	//rising edge of the clock
		out = present_value;
endmodule //ClockImpl


//module MUXreg
//for each register, if load is 1, in is copied to out, else its previous value is copied to out
module MUXreg(in, preval, load, out);

	input [15:0] in;
	input [127:0] preval;
	input [7:0] load;
	output [127:0] out;
	
	//writes data_in to the output value of a particular register only if the corresponding load is enabled (value of 1)
	assign out = { load[7] ? in : preval[`R7L:`R7R],	//register 7
			load[6] ? in : preval[`R6L:`R6R],	//...
			load[5] ? in : preval[`R5L:`R5R],
			load[4] ? in : preval[`R4L:`R4R],
			load[3] ? in : preval[`R3L:`R3R],
			load[2] ? in : preval[`R2L:`R2R],
			load[1] ? in : preval[`R1L:`R1R],
			load[0] ? in : preval[`R0L:`R0R]};	//register 0
endmodule //MUXreg


//module Dec
//inspired by the presentation slide by CPEN 211, UBC
//writes a in one-hot code to b
module Dec (a, b);
	parameter n = 2;
	parameter m = 4;
	
	input [n-1:0] a;
	output [m-1:0] b;
	
	wire [m-1:0] b = 1 << a; //shift 1 to the left by 'a' number of times
endmodule
