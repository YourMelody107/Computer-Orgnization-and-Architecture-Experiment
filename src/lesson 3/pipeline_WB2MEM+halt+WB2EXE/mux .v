module  mux #(parameter width=32) (out,a,b,s);
output [width-1: 0] out;
input s;
input [width-1:0] a,b;

assign out = s ? a : b;

endmodule

module  mux0 #(parameter width=32) (out,a,b,c,s);
output reg [width-1: 0] out;
input [1:0] s;//三路选择器，所以s变成了两位
input [width-1:0] c, b, a;

    always @(*) 
	begin
        case (s)
            0: out = c;
            1: out = b;
            2: out = a;
        endcase
    end

endmodule
