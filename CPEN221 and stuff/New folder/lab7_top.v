module lab7_top(KEY, CLOCK_50, LEDR);
	input [3:0] KEY;
	input CLOCK_50;
	output [9:0] LEDR;

	//instantiate reset
	wire rst;
	assign rst = ~KEY[1];	//pressed is 0, not pressed is 1; reverse
	//assign clk = CLOCK_50;


	//CPU implementation
	wire [2:0] opcode;
	wire [1:0] op;

	wire [2:0] nsel;

	wire loadir, msel, mwrite;
	wire bsel, asel, loada, loadb, loadc, write;
	wire [3:0] vsel;
	wire loads;						
	//lab7
	wire incp, execb, tsel;
	
	cpu FSM (op, opcode, rst, loads, nsel, msel, mwrite, loadir, CLOCK_50, bsel, asel, loada, loadb, loadc, vsel, write,
		execb, incp, tsel);

	//instruction decoder
	wire [15:0] ir, sximm5, sximm8;
	wire [1:0] ALUop, shift;
	wire [2:0] readnum, writenum;
	//lab7
	wire [2:0] cond;
	Instructdecode ID(ir, opcode, op, ALUop, sximm5, sximm8, shift, readnum, writenum, nsel,
		cond);

	//datapath from lab5
	wire [15:0] datapath_out, mdata, b_out;
	wire [7:0] PC;
	wire [2:0] status;					
	//lab7
	wire [15:0] a_out;
	
	datapath DP (CLOCK_50, readnum, vsel, loada, loadb, shift, asel, bsel, ALUop, loadc, loads, writenum, write, status, datapath_out, 
		sximm5, sximm8, mdata, PC, b_out, a_out);

	//sximm8 input to PC_RAM should be bits [7:0] from original
	wire [7:0] sximm8_short;
	assign sximm8_short = sximm8 [7:0];
	//PC+RAM
	PC_RAM PCRAM(CLOCK_50, rst, datapath_out, msel, b_out, mwrite, loadir, ir, PC, mdata,
		sximm8_short, incp, execb, status, cond, a_out, tsel);

	//output the lowest 10 bits of register B on LEDR
	//assign LEDR =  datapath_out[9:0];
	//lab7
	assign LEDR = datapath_out[9:0];
endmodule
