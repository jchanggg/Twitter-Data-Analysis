module PC_RAM_tb;
	//lab7
	reg tsel_sim, incp_sim, execb_sim;
	reg [7:0] sximm8_sim;
	reg [15:0] a_out_sim;
	reg [2:0] status_sim, cond_sim;

	//lab6
	reg clk_sim, reset_sim, msel_sim, mwrite_sim, loadir_sim;
	reg [15:0] c_out_sim, b_out_sim;
	wire [15:0] mdata_sim, ir_sim;
	wire [7:0] PC_out_sim;

	PC_RAM DUT (clk_sim, reset_sim, c_out_sim, msel_sim, b_out_sim, mwrite_sim, loadir_sim, ir_sim, PC_out_sim, mdata_sim,
		sximm8_sim, incp_sim, execb_sim, status_sim, cond_sim, a_out_sim, tsel_sim);

	initial forever begin
		clk_sim=0;
		#10;
		clk_sim=1;
		#10;
	end

	initial begin
		//reset
		reset_sim = 1;
		#15;
		
		//first cycle: test incrementing pc
		reset_sim = 0;
		sximm8_sim = 5;
		tsel_sim = 1;
		incp_sim = 1;	//choose incremented pc
		#20;

		//second cycle: test B [PC+=sx(im8)]
		incp_sim = 0;
		execb_sim = 1;
		status_sim = 3'b111;
		cond_sim = 3'b0;		//B
		#20;

		//third cycle: test B [PC+=sx(im8)] with execb = 0 and a different value of status
		//pc is unaffected by change in status
		//pc should freeze
		sximm8_sim = 8'b00001111;
		execb_sim = 0;
		status_sim = 3'b101;
		cond_sim = 3'b0;		//B
		#20;

		//fourth cycle: test BEQ
		//the result should be 6+3=9 (8'b00001001)
		sximm8_sim = 8'b00000011;	//decimal 3
		execb_sim = 1;
		status_sim = 3'b001;		//Z flag
		cond_sim = 3'b001;		//BEQ
		#20;

		//fifth cycle: fail BEQ
		//pc should freeze
		sximm8_sim = 8'b00000100;	//decimal 4
		execb_sim = 1;
		status_sim = 3'b100;		//Z flag
		cond_sim = 3'b001;		//BEQ
		#20;

		//6th cycle: test BNE 
		//pc should be 9+4=13 (8'b00001101)
		sximm8_sim = 8'b00000100;	//decimal 4
		execb_sim = 1;
		status_sim = 3'b110;		//Z flag off
		cond_sim = 3'b010;		//BNE
		#20;

		//7th cycle: test BNE 
		//different status, but Z stil off
		//pc should be 13+5=18 (8'b00010010)
		sximm8_sim = 8'b00000101;	//decimal 5
		execb_sim = 1;
		status_sim = 3'b000;		//Z flag off
		cond_sim = 3'b010;		//BNE
		#20;

		//8th cycle: fail BNE
		//Z flag on
		//pc should freeze at 18 (8'b0010010)
		sximm8_sim = 8'b00000011;	//decimal 3
		execb_sim = 1;
		status_sim = 3'b001;		//Z flag on
		cond_sim = 3'b010;		//BNE
		#20;

		//9th cycle: test BLT
		//pc should be 18+2=20 (8'b0010100)
		sximm8_sim = 8'b00000010; 	//decimal 2
		execb_sim = 1;
		status_sim = 3'b100;		//V=1, N=0; V!=N
		cond_sim = 3'b011;		//BLT
		#20;

		//10th cycle: test BLT
		//pc should be 20+3=23 (8'b0010111)
		sximm8_sim = 8'b00000011; 	//decimal 3
		execb_sim = 1;
		status_sim = 3'b010;		//V=0, N=1; V!=N
		cond_sim = 3'b011;		//BLT
		#20;

		//11th cycle: fail BLT
		//pc should freeze at 23 (8'b0010111)
		sximm8_sim = 8'b00000111; 	//decimal 7
		execb_sim = 1;
		status_sim = 3'b110;		//V=1, N=1; V==N
		cond_sim = 3'b011;		//BLT
		#20;

		//12th cycle: fail BLT
		//pc should freeze at 23 (8'b0010111)
		sximm8_sim = 8'b00000111; 	//decimal 7
		execb_sim = 1;
		status_sim = 3'b001;		//V=0, N=0; V==N
		cond_sim = 3'b011;		//BLT
		#20;

		//13th cycle: test BLE
		//pc should be 23+2=25 (8'b00011001)
		sximm8_sim = 8'b00000010;	//decimal 2
		execb_sim = 1;
		status_sim = 3'b001;		//V=0, N=0, Z=1; Z=1
		cond_sim = 3'b100;		//BLE
		#20;

		//14th cycle: test BLE
		//pc should be 25+3=28 (8'b00011100)
		sximm8_sim = 8'b00000011;	//decimal 3
		execb_sim = 1;
		status_sim = 3'b010;		//V=0, N=1, Z=0; V!=N
		cond_sim = 3'b100;		//BLE
		#20;

		//15th cycle: test BLE
		//pc should be 28+4=32 (8'b00100000)
		sximm8_sim = 8'b00000100;	//decimal 4
		execb_sim = 1;
		status_sim = 3'b100;		//V=1, N=0, Z=0; V!=N
		cond_sim = 3'b100;		//BLE
		#20;

		//16th cycle: test BLE
		//pc should be 32+7=39 (8'b00100111)
		sximm8_sim = 8'b00000111;	//decimal 4
		execb_sim = 1;
		status_sim = 3'b101;		//V=1, N=0, Z=1; V!=N and Z=1
		cond_sim = 3'b100;		//BLE
		#20;

		//17th cycle: fail BLE
		//pc should freeze at 39 (8'b00100111)
		sximm8_sim = 8'b00000111;	//decimal 4
		execb_sim = 1;
		status_sim = 3'b000;		//V=0, N=0, Z=0; V==N and Z!=1
		cond_sim = 3'b100;		//BLE
		#20;

		//18th cycle: fail BLE
		//pc should freeze at 39 (8'b00100111)
		sximm8_sim = 8'b00000111;	//decimal 4
		execb_sim = 1;
		status_sim = 3'b110;		//V=1, N=1, Z=0; V==N and Z!=1
		cond_sim = 3'b100;		//BLE
		#20;

		$stop;
	end
		
endmodule

