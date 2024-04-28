module s_cycle_cpu(clock,reset);
input clock;  //时钟信号
input reset;  //复位信号

wire [31:0] pc, npc, out_add_pc4, out_add_beq_offset;
wire [31:0] instruction;
wire [4:0] rs, rt, rd;

wire [31:0] a_gpr, b_gpr;//gpr模块的读数据值
wire [31:0] b_extend, b_extend2;

//ALU模块输出信号声明
wire [31:0] a, b, c;
wire zero;

//ctrl模块输出信号声明
wire reg_write, s_b, s_ext, mem_write;
wire [1:0] s_num_write, s_data_write, s_npc;


wire [31:0] beq_addr;

wire [4:0] num_write;
wire [31:0] data_write;
wire [31:0] data_in, data_out;
wire [31:0] address;
wire [3:0] aluop;
wire [5:0] op;
wire [5:0] funct;
wire [15:0] imm16;
wire [25:0] instr_index;

pc PC(pc, clock, reset, npc);
im IM(instruction, pc);
gpr GPR(a_gpr, b_gpr, clock, reg_write, num_write, rs, rt, data_write);
alu ALU(c, a, b, aluop, zero);
dm DM(data_out, clock, mem_write, address, data_in);
ctrl CTRL(aluop, op, reg_write, funct, s_num_write, s_b, s_ext, mem_write, s_data_write, s_npc);

mux33 #(5) MUX33_S_NUM_WRITE(num_write, s_num_write, rt, rd, 5'b11111);//写寄存器前的多选器
mux22 MUX22_S_B(b, s_b, b_gpr, b_extend);//ALU前的多选器，用于确定第二个输入是来自读数据2还是立即数扩展
mux33 MUX33_S_DATA_WRITE(data_write, s_data_write, out_add_pc4, c, data_out);//GPR写数据的多选器
mux44 MUX44_S_NPC(npc, s_npc, beq_addr, a_gpr, {out_add_pc4[31:28], instr_index, 2'b00}, out_add_pc4);
mux22 MUX22_BEQ_ADDR(beq_addr, zero, out_add_pc4, out_add_beq_offset);

add ADDPC4(out_add_pc4, pc, 4);
add ADD_BEQ_OFFSET(out_add_beq_offset, out_add_pc4, b_extend2);

extend EXTEND(b_extend, imm16, s_ext);

assign op = instruction[31:26];
assign rs = instruction[25:21];
assign rt = instruction[20:16];
assign rd = instruction[15:11];
assign funct = instruction[5:0];
assign imm16 = instruction[15:0];
assign instr_index = instruction[25:0];

assign a = a_gpr;
assign data_in = b_gpr;
assign address = c;

assign b_extend2 = b_extend << 2;

endmodule