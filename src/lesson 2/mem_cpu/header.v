//funct字段对应的ALU操作
`define funct_addu 6'b100001
`define funct_subu 6'b100011
`define funct_add  6'b100000
`define funct_and  6'b100100
`define funct_or   6'b100101
`define funct_slt  6'b101010

//aluop字段译码
`define aluop_addu 4'b0000
`define aluop_subu 4'b0001
`define aluop_add  4'b0010
`define aluop_and  4'b0011
`define aluop_or   4'b0100
`define aluop_slt  4'b0101
`define aluop_lui  4'b0110

//R型、I型指令op
`define op_R       6'b000000
`define op_I_addi  6'b001000
`define op_I_addiu 6'b001001
`define op_I_andi  6'b001100
`define op_I_ori   6'b001101
`define op_I_lui   6'b001111
//====新增===
`define op_MEM_sw  6'b101011
`define op_MEM_lw  6'b100011