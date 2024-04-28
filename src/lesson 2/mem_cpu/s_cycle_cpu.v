module s_cycle_cpu(clock,reset);
input clock;  //时钟信号
input reset;  //复位信号

wire [31:0] pc, npc;
wire [31:0] instruction;
wire [4:0] rs, rt, rd;

wire [31:0] a_gpr, b_gpr;//gpr模块的读数据值
wire [31:0] b_extend;

//ALU模块输出信号声明
wire [31:0] a, b, c;

//ctrl模块输出信号声明
wire reg_write, s_num_write, s_b, s_ext, mem_write, s_data_write;

wire [4:0] num_write;
wire [31:0] data_write;
wire [31:0] data_in, data_out;
wire [31:0] address;
wire [3:0] aluop;
wire [5:0] op;
wire [5:0] funct;
wire [15:0] imm16;

pc PC(pc, clock, reset, npc);
im IM(instruction, pc);
gpr GPR(a_gpr, b_gpr, clock, reg_write, num_write, rs, rt, data_write);
alu ALU(c, a, b, aluop);
dm DM(data_out, clock, mem_write, address, data_in);
ctrl CTRL(aluop, op, reg_write, funct, s_num_write, s_b, s_ext, mem_write, s_data_write);
extend EXTEND(b_extend, imm16, s_ext);

mux2 #(5) MUX2_NUM_WRITE(num_write, s_num_write, rt, rd);//写寄存器前的多选器
mux2 MUX2_S_B(b, s_b, b_gpr, b_extend);//ALU前的多选器，用于确定第二个输入是来自读数据2还是立即数扩展
mux2 MUX2_DATA_WRITE(data_write, s_data_write, c, data_out);//最后一个多选器

assign op = instruction[31:26];
assign rs = instruction[25:21];
assign rt = instruction[20:16];
assign rd = instruction[15:11];
assign funct = instruction[5:0];

assign imm16 = instruction[15:0];

assign address = c;
assign a=a_gpr;
assign data_in=b_gpr;

endmodule