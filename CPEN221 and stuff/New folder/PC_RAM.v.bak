module PC_RAM (clk, reset, c_out, msel, b_out, mwrite, loadir, ir, PC_out, mdata,
		sximm8, incp, execb, status, cond, a_out, tsel);
	input clk, reset, msel, mwrite, loadir;	//TODO: remove loadpc
	input [15:0] c_out, b_out;
	//lab7
	input [7:0] sximm8;
	input incp, execb, tsel;
	input [2:0] status, cond;
	input [15:0] a_out;

	output [15:0] mdata, ir;
	output [7:0] PC_out;

	wire [7:0] PC_out, PCin, PCchoice;
	wire [7:0] address_in;	

	//add sximm8 and PC_out
	wire [7:0] pcrel;
	wire [2:0] addstat;

	`define ADD 2'b0
	ALU #(8) add(sximm8, PC_out, `ADD, pcrel, addstat);

	//bonus : to be implemented?
	wire [7:0] pctgt; 
	assign pctgt = tsel ? pcrel : a_out[7:0];	//TODO
	
	//increase PC_out by 1
	wire [7:0] pc1;
	assign pc1 = PC_out + 1;

	//choose for pc_next
	wire [7:0] pc_next;
	assign pc_next = incp ? pc1 : pctgt;
	

	//branch unit
	wire taken;
	branch BR(execb, status, cond, taken);

	//logic for loadpc
	wire loadpc;
	assign loadpc = incp | taken;
	

	//multiplexer: increase PC out or leave it as is
	//multiplex #(8) PCchoose(loadpc, PCincr, PC_out, PCchoice);
	assign PCchoice = loadpc ? pc_next : PC_out;

	//multiplexer: reset function
	//multiplex #(8) RESET(reset, 8'b0, PCchoice, PCin);
	assign PCin = reset ? 8'b0 : PCchoice;

	//PC DFF implementation
	vDFF #(8) PCDFF(clk, PCin, PC_out);

	//MUX with msel - implementation
	//multiplex #(8) MSEL(msel, c_out[7:0], PC_out, address_in);
	assign address_in = msel ? c_out[7:0] : PC_out;

	//RAM implementation
	RAM ram(clk, address_in, address_in, mwrite, b_out, mdata);

	//instruction register
	plregister IR(mdata, clk, loadir, ir);

endmodule

module branch (execb, status, cond, out);
	input execb;
	input [2:0] status; 	//[0]: Z flag	[1]: N flag	[2]: V flag
	input [2:0] cond;
	output out;
	reg cs;

	//NV is 1 if N!=Z
	wire NV;
	assign NV = status[1]^status[2];

	//NVZ is 1 if N!=Z or Z=1
	wire NVZ;
	assign NVZ = NV|status[0];

	always @(*) begin
		casex({cond, status, NV, NVZ})
			//B
			{3'b0, 3'bx, 1'bx, 1'bx} : cs = 1;
			
			//BEQ
			{3'b001, 3'bxx1, 1'bx, 1'bx} : cs = 1;
			{3'b001, 3'bxx0, 1'bx, 1'bx} : cs = 0;

			//BNE
			{3'b010, 3'bxx0, 1'bx, 1'bx} : cs = 1;
			{3'b010, 3'bxx1, 1'bx, 1'bx} : cs = 0;

			//BLT
			{3'b011, 3'bx, 1'b1, 1'bx} : cs = 1;
			{3'b011, 3'bx, 1'b0, 1'bx} : cs = 0;

			//BLE
			{3'b100, 3'bx, 1'bx, 1'b1} : cs = 1;
			{3'b100, 3'bx, 1'bx, 1'b0} : cs = 0;

			default: cs = 0;
		endcase
	end

	assign out = execb & cs;
endmodule
