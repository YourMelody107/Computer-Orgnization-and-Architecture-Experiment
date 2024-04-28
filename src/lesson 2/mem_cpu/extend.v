module extend (b_extend, imm16, s_ext);

input [15:0] imm16;
input s_ext;
output reg [31:0] b_extend;

always @(*) 
begin
    case(s_ext)
        1'b0: b_extend = {16'b0, imm16[15:0]}; //零扩展
        1'b1: b_extend = {{16{imm16[15]}}, imm16[15:0]}; //符号扩展
    endcase
end

endmodule