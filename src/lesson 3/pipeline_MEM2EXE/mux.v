module mux #(parameter wid)(s,a,b,out);

	input [wid-1:0]a;
	input [wid-1:0]b;
	input s;
	output reg [wid-1:0]out;

	assign out=(s==1)?b:a;

endmodule