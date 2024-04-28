`include "header.v"

module ctrl(aluop, op, reg_write, funct, s_num_write, s_b, s_ext, mem_write, s_data_write, s_npc);
output reg [3:0] aluop;
output reg s_b, reg_write, s_ext, mem_write;
output reg [1:0] s_num_write, s_data_write, s_npc;
input [5:0] op;
input [5:0] funct;

//s_num_write信号赋值
always @(op or funct) 
begin
    if(op == `op_R)//R_type
      s_num_write = 2'b01;
    else if(op == `op_J_jal)//jal
      s_num_write = 2'b10;
    else //I_type, MEM_type,j_type
      s_num_write = 2'b00;
end

//s_b信号赋值
always @(op or funct) 
begin
    if(op == `op_R || op == `op_J_beq)//R_type
    s_b = 0;
    else //I_type, MEM_type
    s_b = 1;
end

//s_ext信号赋值
always @(op or funct)
begin
    case(op)
        `op_R: s_ext = 0;//这里其实赋什么值都可以，因为用不到
        `op_I_addi: s_ext = 1'b1;
        `op_I_addiu: s_ext = 1'b1;
        `op_I_andi: s_ext = 1'b0;
        `op_I_ori: s_ext = 1'b0;
        `op_I_lui: s_ext = 1'b0;
        `op_J_beq: s_ext = 1'b1;
        default: s_ext = 1'b0;
    endcase
end

//mem_write信号赋值
always @(op or funct) 
begin
    if(op == `op_MEM_sw)
      mem_write = 1;
    else
      mem_write = 0;
end

//reg_write信号赋值
always @(op or funct) 
begin
   if(op == `op_MEM_sw)
   reg_write = 0;
   else if(op == `op_J_j)
   reg_write = 0;
   else if (op == `op_R && funct == `funct_jr)
   reg_write = 0;
   else if(op == `op_J_beq)
   reg_write = 0;
   else if(op ==`op_R||op==`op_I_addi||op==`op_I_addiu||op==`op_I_andi||op==`op_I_ori||op==`op_I_lui||op==`op_MEM_lw ||op==`op_J_jal)
   reg_write = 1; 
   else if(op==6'bxxxxxx)
   reg_write = 0; 
   else 
    reg_write = 1;
end

//s_data_write信号赋值
always @(op or funct) 
begin
    if (op == `op_J_jal)
    s_data_write = 2'b00;
    else if(op == `op_MEM_lw)
    s_data_write = 2'b10;
    else 
    s_data_write = 2'b01;
end


//s_npc信号赋值
always @(op or funct) 
begin
    if(op == `op_J_beq)
      s_npc = 2'b00;
    else if(op == `op_J_j || op == `op_J_jal)
      s_npc = 2'b10;
    else if (op == `op_R && funct == `funct_jr)
      s_npc = 2'b01;
    else 
      s_npc = 2'b11;    
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
            default :aluop = `aluop_add;
        endcase
    else
        case(op)
            `op_I_addi: aluop = `aluop_add;
            `op_I_addiu: aluop = `aluop_addu;
            `op_I_andi: aluop = `aluop_and;
            `op_I_ori: aluop = `aluop_or;
            `op_I_lui: aluop = `aluop_lui;
            `op_MEM_sw: aluop = `aluop_add;
            `op_MEM_lw: aluop = `aluop_add;
            `op_J_beq: aluop = `aluop_sub;
            default: aluop = `aluop_add;
        endcase
end

endmodule