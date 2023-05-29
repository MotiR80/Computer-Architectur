`timescale 1ns/1ns
module multiplier(a, b, result);
	parameter n;
	input[n-1:0] a, b;
	output[n-1:0] result;
	wire [39:0] absresult;
	wire [39:0] absa, absb;
	wire neg;
	assign absa = a[n-1] ? (~a + 1) : a;
	assign absb = b[n-1] ? (~b + 1) : b;
	assign neg = a[n-1] ^ b[n-1];
	assign absresult = absa * absb;
	assign result = neg ? (~absresult + 1) : absresult;
endmodule

module DataLoader(input clk, rst, initcnt, initXreg, initYreg, inccnt, ldXreg, ldYreg, output reg [19:0] Xreg, Yreg, output co);
	reg [7:0] count;
	reg[19:0] memX [0:149];
	reg[19:0] memY [0:149];
	initial $readmemb ("x_value.txt",memX);
	initial $readmemb ("y_value.txt",memY);
		
	
	always@(posedge rst, posedge clk) begin
		if(rst)
			count <= 8'b0;
		else
			if(initcnt)
				count <= 8'b0;
			else
				if(inccnt)
					count <= count + 1;
	end

	always@(posedge clk, posedge rst) begin
		if(rst)
			Xreg <= 20'b0;
		else begin
				if(initXreg)
					Xreg <= 20'b0;
				else
					if(ldXreg)
						Xreg <= memX[count];
		end
	end
	
	always@(posedge clk, posedge rst) begin
		if(rst)
			Yreg <= 20'b0;
		else begin
				if(initYreg)
					Yreg <= 20'b0;
				else
					if(ldYreg)
						Yreg <= memY[count];
		end
	end
	
	assign co = (count == 149) ? 1:0;
	

endmodule

module coeffientCalculator(input signed [19:0] x, y, input clk, rst, en, initx, inity, initxbar, initybar,
			inittmp, ldx, ldy, ldxbar, ldybar, ldtmp, s0, s1, s2, s3, s4, s5, s6, s7, s8,
			output [19:0] b_1, b_0);
	
	reg [39:0] X_Sxx, Y_Sxy, xbar, ybar, temp_reg;
	wire [39:0] add, mux1, mux2, mux3, mux4, mux5, mux6, mux7, mux8, mult, sub1, sub2, div;
	
	
	always@(posedge clk, posedge rst) begin
		if(rst)
			X_Sxx <= 40'b0;
		else begin 
				if(initx)
					X_Sxx <= 40'b0;
				else
					if(ldx)
						X_Sxx <= add;
		end
	end
	
	always@(posedge clk, posedge rst) begin
		if(rst)
			Y_Sxy <= 40'b0;
		else begin
				if(inity)
					Y_Sxy <= 40'b0;
				else
					if(ldy)
						Y_Sxy <= add;
		end
	end
	
	always@(posedge clk, posedge rst) begin
		if(rst)
			xbar <= 40'b0;
		else begin
			
				if(initxbar)
					xbar <= 40'b0;
				else
					if(ldxbar)
						xbar <= div;
		end
	end
	
	always@(posedge clk, posedge rst) begin
		if(rst)
			ybar <= 40'b0;
		else begin
			
				if(initybar)
					ybar <= 40'b0;
				else
					if(ldybar)
						ybar <= div;
		end
	end
	
	always@(posedge clk, posedge rst) begin
		if(rst)
			temp_reg <= 40'b0;
		else begin
			
				if(inittmp)
					temp_reg <= 40'b0;
				else
					if(ldtmp)
						temp_reg <= sub1;
		end
	end
	
	
	assign mux1 = ({s1,s0} == 2'b00) ? x :
					  ({s1,s0} == 2'b01) ? y :
					  ({s1,s0} == 2'b10) ? mult : 40'bx;
	
	assign mux2 = (s2) ? Y_Sxy : X_Sxx;
	assign mux3 = (s3) ? Y_Sxy : X_Sxx;
	assign mux4 = (s4) ? X_Sxx : {8'b10010110};
	assign mux5 = (s5) ? y : x;
	assign mux6 = (s6) ? ybar : xbar;
	assign mux7 = (s7) ? sub1 : xbar;
	assign mux8 = (s8) ? temp_reg : div;
	
	assign add = mux1 + mux2;
	
	assign div = mux3 / mux4;
	
	assign sub1 = mux5 - mux6;
	
	multiplier#40 mp(mux7, mux8, mult);
	
	assign sub2 = ybar - mult;
	
	assign b_1 = div[19:0];
	assign b_0 = sub2[19:0];
	
endmodule

module ErrorChecker(input [19:0] x, y, b_1, b_0, input clk, rst, en, initE, ldE, output reg [19:0] vect_E);
	wire [19:0] mult, add, sub;
	
	always@(posedge clk, posedge rst) begin
		if(rst)
			vect_E <= 20'b0;
		else begin
			
				if(initE)
					vect_E <= 20'b0;
				else
					if(ldE)
						vect_E <= sub;
		end
	end
	
	multiplier#20 m2(x, b_1, mult);
	assign add = mult + b_0;
	assign sub = y - add;
	
endmodule

