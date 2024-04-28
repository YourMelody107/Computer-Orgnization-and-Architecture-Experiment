//pipline_cpu
module pipeline_cpu(clock,reset);

//输入端口
input clock;
input reset;

//if阶段
wire [31:0] pc;
reg [31:0]npc;//下条指令地址，
//实例化pc模块
pc PC(pc,clock,reset,npc);

reg [31:0] ins_memory[1023:0]; //4k指令存储器
wire [31:0] instruction;
//实例化im模块，
im IM(instruction,pc);

//实例化第一级流水线寄存器
wire [31:0] npc_out1;
wire [31:0] instruction_out;
wire if_id_write;
wire pc_write;
wire id_exe_flush;

if_id IF_ID(
			 npc,
			 npc_out1,
			 instruction,
			 instruction_out,
			 
			 clock,
			 reset,
			 if_id_write//if_id级流水线寄存器写使能信号
		     );

//id阶段			 
//产生控制信号
wire reg_write;//寄存器写控制信号
wire [3:0]aluop;
wire s_ext;
wire s_b;
wire s_numwrite;
wire mem_write;
wire [1:0] s_data_write;//控制写入寄存器的数据来源：0来自alu的结果输出，1来自存储器的数据读出端口

wire reg_write_out1;
wire reg_write_out2;
wire reg_write_out3;
/*
assign reg_write = 0;
assign aluop = 4'b0000;
assign s_ext = 0;
assign s_b = 0;
assign s_numwrite = 0;
assign s_data_write = 0;
*/
ctrl CTRL(reg_write,aluop,s_ext,s_b,s_numwrite,mem_write,s_data_write,instruction_out[31:26],instruction_out[5:0]);

wire [31:0]a;
wire [31:0]b;
wire [31:0]res;//alu的运算输出，
reg [31:0] gp_registers[31:0];  //32个寄存器

//实例化立即数拓展模块
wire [31:0] ext_imm;//立即数拓展模块的输出
extend EXTEND(s_ext,instruction_out[15:0],ext_imm);

//实例化GPR模块，注意写入数据的来源：加入二选一多路选择器
reg [4:0] num_write;
reg [31:0] c;
//选择num_write
always@(*)
begin
	case(s_numwrite)
	1://R型指令
	num_write = instruction_out[15:11];
	0://I型指令
	num_write = instruction_out[20:16];
	endcase
end
wire [4:0] num_write_out3;
gpr GPR(a,b,clock,reg_write_out3,num_write_out3,instruction_out[25:21],instruction_out[20:16],c);

//实例化第二级流水线寄存器
wire [31:0] npc_out2;
wire [31:0] a_out;
wire [31:0] b_out;
wire [31:0] ext_imm_out;
wire [4:0] num_write_out;
wire [1:0] s_data_write_out;
wire s_b_out;
wire [3:0] aluop_out;
wire mem_write_out;
wire id_exe_write;
wire [31:0] instruction_out2;
assign id_exe_write = 1;		
id_exe ID_EXE(
			 //传输的数据
			 npc_out1,
			 npc_out2,
			 a,
			 a_out,
			 b,
			 b_out,
			 ext_imm,
			 ext_imm_out,
			 num_write,
			 num_write_out,
			 //传输的控制信号
			 s_data_write,
			 s_data_write_out,
			 s_b,
			 s_b_out,
			 aluop,
			 aluop_out,
			 mem_write,
			 mem_write_out,
			 reg_write,
			 reg_write_out1,
			 instruction_out,
			 instruction_out2,
			 clock,
			 reset,//同步低电平有效
			 id_exe_write,//id_exe级流水线寄存器写使能信号
			 id_exe_flush
			 );
	 
//exe阶段
//实例化ALU模块，根据s_b信号选择第二个数据来源
reg [31:0] data1;
reg [31:0] data2;//ALU的第二个操作数
reg [31:0] data3;
always@(*)
begin
	case(s_b_out)
	0://R型指令
	data2 = data3;
	1://I型指令以及MEM指令
	data2 = ext_imm_out;
	endcase
end
alu ALU(res,data1,data2,aluop_out);	

//实例化第三级流水线寄存器
wire [31:0] npc_out3;
wire [31:0] res_out;
wire [31:0] b_out2;
wire [4:0] num_write_out2;
wire mem_write_out2;
wire [1:0] s_data_write_out2;
wire exe_mem_write;
wire [31:0] instruction_out3;
assign exe_mem_write = 1;
exe_mem EXE_MEM(
			   //数据传送
			   npc_out2,
			   npc_out3,
			   res,
			   res_out,
			   b_out,
			   b_out2,
			   num_write_out,
			   num_write_out2,
			   //控制信号传送
			   mem_write_out,
			   mem_write_out2,
			   s_data_write_out,
			   s_data_write_out2,
			   reg_write_out1,
			   reg_write_out2,
			   instruction_out2,
			   instruction_out3,
			   clock,
			   reset,
			   exe_mem_write
			   );		 
