module ext(imm,s_ext,imm_i);

input [15:0] imm;
input s_ext;
output reg [31:0] imm_i;

always@(*)
	begin
	if(s_ext==0) //零扩展
		imm_i={{16{1'b0}},imm};
	else //符号扩展
		imm_i={{16{imm[15]}},imm};
	end

endmodule