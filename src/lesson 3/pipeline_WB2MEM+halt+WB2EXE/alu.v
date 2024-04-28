module alu(c,a,b,zero,aluop);

	input [31:0] a;
	input [31:0] b;
	input [3:0] aluop;

	output [31:0]c;
	output reg zero;

	reg [31:0] c_addu, c_subu, c_add, c_and, c_or, c_slt,c_lui;

always @(*)
	begin
 	   c_addu=a+b;
 	   c_subu=a-b;
  	   c_add =a+b;
       	   c_and=a&b;
   	   c_or=a|b;
           c_slt=$signed(a)<$signed(b)?1:0;
	   c_lui=b<<16;
	
	if(a==b)
	   zero=1;
	else
	   zero=0;
end
mux_a MUX(c,aluop,c_addu, c_subu, c_add, c_and, c_or, c_slt,c_lui);
endmodule
