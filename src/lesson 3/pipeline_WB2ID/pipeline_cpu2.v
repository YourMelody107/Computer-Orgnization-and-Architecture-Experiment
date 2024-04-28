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
	
	wire [3:0] aluop;
	wire [5:0] op;
	wire [5:0] funct;
	
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
	
	wire [31:0]pc0;//beq_addr
	wire [31:0]pc1;//reg_addr
	wire [31:0] pc2;//abs_addr
	wire [31:0] pc3;//pc+4
	wire [31:0] jump_addr;


	wire [31:0] ins_IF_ID;
	wire [31:0] npc_IF_ID;
	
	wire [31:0] npc_ID_EXE;
	wire [31:0] a_ID_EXE;
	wire [31:0] b_ID_EXE;
	wire [31:0] extend_ID_EXE;
	wire [31:0] ins_ID_EXE;
	wire [4:0] num_write_ID_EXE;
	wire s_b_ID_EXE;
	wire mem_write_ID_EXE;
	wire reg_write_ID_EXE;
	wire w_IF_ID;
	wire clear_ID_EXE;
	wire [1:0] s_data_write_ID_EXE;
	wire [3:0] aluop_ID_EXE;
	
	wire [31:0] npc_EXE_MEM;
	wire [31:0] c_EXE_MEM;
	wire [31:0] b_EXE_MEM;
	wire [31:0] ins_EXE_MEM;
	wire [4:0] num_write_EXE_MEM;
	wire mem_write_EXE_MEM;
	wire reg_write_EXE_MEM;
	wire [1:0] s_data_write_EXE_MEM;
	
	wire [31:0] npc_MEM_WB;
	wire [31:0] c_MEM_WB;
	wire [31:0] data_out_MEM_WB;
	wire [31:0] ins_MEM_WB;
	wire [4:0] num_write_MEM_WB;
	wire reg_write_MEM_WB;
	wire [1:0] s_data_write_MEM_WB;
	
	wire w;
	
	wire [31:0] a1;
	wire [31:0] a_0;
	wire [31:0] b_0;
	
	wire FA;
	wire FB;
	wire [31:0] F_OUT;

	wire [1:0] FA2;
	wire [1:0] FB2;
	
	assign rd=ins_IF_ID[15:11];
	assign rs=ins_IF_ID[25:21];
	assign rt=ins_IF_ID[20:16];

	assign imm_16=ins_IF_ID[15:0];
	assign op=ins_IF_ID[31:26];
	assign funct=ins_IF_ID[5:0];

	assign pc1=a;	
	assign pc3=pc+4;
	assign pc2={pc3[31:28],ins_IF_ID[25:0],2'b00};
	
	assign jump_addr=pc+4+(extend<<2);

	if_id IF_ID_REG(clock,reset,ins,pc3,ins_IF_ID,npc_IF_ID,w_IF_ID);
	
	id_exe ID_EXE_REG(clock,reset,npc_IF_ID,a_0,b_0,extend,num_write,aluop,s_b,mem_write,s_data_write,reg_write,ins_IF_ID,clear_ID_EXE,
npc_ID_EXE,a_ID_EXE,b_ID_EXE,extend_ID_EXE,num_write_ID_EXE,s_b_ID_EXE,aluop_ID_EXE,mem_write_ID_EXE,s_data_write_ID_EXE,reg_write_ID_EXE,ins_ID_EXE );

	exe_mem EXE_MEM_REG(clock,reset,npc_ID_EXE,c,F_OUT,num_write_ID_EXE,mem_write_ID_EXE,s_data_write_ID_EXE,reg_write_ID_EXE,ins_ID_EXE,
npc_EXE_MEM,c_EXE_MEM,b_EXE_MEM,num_write_EXE_MEM,mem_write_EXE_MEM,s_data_write_EXE_MEM,reg_write_EXE_MEM,ins_EXE_MEM);

	mem_wb MEM_WB_REG(clock,reset,npc_EXE_MEM,c_EXE_MEM,data_out,num_write_EXE_MEM,s_data_write_EXE_MEM,reg_write_EXE_MEM,ins_EXE_MEM,
npc_MEM_WB,c_MEM_WB,data_out_MEM_WB,num_write_MEM_WB,s_data_write_MEM_WB,reg_write_MEM_WB,ins_MEM_WB);

	forward FORWARD_CTRL(ins_IF_ID,ins_ID_EXE,num_write_EXE_MEM,num_write_MEM_WB,FA2,FB2,FA,FB);
	
	detect HAZARD_DETECTION(aluop_ID_EXE,num_write_ID_EXE,ins_IF_ID,w,w_IF_ID,clear_ID_EXE);

	pc PC(pc,clock,reset,pc3,w);
	im IM(ins,pc);
	gpr GPR(a,b,clock,reg_write_MEM_WB,num_write_MEM_WB,rs,rt,data_write);
	alu ALU(c, a1, s, aluop_ID_EXE,zero0);
	extend EXTEND(imm_16,ext,extend);
	dm DM(data_out,clock,mem_write_EXE_MEM,c_EXE_MEM,b_EXE_MEM);
	ctrl CTRL(reg_write,mem_write,s_data_write,s_num_write,s_b,ext,aluop,op,funct,s_npc);

	mux0 #(5) MUX1(s_num_write,rt,rd,5'd31,num_write);  
	mux #(32) MUX2(s_b_ID_EXE,F_OUT,extend_ID_EXE,s);

	mux0 #(32) MUX3(s_data_write_MEM_WB,npc_MEM_WB,c_MEM_WB,data_out_MEM_WB,data_write);
	mux1 #(32) MUX4(s_npc,pc0,pc1,pc2,pc+4,npc);
	mux #(32) MUX5(zero0,pc+4,jump_addr,pc0);

	mux0 #(32) MUX6(FA2,c_EXE_MEM,data_write,a_ID_EXE,a1);
	mux0 #(32) MUX7(FB2,c_EXE_MEM,data_write,b_ID_EXE,F_OUT);

	mux #(32) MUX8(FA,data_write,a,a_0);
	mux #(32) MUX9(FB,data_write,b,b_0);

endmodule