`include "header.v"
module mux_a(c,aluop,addu_0, subu_0, add_0, and_0, or_0, slt_0,lui_0);
	input [3:0] aluop;
	input [31:0] addu_0, subu_0, add_0, and_0, or_0, slt_0,lui_0;
	
	output reg [31:0] c;

always@(*)
	begin
		case(aluop)
			`ADDU :c=addu_0;
			`SUBU :c=subu_0;
			`ADD  :c=add_0;
			`AND  :c=and_0;
			`OR   :c=or_0;
			`SLT  :c=slt_0;
			`LUI  :c=lui_0;    
		endcase
	end

endmodule
