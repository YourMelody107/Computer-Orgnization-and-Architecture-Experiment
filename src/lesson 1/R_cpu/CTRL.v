module ctrl(aluop,op,funct);

output reg [3:0] aluop;
input [5:0] op;
input [5:0] funct;

always@(op or funct)
	if(op==6'b000000) begin
		case(funct)
		6'b100001:aluop=4'b0000;//addu
		6'b100011:aluop=4'b0001;//subu
		6'b100000:aluop=4'b0010;//add
		6'b100100:aluop=4'b0011;//and
		6'b100101:aluop=4'b0100;//or
		6'b101010:aluop=4'b0101;//slt
		endcase
	end

endmodule