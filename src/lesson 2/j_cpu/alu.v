`include "header.v"

module alu(c, a, b, aluop, zero);

output reg [31:0] c;
output reg zero;//1表示结果为0
input [31:0] a, b;
input [3:0] aluop;

always @(c) 
begin
  if(c == 0)
    zero = 1;
  else 
    zero = 0;
end

always @(a or b or aluop) 
begin
    case(aluop)
    `aluop_addu: c = a + b;
    `aluop_subu: c = a - b;
    `aluop_add:  c = $signed(a) + $signed(b);
    `aluop_and:  c = a & b;
    `aluop_or:   c = a | b;
    `aluop_slt:  c = ($signed(a) < $signed(b)) ? 32'd1: 32'd0;
    `aluop_lui:  c = {b[15:0], 16'b0};
    `aluop_sub:  c = $signed(a) - $signed(b);
    endcase
end

endmodule