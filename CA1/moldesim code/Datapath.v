`timescale 1ns/1ns
module Datapath(input clk, rst, en1, en2, initx, inity, initxbar, initybar, initb_1, initb_0,
		inittmp, initcnt, initE, initXreg, initYreg, inccnt, ldx,
		ldy, ldxbar, ldybar, ldtmp, ldb_1, ldb_0, ldE, ldXreg, ldYreg,
		s0, s1, s2, s3, s4, s5, s6, s7, s8, output co, output[19:0] vect_E, output reg [19:0] b_1, b_0);
	
	wire [19:0] x, y, b1, b0;
	
							  
	DataLoader dl(clk, rst, initcnt, initXreg, initYreg, inccnt, ldXreg, ldYreg, x, y, co);
	
	coeffientCalculator cec(x, y, clk, rst, en1, initx, inity, initxbar, initybar,
			inittmp, ldx, ldy, ldxbar, ldybar, ldtmp, s0, s1, s2, s3, s4, s5, s6, s7, s8, b1, b0);
							  
	
	ErrorChecker ec(x, y, b_1, b_0, clk, rst, en2, initE, ldE, vect_E);
	
	always@(posedge clk, posedge rst) begin
		if(rst)
			b_1 <= 20'b0;
		else begin
				if(initb_1)
					b_1 <= 20'b0;
				else
					if(ldb_1)
						b_1 <= b1;
		end
	end
	
	always@(posedge clk, posedge rst) begin
		if(rst)
			b_0 <= 20'b0;
		else begin
				if(initb_0)
					b_0 <= 20'b0;
				else
					if(ldb_0)
						b_0 <= b0;
		end
	end
	
endmodule
