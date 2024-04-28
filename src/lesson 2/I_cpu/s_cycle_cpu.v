module s_cycle_cpu(clock,reset);

//输入

input clock;
input reset;

wire [31:0] pc,npc;
wire reg_write=1;//control不写的话默认是1
wire [4:0] rs,rt,num_write,rd;
wire [31:0] instruction,a,b,c,data_write,rb;
wire [3:0] aluop;
wire [5:0] op,funct;
wire [15:0] imm; //扩展前
wire [31:0] imm_i; //扩展后
wire s_num_write,s_ext,s_b;

//模块实例化
  pc PC(pc,clock,reset,npc);
  im IM(instruction,pc);
  gpr GPR(.a(a),.b(rb),.rs(rs),.rt(rt),.num_write(num_write),.data_write(c),.reg_write(reg_write),.clock(clock));
  alu ALU(c,a,b,aluop);
  ctrl CTRL(aluop,op,funct,s_ext,s_num_write,s_b);
  ext EXT(imm,s_ext,imm_i);

//给各个wire赋值
assign npc=pc+4;

assign op=instruction[31:26];
assign rs=instruction[25:21];
assign rt=instruction[20:16];
assign rd=instruction[15:11];
assign funct=instruction[5:0];
assign imm=instruction[15:0];

assign num_write=s_num_write?rd:rt;
assign b=s_b?imm_i:rb;

endmodule