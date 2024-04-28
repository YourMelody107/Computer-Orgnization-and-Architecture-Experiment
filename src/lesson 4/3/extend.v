module extend(imm,ext,imm_out);
	input [15:0]imm;
	input ext;
	output [31:0]imm_out;
	//sign-extend when ext==1,else zero-extend
	assign imm_out=ext?imm[15]?{16'hffff,imm}:{16'h0000,imm}:
				   {16'h0000,imm};
endmodule