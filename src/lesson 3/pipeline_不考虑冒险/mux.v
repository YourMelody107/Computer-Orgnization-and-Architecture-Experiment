module mux #(parameter wid)(s,a,b,out);

	input [wid-1:0]a;
	input [wid-1:0]b;
	input s;
	output reg [wid-1:0]out;

	assign out=(s==1)?b:a;

endmodule

module mux0 #(parameter wid) (s,a,b,c,out);  //三选一多路选择器

	input [wid-1:0] a;
	input [wid-1:0] b;
	input [wid-1:0] c;
	input [1:0]s;   //控制信号需要两位
	output reg [wid-1:0] out;

always@(*) 
begin
	case(s)
		2'b00:out<=a;
		2'b01:out<=b;
		2'b10:out<=c;
		default:out<=8'bxxxxxxxx;
	endcase
end

endmodule

module mux1 #(parameter wid) (s,a,b,c,d,out);  //三选一多路选择器

	input [wid-1:0] a;
	input [wid-1:0] b;
	input [wid-1:0] c;
	input [wid-1:0] d;
	input [1:0]s;   //控制信号需要两位

	output reg [wid-1:0] out;

	always@(*) begin
		case(s)
			2'b00:out<=a;
			2'b01:out<=b;
			2'b10:out<=c;
			2'b11:out<=d;
		endcase
	end

endmodule