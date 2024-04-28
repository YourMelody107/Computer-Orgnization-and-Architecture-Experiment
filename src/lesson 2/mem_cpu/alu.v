`include "header.v"

module alu(c, a, b, aluop);

output reg [31:0] c;
input [31:0] a, b;
input [3:0] aluop;

always @(a or b or aluop) 
begin
    case(aluop)
    `aluop_addu: c = a + b;
    `aluop_subu: c = a - b;
    `aluop_add:  c = $signed(a) + $signed(b);
    `aluop_and:  c = a & b;
    `aluop_or:   c = a | b;
    `aluop_slt:  c = ($signed(a) < $signed(b)) ? 1: 0;
    `aluop_lui:  c = {b[15:0], 16'b0};
    endcase
end

endmodule