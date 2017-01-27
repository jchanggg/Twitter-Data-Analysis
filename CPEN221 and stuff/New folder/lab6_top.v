module lab7_top(KEY, LEDR);
	input [3:0] KEY;
	output [9:0] LEDR;

	//instantiate clk and reset
	wire rst, clk;
	assign rst = ~KEY[1];	//pressed is 0, not pressed is 1; reverse
	assign clk = ~KEY[0];


	//CPU implementation
	wire [2:0] opcode;
	wire [1:0] op;

	wire [2:0] nsel;

	wire loadir, loadpc, msel, mwrite;
	wire bsel, asel, loada, loadb, loadc, write;
	wire [3:0] vsel;
	wire loads;						
	//lab7
	wire incp, execb, tsel;
	
	cpu FSM (op, opcode, rst, loads, nsel, loadpc, msel, mwrite, loadir, clk, bsel, asel, loada, loadb, loadc, vsel, write,
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
	
	datapath DP (clk, readnum, vsel, loada, loadb, shift, asel, bsel, ALUop, loadc, loads, writenum, write, status, datapath_out, 
		sximm5, sximm8, mdata, PC, b_out, a_out);

	//PC+RAM
	PC_RAM PCRAM(clk, loadpc, rst, datapath_out, msel, b_out, mwrite, loadir, ir, PC, mdata,
		sximm8, incp, execb, status, cond, a_out, tsel);

	//output the lowest 10 bits of register B on LEDR
	assign LEDR =  datapath_out[9:0];
endmodule