//冒险检测模块
check CHECK(
			 pc_write,
			 if_id_write,
			 id_exe_flush,
			 instruction_out2,
			 instruction_out
			 );
			 
//mem阶段
//实例化dm模块
wire [31:0] data_out;//dm模块的数据输出端
reg [31:0] data_memory[1023:0]; //4K数据存储器
//sw指令中写的数据是gpr中的GPR[rt]
dm DM(data_out,clock,mem_write_out2,res_out,b_out2); 
//实例化第四级流水线寄存器
wire [31:0] npc_out4;
wire [31:0] res_out2;
wire [31:0] mem_data_out_out;

wire [1:0] s_data_write_out3;
wire mem_wb_write;
assign mem_wb_write = 1;
wire [31:0] instruction_out4;
mem_wb MEM_WB(
			  //传输数据
			  npc_out3,
			  npc_out4,
			  res_out,
			  res_out2,
			  data_out,
			  mem_data_out_out,
			  num_write_out2,
			  num_write_out3,
			  //传输控制信号
			  s_data_write_out2,
			  s_data_write_out3,
			  reg_write_out2,
			  reg_write_out3,
			  instruction_out3,
			  instruction_out4,
			  clock,
			  reset,
			  mem_wb_write
			  );

//产生s_forwardA、s_forwardB信号
reg [1:0] s_forwardA;
reg [1:0] s_fA;
always@(*)

begin
//二级冒险
if(instruction_out4[31:26] == 6'b000000 && instruction_out4[31:26] != 101011)
begin
	if(instruction_out4[15:11] == instruction_out2[25:21])
		s_forwardA = 1;
	else
		s_forwardA = 2;
end
else if(instruction_out4[31:26] != 6'b000000 && instruction_out4[31:26] != 101011)
begin
	if(instruction_out4[20:16] == instruction_out2[25:21])
		s_forwardA = 1;
	else
		s_forwardA = 2;
end
//一级冒险
if(instruction_out3[31:26] == 6'b000000 && instruction_out3[31:26] != 101011)
begin
	if(instruction_out3[15:11] == instruction_out2[25:21])
		s_fA = 0;
	else 
		s_fA = 2;
end
else if(instruction_out3[31:26] != 6'b000000 && instruction_out3[31:26] != 101011)
begin
	if(instruction_out3[20:16] == instruction_out2[25:21])
		s_fA = 0;
	else
		s_fA = 2;
end
if(s_fA == 0)
s_forwardA = s_fA;
end

reg [1:0] s_forwardB;
reg [1:0] s_fB;
always@(*)
begin
//二级冒险
if(instruction_out4[31:26] == 6'b000000 && instruction_out4[31:26] != 101011)
begin
	if(instruction_out4[15:11] == instruction_out2[20:16])
		s_forwardB = 1;
	else
		s_forwardB = 2;
end
else if(instruction_out4[31:26] != 6'b000000 && instruction_out4[31:26] != 101011)
begin
	if(instruction_out4[20:16] == instruction_out2[20:16])
		s_forwardB = 1;
	else
		s_forwardB = 2;
end
//一级冒险
if(instruction_out3[31:26] == 6'b000000 && instruction_out3[31:26] != 101011)
begin
	if(instruction_out3[15:11] == instruction_out2[20:16])
		s_fB = 0;
	else
		s_fB = 2;
end
else if(instruction_out3[31:26] != 6'b000000 && instruction_out3[31:26] != 101011)
begin
	if(instruction_out3[20:16] == instruction_out2[20:16])
		s_fB = 0;
	else
		s_fB = 2;
end
if(s_fB == 0)
s_forwardB = s_fB;
end


//根据旁路信号选择进入alu的数据来源
always@(*)
begin
	if(s_forwardA == 0)
		data1 = res_out;
	else if(s_forwardA == 1)
		data1 = c;
	else
		data1 = a_out;
end
always@(*)
begin
	if(s_forwardB == 0)
		data3 = res_out;
	else if(s_forwardB == 1)
		data3 = c;
	else
		data3 = b_out;
end
//根据s_data_write_out3选择写进寄存器堆的数据来源
always@(*)
begin
	case(s_data_write_out3)
	0:
	c = res_out2;
	1:
	c = mem_data_out_out;
	 
	endcase
end

//npc逻辑,在pc取到新值发生改变后，npc就要跟着变
always@(*)
begin
if(pc_write)
	npc = pc + 4;
else
	npc = pc;
end
 

endmodule



