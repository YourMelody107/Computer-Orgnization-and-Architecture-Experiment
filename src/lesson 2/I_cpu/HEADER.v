//op
`define OP_R  6'b000000
`define opaddi 6'b001000
`define opaddiu 6'b001001
`define opandi  6'b001100
`define opori  6'b001101
`define oplui  6'b001111

//funct
`define FUNCT_ADDU 6'b100001
`define FUNCT_SUBU 6'b100011
`define FUNCT_ADD  6'b100000
`define FUNCT_AND  6'b100100
`define FUNCT_OR   6'b100101
`define FUNCT_SLT  6'b101010

//aluop
`define add 4'b0000
`define sub 4'b0001
`define and 4'b0010
`define or  4'b0011
`define slt 4'b0100
`define lui 4'b0101