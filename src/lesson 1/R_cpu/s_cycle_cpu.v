module s_cycle_cpu(clock,reset);

//输入

input clock;
input reset;

wire [31:0] pc,npc;
wire reg_write=1;//control不写的话默认是1
wire [4:0] rs,rt,num_write;
wire [31:0] instruction,a,b,c,data_write;
wire [3:0] aluop;
wire [5:0] op,funct;

//模块实例化
  pc PC(pc,clock,reset,npc);
  im IM(instruction,pc);
  gpr GPR(a,b,clock,reg_write,num_write,rs,rt,data_write);
  alu ALU(c,a,b,aluop);
  ctrl CTRL(aluop,op,funct);

//给各个wire赋值
assign npc=pc+4;

assign op=instruction[31:26];
assign rs=instruction[25:21];
assign rt=instruction[20:16];
assign num_write=instruction[15:11];
assign funct=instruction[5:0];

assign data_write=c;

endmodule