//加入I型指令后的ALU
module alu (c,a,b,aluop);
output reg [31:0] c;//计算结果输出端
input [31:0] a;
input [31:0] b;
input [3:0] aluop;//来自ctrl模块，用来选择进行哪种运算

always@(*)
	begin
		case(aluop)
		0,
		2,
		6,
		7,
		11,
		12:
			c = a + b;
		1:
			c = a - b;
		3,
		8:
			c = a & b;
		4,
		9:
			c = a | b;
		5:
			c = ($signed(a) < $signed(b));//注意应该是有符号数比较
		10:
			c = {b[15:0],{16{1'b0}}};//高16位为立即数，低16位为0
		13:
			c = 0;
		endcase
	end

endmodule


