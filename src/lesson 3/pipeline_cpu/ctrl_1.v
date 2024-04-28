//加入I型指令的控制模块
module ctrl(reg_write,aluop,s_ext,s_b,s_numwrite,mem_write,s_data_write,op,funct);
`define ADDU 6'B100001
`define SUBU 6'B100011
`define ADD 6'B100000
`define AND 6'B100100
`define OR 6'B100101
`define SLT 6'B101010 
`define ADDI 6'b001000
`define ADDIU 6'b001001
`define ANDI 6'b001100
`define ORI 6'b001101
`define LUI 6'b001111
`define R 6'b000000
`define SW 6'b101011
`define LW 6'b100011
`define SLL 6'b000000
//数据端口
input [5:0]funct;
input [5:0]op;//这两个端口，用instruction里面的对应位置
output reg reg_write;//除了SW指令不写寄存器，其他都写寄存器
output reg s_ext;//1是符号扩展，0是零拓展
output reg s_b;//选择ALU的b端口数据来源
output reg s_numwrite;//选择GPR写寄存器的号数来源：0写到rt，1写到rd。这里，写入的数据还没有变化，一直都是alu的输出
output reg [3:0]aluop;//选择输出alu的运算结果，根据funct产生
output reg [1:0] s_data_write;//选择存进寄存器的数据：0来自ALU的运算结果；1来自存储器的数据输出
output reg mem_write;

//产生aluop信号
always@(*)
begin
	case(op)
	`R:
	begin
		case(funct)
		`ADDU:
			aluop = 0;
		`SUBU:
			aluop = 1;
		`ADD:
			aluop = 2;
		`AND:
			aluop = 3;
		`OR:
			aluop = 4;
		`SLT:
			aluop = 5;
		`SLL:
			aluop = 13;
		endcase
	end
	`ADDI:
		aluop = 6;
	`ADDIU:
		aluop = 7;
	`ANDI:
		aluop = 8;
	`ORI:
		aluop = 9;
	`LUI:
		aluop = 10;
	`SW:
		aluop = 11;
	`LW:
		aluop = 12;
	endcase
end

//产生s_ext信号
always@(*)
begin
	case(op)
	`ADDI,
	`ADDIU,
	`LW,
	`SW:
		s_ext = 1;
	`ANDI,
	`ORI:
		s_ext = 0;
	default:
		s_ext = 0;
	endcase
end

//产生s_b信号
always@(*)
begin
	case(op)
	`R:
		s_b = 0;
	`ADDI,
	`ADDIU,
	`ANDI,
	`ORI,
	`SW,
	`LW,
	`LUI:
		s_b = 1;
	default:
		s_b = 0;
	endcase
end

//产生s_numwrite信号
always@(*)
begin
	case(op)
	`R://R型指令写到rd
	s_numwrite = 1;
	default://I型指令写到rt，实参来自于指令
	s_numwrite = 0;
	endcase
end

//产生reg_write信号
always@(*)
begin
	case(op)
	`SW:
	reg_write = 0;
	default:
	reg_write = 1;
	endcase
end

//产生s_data_write信号
always@(*)
begin
	case(op)
	`LW:
	s_data_write = 1;
	default:
	s_data_write = 0;
	endcase
end

//产生mem_wirte信号
always@(*)
begin
	case(op)
	`SW://只有SW指令写数据，其余都不写
	mem_write = 1;
	default:
	mem_write = 0;
	endcase
end
endmodule


