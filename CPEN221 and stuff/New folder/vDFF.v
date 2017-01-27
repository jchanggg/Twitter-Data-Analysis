module vDFF(clock, present_value, out);
	parameter n = 1;
	input clock;
	input [n-1:0] present_value;
	output [n-1:0] out; 
	reg [n-1:0] out;
	
	always @ (posedge clock)	//rising edge of the clock
		out = present_value;
endmodule //vDFF
