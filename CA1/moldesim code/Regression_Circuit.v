`timescale 1ns/1ns
module Regression(input clk, rst, start, output ready, output[19:0] vect_E, b_1, b_0);
	
	wire en1, en2, initx, inity, initxbar, initybar, initb_1, initb_0, inittmp, initE, initXreg, initYreg, initcnt, inccnt;
	wire ldx, ldy, ldxbar, ldybar, ldtmp, ldb_1, ldb_0, ldE, ldXreg, ldYreg, s0, s1, s2, s3, s4, s5, s6, s7, s8, co;

	Datapath dp(clk, rst, en1, en2, initx, inity, initxbar, initybar, initb_1, initb_0, inittmp, initcnt, initE,
		initXreg, initYreg, inccnt, ldx,ldy, ldxbar, ldybar, ldtmp, ldb_1, ldb_0, ldE, ldXreg, ldYreg, s0, s1, s2, s3, s4, s5, s6, s7, s8,
		co, vect_E, b_1, b_0);

	Controller cu(clk, rst, start, co, en1, en2, initx, inity, initxbar, initybar,
			initb_1, initb_0, inittmp, initcnt, initE, initXreg, initYreg, inccnt, ldx,ldy, ldxbar, ldybar,
			ldtmp, ldb_1, ldb_0, ldE, ldXreg, ldYreg, s0, s1, s2, s3, s4, s5, s6, s7, s8, ready);
endmodule