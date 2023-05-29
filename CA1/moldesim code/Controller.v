`timescale 1ns/1ns
module Controller(input clk, rst, start, co, output reg en1, en2, initx, inity, initxbar, initybar,
							  initb_1, initb_0, inittmp, initcnt, initE, initXreg, initYreg, inccnt, ldx,ldy, ldxbar, ldybar,
							  ldtmp, ldb_1, ldb_0, ldE, ldXreg, ldYreg, s0, s1, s2, s3, s4, s5, s6, s7, s8, ready);
	reg[3:0] ps, ns;
	
	parameter Idle = 0, Init1 = 1, SumX = 2, SumY = 3, clcXbar = 4, clcYbar = 5, Init2 = 6, Temp = 7, SSxx = 8, SSxy = 9,
					B1 = 10, B0 = 11, Error_Check = 12;
	
	always@(ps, start, co) begin
		ns = Idle;
		{en1, en2} = 2'b0;
		{initx, inity, initxbar, initybar, initb_1, initb_0, inittmp, initcnt, initE, initXreg, initYreg} = 11'b0;
		{inccnt, ldx, ldy, ldxbar, ldybar, ldtmp, ldb_1, ldb_0, ldE, ldXreg, ldYreg} = 11'b0;
		ldXreg = 1'b1;
		ldYreg = 1'b1;
		ready = 1'b0;
							  
			case(ps)
				Idle: begin ns = start ? Init1:Idle; ready = 1'b1; end
				Init1: begin ns = SumX; {initx, inity, initxbar, initybar,
							initb_1, initb_0, inittmp, initcnt, initE} =  9'b111111111;  end
				SumX: begin ns = SumY; en1 = 1'b1; ldx = 1'b1; {s2,s1,s0} = 3'b000; end
				SumY: begin ns = co ? clcXbar:SumX; en1 = 1'b1; ldy = 1'b1; {s2,s0} = 2'b11; s1 = 1'b0; inccnt = 1'b1; end
				clcXbar: begin ns = clcYbar; en1 = 1'b1; ldxbar = 1'b1; {s4,s3} = 2'b00;ldXreg = 1'b0; ldYreg = 1'b0; end
				clcYbar: begin ns = Init2; en1 = 1'b1; ldybar = 1'b1; initcnt = 1'b1; s3 = 1'b1; s4 = 1'b0;ldXreg = 1'b0; ldYreg = 1'b0; end
				Init2: begin ns = Temp; en1 = 1'b1; initx = 1'b1; inity = 1'b1; end
				Temp: begin ns = SSxx; en1 = 1'b1; ldtmp = 1'b1; {s6,s5} = 2'b00; end
				SSxx: begin ns = SSxy; en1 = 1'b1; ldx = 1'b1; {s6,s5,s2,s0} = 4'b0000; {s8,s7,s1} = 3'b111; end
				SSxy: begin ns = co ? B1:Temp; en1 = 1'b1; ldy = 1'b1; {s8,s7,s6,s5,s2,s1} = 6'b111111; s0 = 1'b0; inccnt = 1'b1; end
				B1: begin ns = B0; en1 = 1'b1; ldb_1 = 1'b1; {s4,s3} = 2'b11;ldXreg = 1'b0; ldYreg = 1'b0; end
				B0: begin ns = Error_Check; en1 = 1'b1; ldb_0 = 1'b1; {s8,s7} = 2'b00; initcnt = 1'b1;ldXreg = 1'b0; ldYreg = 1'b0; end
				Error_Check: begin ns = co? Idle:Error_Check; en2 = 1'b1; inccnt = 1'b1; ldE = 1'b1; end
				default ns = Idle;
			endcase
	end
	
	always@(posedge rst, posedge clk) begin
		if(rst)
			ps <= Idle;
		else
			ps <= ns;
	end
	
endmodule