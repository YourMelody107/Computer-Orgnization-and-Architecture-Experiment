`include "header.v"

module alu(c,a,b,ALUop,zero,d);
	output [31:0] c;
	output zero;
	input [31:0] a;
	input [31:0] b;
	input [3:0] ALUop;
	input [4:0] d;
	assign c =  (ALUop == `ADDU) ? a+b :
			    (ALUop == `SUBU) ? a-b :
			    (ALUop == `ADD)  ? a+b :
			    (ALUop == `AND)  ? a&b :
			    (ALUop == `OR)   ? a|b :
			    (ALUop == `SLT)  ? ((a[31]==b[31])?(a<b):a[31]) :
				(ALUop == `LUI)  ? {b[15:0],{16{1'b0}}} :
				(ALUop == `SLL)	 ? b<<d:			  
								   32'h0000;
	assign zero=(a==b)?1:0;
endmodule