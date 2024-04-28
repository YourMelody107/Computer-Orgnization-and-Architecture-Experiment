`include "HEADER.v"

module alu(c,a,b,aluop);

output reg [31:0] c;
input [31:0] a;
input [31:0] b;
input [3:0] aluop;

initial
	begin
		c=0;
	end

//实现addu，subu，add，and，or，slt
//增加下列I型指令:  addi，addiu，andi，ori，lui

always@(a,b,aluop)
	case(aluop)
	`add:
		c=a+b;
	`sub:
		c=a-b;
	`and:
		c=a&b;
	`or:
		c=a|b;
	`slt: //小于则置位
		c=$signed(a)<$signed(b)?1:0;
	`lui: //将高16位立即数量值存放到寄存器的高16位，低16位用0填充。
		c={b,{16{1'b0}}};
	default:c=a+b;
	endcase

endmodule