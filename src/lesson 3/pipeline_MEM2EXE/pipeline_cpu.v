module pipeline_cpu(clock,reset);

	input clock;
	input reset;

	wire [31:0] a;
	wire [31:0] b;
	wire [31:0] s;
	wire [31:0] c;
	
	wire [4:0] rs;
	wire [4:0] rt;
	wire [4:0] rd;
	
	wire [31:0] pc;
	wire [31:0] npc;
	wire [31:0] ins;
	
	wire [4:0] num_write;
	wire reg_write;
	
	wire s_b;
	wire ext;
	
	wire [3:0]aluop;
	wire [5:0]op;
	wire [5:0]funct;
	
	wire [15:0]imm_16;
	wire [31:0]extend;
	
	wire [31:0] data_in;
	wire [31:0] data_out;
	wire [31:0] address;
	wire [31:0] data_write;
	
	wire mem_write;
	wire zero0;
	
	wire [1:0] s_num_write;
	wire [1:0] s_data_write;
	wire [1:0] s_npc;
	
	wire [31:0] pc0;//beq_addr
	wire [31:0] pc1;//reg_addr
	wire [31:0] pc2;//abs_addr
	wire [31:0] pc3;//pc+4
	wire [31:0] jump_addr;
	
	wire [31:0] npc_IF_ID;
	
	wire [31:0] npc_ID_EXE;
	wire [31:0] a_ID_EXE;
	wire [31:0] b_ID_EXE;
	wire [31:0] imm_extend_ID_EXE;
	wire [3:0]aluop_ID_EXE;
	wire s_b_ID_EXE;
	wire mem_write_ID_EXE;
	wire reg_write_ID_EXE;
	wire [4:0] num_write_ID_EXE;
	wire [1:0] s_data_write_ID_EXE;
	
	wire [1:0] s_data_write_EXE_MEM;
	wire [4:0] num_write_EXE_MEM;
	wire [31:0] npc_EXE_MEM;
	wire [31:0] c_EXE_MEM;
	wire [31:0] b_EXE_MEM;
	wire mem_write_EXE_MEM;
	wire reg_write_EXE_MEM;
	
	wire [31:0] npc_MEM_WB;
	wire [31:0] c_MEM_WB;
	wire [31:0] data_out_MEM_WB;
	wire [4:0] num_write_MEM_WB;
	wire [1:0] s_data_write_MEM_WB;
	wire reg_write_MEM_WB;

	wire [31:0]ins_IF_ID;
	wire [31:0]ins_ID_EXE;
	wire [31:0]ins_EXE_MEM;
	wire [31:0]ins_MEM_WB;

	wire [1:0] FA;
	wire [1:0] FB;
	wire [31:0] F_OUT;
	wire [31:0] a1;	

	assign rs=ins_IF_ID[25:21];
	assign rt=ins_IF_ID[20:16];
	assign rd=ins_IF_ID[15:11];
	
	assign funct=ins_IF_ID[5:0];
	assign imm_16=ins_IF_ID[15:0];
	assign op=ins_IF_ID[31:26];
	
	assign pc1=a;
	assign pc3=pc+4;
	assign pc2={pc3[31:28],ins_IF_ID[25:0],2'b00};  //绝对跳转地址
	assign jump_addr=pc+4+(extend<<2);

	if_id IF_ID(clock,reset,ins_IF_ID,npc_IF_ID,ins,pc3);
	
	id_exe ID_EXE(clock,reset,npc_IF_ID,
npc_ID_EXE,a_ID_EXE,b_ID_EXE,imm_extend_ID_EXE,num_write_ID_EXE,s_b_ID_EXE,aluop_ID_EXE,mem_write_ID_EXE,s_data_write_ID_EXE,reg_write_ID_EXE,
a,b,extend,num_write,aluop,s_b,mem_write,s_data_write,reg_write,ins_IF_ID,ins_ID_EXE );

	exe_mem EXE_MEM(clock,reset,npc_ID_EXE,c,F_OUT,num_write_ID_EXE,mem_write_ID_EXE,s_data_write_ID_EXE,reg_write_ID_EXE,
npc_EXE_MEM,c_EXE_MEM,b_EXE_MEM,num_write_EXE_MEM,mem_write_EXE_MEM,s_data_write_EXE_MEM,reg_write_EXE_MEM,ins_ID_EXE,ins_EXE_MEM);

	mem_wb MEM_WB(clock,reset,npc_EXE_MEM,c_EXE_MEM,num_write_EXE_MEM,s_data_write_EXE_MEM,reg_write_EXE_MEM,
npc_MEM_WB,c_MEM_WB,data_out_MEM_WB,num_write_MEM_WB,s_data_write_MEM_WB,reg_write_MEM_WB,data_out,ins_EXE_MEM,ins_MEM_WB);

	forward FORWARD(ins_ID_EXE,num_write_EXE_MEM,num_write_MEM_WB,FA,FB);
	
	pc PC(pc,clock,reset,pc3);
	im IM(ins,pc);
	gpr GPR(a,b,clock,reg_write_MEM_WB,num_write_MEM_WB,rs,rt,data_write);
	alu ALU(c, a1, s, aluop_ID_EXE,zero0);
	dm DM(data_out,clock,mem_write_EXE_MEM,c_EXE_MEM,b_EXE_MEM);
	extend EXTEND(imm_16,ext,extend);
	ctrl CTRL(reg_write,mem_write,s_data_write,s_num_write,s_b,ext,aluop,op,funct,s_npc);
	
	mux0 #(5) MUX1(s_num_write,rt,rd,5'd31,num_write);  
	mux #(32) MUX2(s_b_ID_EXE,F_OUT,imm_extend_ID_EXE,s);
	mux0 #(32) MUX3(s_data_write_MEM_WB,npc_MEM_WB,c_MEM_WB,data_out_MEM_WB,data_write);

	mux0 #(32) MUX4(FA,c_EXE_MEM,c_MEM_WB,a_ID_EXE,a1);
	mux0 #(32) MUX5(FB,c_EXE_MEM,c_MEM_WB,b_ID_EXE,F_OUT);

endmodule