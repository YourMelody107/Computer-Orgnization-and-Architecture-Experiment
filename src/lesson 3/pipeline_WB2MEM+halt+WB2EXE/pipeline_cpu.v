module pipeline_cpu(clock, reset);

	input clock,reset;
	wire [31:0] a_IF_ID,a_ID_EXE,b_IF_ID,b_ID_EXE,b_EXE_MEM,a,b,c_ID_EXE,c_EXE_MEM,c_MEM_WB;
	wire [31:0] num_imm_a,num_imm_b,data_write_ID_EXE,data_write_EXE_MEM,data_write_MEM_WB;
	wire [31:0] beq_addr,pc, npc,pc_4,ins_in,ins_out,a_0,b_0,rs_m,rt_m,data_in_m;
	wire [4:0] rs1,rs2, rt1,rt2,rt3,rt4, rd1, num_write1,num_write2,num_write3,num_write4;
	wire [3:0] aluop_a,aluop_b;
	wire [5:0] op, funct;
	wire reg_write_IF_ID,reg_write_ID_EXE,reg_write_EXE_MEM,reg_write_MEM_WB;
	wire ext1,s_b1,s_b_0,mem_write_IF_ID,mem_write_ID_EXE,mem_write_EXE_MEM,zero0,F,FA1,FB1;
	wire s_rt1, s_rt2, s_rt3,pc_write, IF_ID_write, clear_ID_EXE,s_lw1, s_lw2, s_lw3, s_lw4;
	wire [1:0] s_num_write1,s_data_write_IF_ID,s_data_write_ID_EXE,s_data_write_EXE_MEM,s_data_write_MEM_WB,FA,FB;

	assign rs1 = ins_out[25:21];
	assign rt1 = ins_out[20:16];
	assign rd1 = ins_out[15:11];
	assign op = ins_out[31:26];
	assign funct = ins_out[5:0];
	assign npc = pc + 4;

pc PC (pc,clock,reset,npc,pc_write);
im IM(ins_in,pc);
gpr GPR (a_IF_ID,b_IF_ID,clock,reg_write_MEM_WB,num_write4,rs1,rt1,data_write_MEM_WB);
alu ALU (c_ID_EXE,a_0,b,zero0,aluop_b);
ctrl CTRL(s_rt1,s_lw1,reg_write_IF_ID,aluop_a,s_num_write1,ext1,s_b1,mem_write_IF_ID,s_data_write_IF_ID,op,funct);

dm DM (data_write_ID_EXE,clock,mem_write_EXE_MEM,c_EXE_MEM,data_in_m);
extend EXTEND(ins_out[15:0],ext1,num_imm_a);

forward FORWARD(rs2,rt2,rs1,rt1,num_write3,num_write4,rt3,rt4,FA,FB,FA1,
FB1,F,reg_write_MEM_WB,reg_write_EXE_MEM);
detect DETECT (rs1, rt1,s_rt1, num_write2,pc_write,IF_ID_write, clear_ID_EXE, s_lw2);

if_id IF_ID(clock,reset,IF_ID_write,ins_in,ins_out);

id_exe ID_EXE(clock,reset,s_b1,s_data_write_IF_ID,mem_write_IF_ID,aluop_a,rs_m,rt_m,num_imm_a,reg_write_IF_ID,num_write1,rs1,rt1,clear_ID_EXE,
s_rt1,s_lw1,s_rt2,s_lw2,s_b_0,s_data_write_ID_EXE,mem_write_ID_EXE,aluop_b,a_ID_EXE,b_ID_EXE,num_imm_b,rs2,rt2,reg_write_ID_EXE,num_write2);

exe_mem EXE_MEM(clock,reset,s_data_write_ID_EXE,mem_write_ID_EXE,c_ID_EXE,b_0,rt2,reg_write_ID_EXE,num_write2,s_rt2,s_lw2,s_rt3,s_lw3,s_data_write_EXE_MEM,
mem_write_EXE_MEM,c_EXE_MEM,b_EXE_MEM,rt3,reg_write_EXE_MEM,num_write3);	
			   			   
mem_wb MEM_WB(clock,reset,s_data_write_EXE_MEM,c_EXE_MEM,data_write_ID_EXE,rt3,reg_write_EXE_MEM,num_write3,s_lw3,s_lw4,s_data_write_MEM_WB,c_MEM_WB,
data_write_EXE_MEM,rt4,reg_write_MEM_WB,num_write4);

mux0 #(5) MUX1 (num_write1,5'b11111,rd1,rt1,s_num_write1);
mux #(32) MUX2 (rs_m,a_IF_ID,data_write_MEM_WB,FA1);
mux #(32) MUX3 (rt_m,b_IF_ID,data_write_MEM_WB,FB1);
mux0 #(32) MUX4 (a_0,a_ID_EXE,data_write_MEM_WB,c_EXE_MEM,FA);
mux0 #(32) MUX5 (b_0,b_ID_EXE,data_write_MEM_WB,c_EXE_MEM,FB);
mux #(32) MUX6 (b,num_imm_b,b_0,s_b_0);
mux #(32) MUX7 (data_in_m,data_write_MEM_WB,b_EXE_MEM,F);
mux0 #(32) MUX8 (data_write_MEM_WB,pc+4,data_write_EXE_MEM,c_MEM_WB,s_data_write_MEM_WB);

endmodule
