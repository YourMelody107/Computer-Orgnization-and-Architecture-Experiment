module alu(c, a, b, aluop,zero0);

	output reg [31:0] c;

	input [31:0] a;
	input [31:0] b;
	input [3:0] aluop;
	output reg zero0;
	
	assign zero0=0;

always@(*)
	begin
	case(aluop)
		4'b0000:c=a+b;
		4'b0001:c=a-b;
		4'b0010:c=a+b;
		4'b0011:c=a&b;
		4'b0100:c=a|b;
		4'b0101:c=(a<b&&a[31]>=b[31]||(a[31]&&!b[31]))?1:0;
		4'b0110:c=a+b;
		4'b0111:c=a+b;
		4'b1000:c=a&b;
		4'b1001:c=a|b;
		4'b1010:c=b<<16;
		4'b1011:c=a+b;
		4'b1100:c=a+b;
		4'b1101:
			begin
			c=a-b;
			zero0=(c==0)?1:0;
			end		
		default:c=32'hxxxxxxxx;
	endcase
	end
endmodule
