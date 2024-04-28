//符号拓展模块
module extend(s_ext,imm,ext_imm);
input [15:0]imm;//16位立即数，来自于指令
input s_ext;//选择控制信号,来自于ctrl模块
output reg [31:0] ext_imm;//32位扩展后的数据
always@(*)
begin
	case(s_ext)
	0:
	ext_imm = {{16{1'b0}}, imm[15:0]};
	1:
	ext_imm = {{16{imm[15]}}, imm[15:0]};
	endcase
end
endmodule



