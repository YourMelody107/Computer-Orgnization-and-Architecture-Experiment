`include "header.v"

module ctrl(aluop, op, reg_write, funct, s_num_write, s_b, s_ext, mem_write, s_data_write);
output reg [3:0] aluop;
output reg_write;
output reg s_num_write, s_b, s_ext, mem_write,s_data_write;
input [5:0] op;
input [5:0] funct;

//s_num_write, s_b 信号赋值
always @(op) 
begin
    if(op == 6'b0)//R_type
    begin
      s_num_write = 1;
      s_b = 0;
    end
    else //I_type
    begin
      s_num_write = 0;
      s_b = 1;
    end
end


//s_ext信号赋值
always @(op)
begin
    case(op)
        `op_R: ;
        `op_I_addi: s_ext = 1'b1;
        `op_I_addiu: s_ext = 1'b1;
        `op_I_andi: s_ext = 1'b0;
        `op_I_ori: s_ext = 1'b0;
        `op_I_lui: s_ext = 1'b0;
		`op_MEM_sw:s_ext = 1'b1;
		`op_MEM_lw:s_ext = 1'b1;
    endcase
end

//aluop信号赋值
always @(op or funct) 
begin
    if(op == `op_R)
        case(funct)
            `funct_addu: aluop = `aluop_addu;
            `funct_subu: aluop = `aluop_subu;
            `funct_add: aluop = `aluop_add;
            `funct_and: aluop = `aluop_and;
            `funct_or: aluop = `aluop_or;
            `funct_slt: aluop = `aluop_slt;
        endcase
    else
        case(op)
            `op_I_addi: aluop = `aluop_add;
            `op_I_addiu: aluop = `aluop_addu;
            `op_I_andi: aluop = `aluop_and;
            `op_I_ori: aluop = `aluop_or;
            `op_I_lui: aluop = `aluop_lui;
			`op_MEM_sw:aluop = `aluop_add;
			`op_MEM_lw:aluop = `aluop_add;
        endcase
end

assign mem_write=(op==`op_MEM_sw)?1:0;
assign reg_write=(op==`op_MEM_sw)?0:1;
assign s_data_write=(op==`op_MEM_lw)?1:0;

endmodule