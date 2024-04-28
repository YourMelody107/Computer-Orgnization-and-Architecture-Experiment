module alu(c,a,b,aluop);

output reg[31:0] c;
input [31:0] a;
input [31:0] b;
input [3:0] aluop;

initial
	begin
		c=0;
	end

//实现addu，subu，add，and，or，slt

always@(a,b,aluop)
	case(aluop)
	4'b0000://addu
		c<=$unsigned(a)+$unsigned(b);
	4'b0001://subu
		c<=$unsigned(a)-$unsigned(b);
	4'b0010://add
		c<=a+b;
	4'b0011://and
		c<=a&b;
	4'b0100://or
		c<=a|b;
	4'b0101://slt 小于则置位
		c<=$signed(a)<$signed(b);
	default:c<=0;
	endcase

endmodule