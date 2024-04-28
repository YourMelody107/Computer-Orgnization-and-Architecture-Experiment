`include "header.v"

module alu(c,a,b,ALUop,zero,shamt);
  output [31:0] c;
  input [31:0] a;
  input [31:0] b;
  input [3:0] ALUop;
  input [4:0] shamt;
  output zero;

  assign c =  (ALUop == `addu) ? a+b :
         (ALUop == `SUBU) ? a-b :
         (ALUop == `ADD)  ? a+b :
         (ALUop == `AND)  ? a&b :
         (ALUop == `OR)   ? a|b :
         (ALUop == `SLT)  ? ((a[31]==b[31])?(a<b):a[31]) :
         (ALUop == `LUI)  ? {b[15:0],{16{1'b0}}} :
         (ALUop == `SLL)  ? b<<shamt:
         32'h0000;
  assign zero=(a==b)?1:0;
endmodule
