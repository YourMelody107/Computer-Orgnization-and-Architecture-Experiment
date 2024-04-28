`define FUNCT_ADDU 6'b100001
`define FUNCT_SUBU 6'b100011
`define FUNCT_ADD  6'b100000
`define FUNCT_AND  6'b100100
`define FUNCT_OR   6'b100101
`define FUNCT_SLT  6'b101010

//指令JR
`define FUNCT_JR 6'b001000

`define OP_ADDI  6'b001000
`define OP_ADDIU 6'b001001
`define OP_ANDI  6'b001100
`define OP_ORI   6'b001101
`define OP_LUI   6'b001111
`define OP_SW    6'b101011
`define OP_LW    6'b100011

`define OP_J     6'b000010
`define OP_JAL   6'b000011
`define OP_BEQ   6'b000100

`define ADDU 4'b0001
`define SUBU 4'b0011
`define ADD  4'b0000
`define AND  4'b0100
`define OR   4'b0101
`define SLT  4'b1010
`define LUI  4'b1111
