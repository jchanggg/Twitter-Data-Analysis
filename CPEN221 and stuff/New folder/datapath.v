//datapath for the entire module calculator
//connects all the different components as shown in figure 1 in lab5.pdf, CPEN 211
module datapath (clk, readnum, vsel, loada, loadb, shift, asel, bsel, ALUop, loadc, loads, writenum, write, status, datapath_out, 
		sximm5, sximm8, mdata, PC, b_out, a_out);
	input [2:0] readnum, writenum;
	input clk, loada, loadb, asel, bsel, loadc, loads, write;
	input [1:0] shift, ALUop;
	
	//lab6
	input [15:0] sximm5, sximm8, mdata;
	input [7:0] PC;
	input [3:0] vsel;

	output [15:0] datapath_out;
	wire [15:0] datapath_out;
	output [2:0] status;
	output [15:0] b_out;

	//lab7
	output [15:0] a_out;

	//lab6 fix - 4 input mux
	wire [15:0] data_in;
	wire [15:0] mod = {8'b0, PC};
	writebackMUX WB(mdata, sximm8, mod, datapath_out, vsel, data_in);	
	
	//register file 
	//refer to regfile.v
	wire [15:0] data_out;
	regfile REG(data_in, writenum, write, readnum, clk, data_out);

	//register A and B
	//their outputs are updated to data_out on the rising edge of the clock only if their load is enabled
	//wire [15:0] a_out;
	plregister A(data_out, clk, loada, a_out);		
	plregister B(data_out, clk, loadb, b_out);

	//shifter
	//refer to Shifter.v
	wire [15:0] shift_out;
	Shifter shifter(b_out, shift, shift_out);
	

	//multiplexers A and B
	wire [15:0] A_in, B_in;
	wire [15:0] MUXA_in = 16'b0;
	wire [15:0] MUXB_in;
	assign MUXB_in = sximm5;
	
	//MUX A
	multiplex #(16) MUXA(asel, MUXA_in, a_out, A_in);	//if asel is 1, then A_in is MUXA_in, otherwise a_out
	//MUX B
	multiplex #(16) MUXB(bsel, MUXB_in, shift_out, B_in);		//if bsel is 1, then B_in is MUXB_in, otherwise shift_out

	//lab6 fix
	//ALUop and status
	//refer to ALU.v and statusregister.v
	wire [15:0] ALU_out;
	wire [2:0] toStat;
	ALU alu(A_in, B_in, ALUop, ALU_out, toStat);
	statusregister stat(toStat, clk, loads, status);

	
	//register C
	//on the rising edge of the clock, if load is 1, then datapath_out is updated to ALU_out
	plregister C(ALU_out, clk, loadc, datapath_out);

endmodule	//datapath