module lab7_top_tb;
	reg [3:0] KEY_sim;
	reg CLOCK_50_sim;
	wire [9:0] LEDR_sim;

	lab7_top DUT(KEY_sim, CLOCK_50_sim, LEDR_sim);

	initial begin
		KEY_sim[1]=0;
		#10;
		CLOCK_50_sim=0;
		#10;
		CLOCK_50_sim=1;
		#10;
		KEY_sim[1]=1;
		#10;
		
		repeat (100) begin
			CLOCK_50_sim=0;
			#10;
			CLOCK_50_sim=1;
			#10;
		end
	end
/*
	initial begin

	end
*/
endmodule
