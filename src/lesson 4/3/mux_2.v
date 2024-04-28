module mux_2 #(parameter width=5)(a,b,c,sel);
	input [width-1:0]a;
	input [width-1:0]b;
	input sel;
	output [width-1:0]c;
	assign c=sel?b:a;
endmodule

module mux_3 #(parameter width=5)(a,b,c,d,sel);
	input [width-1:0]a;
	input [width-1:0]b;
	input [width-1:0]c;
	input [1:0] sel;
	output [width-1:0] d;
	assign d=(sel==2'b00)?a:((sel==2'b01)?b:c);
endmodule

module mux_4 #(parameter width=5)(a,b,c,d,e,sel);
	input [width-1:0]a;
	input [width-1:0]b;
	input [width-1:0]c;
	input [width-1:0]d;
	input [1:0] sel;
	output [width-1:0]e;
	assign e=(sel==2'b00)	?	a:
			 (sel==2'b01)	?	b:
			 (sel==2'b10)	?	c:
								d;
endmodule