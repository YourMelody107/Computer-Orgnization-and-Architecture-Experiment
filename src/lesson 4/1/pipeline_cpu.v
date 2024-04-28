`include "header.v"
module pipeline_cpu(clock, reset);
	input clock;
	input reset;
	
	wire [5:0] op;
	wire [4:0] rs;
	wire [4:0] rt;
	wire [4:0] rd;
	wire [15:0] imm;
	wire [31:0] imm_ext;
	wire [5:0] funct;
	wire [4:0] shamt;
	
	wire [31:0] instruction_if;
	wire [31:0] instruction_id;
	
	wire [31:0] pc;
	wire [31:0] npc;
	wire [31:0] npc_if;
	wire [31:0] npc_id;
	wire [31:0] npc_ex;
	wire [31:0] npc_mem;
	wire [31:0] npc_wb;
	wire [31:0] beq_addr;
	wire s_npc;
	wire [1:0] s_npc_id;
	wire [1:0] s_npc_ex;
	wire [1:0] s_npc_mem;
	
	wire [3:0] aluop_id;
	wire [3:0] aluop_ex;
	wire ext_id;
	wire [1:0] s_num_write_id;
	wire s_b_id;
	wire s_a_id;
	wire mem_write_id;
	wire reg_write_id;
	wire reg_write_wb;
	wire [4:0] num_write_wb;
	wire [1:0] s_data_write_id;
	wire [1:0] s_data_write_wb;
	wire [31:0] imm_ext_id;
	wire mem_read_id;
	wire [31:0] imm_ext_ex;
	wire s_b_ex;
	wire s_a_ex;
	wire [1:0] s_data_write_ex;
	wire mem_write_ex;
	wire reg_write_ex;
	wire [1:0] s_num_write_ex;
	wire mem_read_ex;
	wire zero_ex;
	wire zero_mem;
	wire [31:0] alu_result_mem;
	wire [4:0] num_write_mem;
	wire [4:0] num_write_ex;
	wire mem_write_mem;
	wire [1:0] s_data_write_mem;
	wire reg_write_mem;
	wire mem_read_mem;
	
	wire [4:0] rs_ex;
	wire [4:0] rt_ex;
	wire [4:0] rd_ex;
	wire [31:0] data1_id;
	wire [31:0] data2_id;
	wire [31:0] data1_ex;
	wire [31:0] data2_ex;
	wire [31:0] data2_mem;
	wire [31:0] _1st_operand;
	wire [31:0] _1st_operand_temp;
	wire [31:0] _2nd_operand;
	wire [31:0] _2nd_operand_temp;
	wire [31:0] mem_data_out_wb;
	wire [31:0] alu_result_wb;
	wire [31:0] data_write;
	wire [31:0] data_write_back;
	wire [31:0] alu_result_ex;
	wire [31:0] mem_data_out_mem;
	wire [31:0] abs_addr;
	wire [1:0] forwardA;
	wire [1:0] forwardB;
	wire pc_write;
	wire IF_ID_write;
	wire ID_EXE_flush;
	wire forwardA_id;
	wire forwardB_id;
	wire [31:0] data1_id_temp;
	wire [31:0] data2_id_temp;
	wire IF_ID_flush;
	wire [4:0]s_shamt_id;
	wire [4:0]s_shamt_ex;

	//IF
	// mux_2 #(.width(32))MUX_2_NPC(.a(pc+32'h00000004),.b(pc+32'h00000004),.c(npc_if),.sel(s_npc_mem));
	pc PC(.pc(pc),.clock(clock),.reset(reset),.npc(npc_if),.pc_write(pc_write));
	
	// assign npc_if=	(s_npc_mem==2'b00)?	beq_addr:
					// (s_npc_mem==2'b01)?	data1_ex:
					// (s_npc_mem==2'b10)?	abs_addr:
										// pc+32'h00000004;
	mux_4 #(.width(32))MUX_4_NPC_IF(.a(beq_addr),.b(data1_id_temp),.c(abs_addr),.d(pc+32'h0000_0004),.e(npc_if),.sel(s_npc_id));	
	// assign npc_if=pc+32'h00000004;
	
	// assign beq_addr=(zero_mem)?((pc+32'h00000004)+(imm_ext_ex<<2)):pc+32'h00000004;
	mux_2 #(.width(32))MUX_2_BEQ_ADDR(.a((pc+32'h0000_0004)+(imm_ext_ex<<2)),.b(pc+32'h0000_0004),.c(beq_addr),.sel(zero_mem));
	
	assign abs_addr={pc[31:28],instruction_id[25:0],2'b00};
	
	im IM(.instruction(instruction_if),.pc(pc));
	
	//ID
	if_id IF_ID(.clock(clock),				.reset(reset),
				.npc_if(npc_if),			.instruction_if(instruction_if),
				.if_id_write(IF_ID_write),	.if_id_flush(IF_ID_flush),
				.npc_id(npc_id),			.instruction_id(instruction_id));

	assign op=instruction_id[31:26];
	assign rs=instruction_id[25:21];
	assign rt=instruction_id[20:16];
	assign rd=instruction_id[15:11];
	assign shamt = instruction_id[10:6];
	assign funct=instruction_id[5:0];
	assign imm=instruction_id[15:0];

	ctrl CTRL(	.op(op),		.funct(funct),.shamt(shamt),.s_shamt_id(s_shamt_id),					.aluop(aluop_id),
				.ext(ext_id),	.s_num_write(s_num_write_id),	.s_b(s_b_id),
				.mem_write(mem_write_id),						.reg_write(reg_write_id),
				.s_data_write(s_data_write_id),					.s_npc(s_npc_id),.s_a(s_a_id));
													
	mux_3 #(.width(32))MUX_3_DATA_WRITE(.a(npc_wb),.b(alu_result_wb),.c(mem_data_out_wb),.d(data_write),.sel(s_data_write_wb));					
	gpr GPR(.a(data1_id_temp),	.b(data2_id_temp),	.clock(clock),	
			.reg_write(reg_write_wb),		.num_write(num_write_wb),
			.rs(rs),		.rt(rt),		.data_write(data_write));
	
	extend ENTEND(.imm(imm),.ext(ext_id),.imm_out(imm_ext_id));
	
	hazard_check HAZARD_CHECK(	.num_write_ex(num_write_ex),
								.rs(rs),						.rt(rt),
								.mem_read_mem(mem_read_mem),	.op(op),	
								.pc_write(pc_write),			.funct(funct),
								.IF_ID_write(IF_ID_write),		.ID_EXE_flush(ID_EXE_flush),
								.IF_ID_flush(IF_ID_flush));
	
	assign mem_read_ex=(op==`OP_LW);
	assign data1_id=(forwardA_id)?alu_result_wb:data1_id_temp;
	assign data2_id=(forwardB_id)?alu_result_wb:data2_id_temp;

	//EX
	id_ex ID_EX(.clock(clock),						.reset(reset),
				.npc_id(npc_id),					.data1_id(data1_id),
				.data2_id(data2_id),				.imm_ext_id(imm_ext_id),
				/*num_write_id,*/					.s_b_id(s_b_id),.s_a_id(s_a_id),.s_shamt_id(s_shamt_id),
				.aluop_id(aluop_id),				.s_data_write_id(s_data_write_id),
				.mem_write_id(mem_write_id),		.reg_write_id(reg_write_id),
				/*ext_id,*/							.s_npc_id(s_npc_id),
				.s_num_write_id(s_num_write_id),	.mem_read_id(mem_read_id),
				.rs_id(rs),
				.rt_id(rt),							.rd_id(rd),
				.ID_EXE_flush(ID_EXE_flush),
				.npc_ex(npc_ex),					.data1_ex(data1_ex),.s_shamt_ex(s_shamt_ex),
				.data2_ex(data2_ex),				.imm_ext_ex(imm_ext_ex),
				/*num_write_ex,*/					.s_b_ex(s_b_ex),.s_a_ex(s_a_ex),
				.s_data_write_ex(s_data_write_ex),	.aluop_ex(aluop_ex),
				.mem_write_ex(mem_write_ex),		.reg_write_ex(reg_write_ex),
				/*ext_ex,*/							.s_npc_ex(s_npc_ex),
				.s_num_write_ex(s_num_write_ex),	.mem_read_ex(mem_read_ex),
				.rs_ex(rs_ex),
				.rt_ex(rt_ex),						.rd_ex(rd_ex));
				

	mux_3 #(.width(5))MUX_3_NUM_WRITE_EX(.a(rt_ex),.b(rd_ex),.c(5'b11111),.d(num_write_ex),.sel(s_num_write_ex));
	
	bypass BYPASS(	.ex_mem_rd(num_write_mem),.mem_wb_rd(num_write_wb),
					.id_ex_rs(rs_ex),.id_ex_rt(rt_ex),
					.rs(rs),					.rt(rt),
					.reg_write_mem(reg_write_mem),.reg_write_wb(reg_write_wb),
					.forwardA(forwardA),.forwardB(forwardB),
					.forwardA_id(forwardA_id),.forwardB_id(forwardB_id));
					
	mux_3 #(.width(32))MUX_3_1ST_OPPERAND(.a(data1_ex),.b(data_write),.c(alu_result_mem),.d(_1st_operand_temp),.sel(forwardA));
	mux_3 #(.width(32))MUX_3_2ND_OPPERAND(.a(data2_ex),.b(data_write),.c(alu_result_mem),.d(_2nd_operand_temp),.sel(forwardB));
	assign _2nd_operand=(s_b_ex)?imm_ext_ex:_2nd_operand_temp;
	alu ALU(.c(alu_result_ex),.zero(zero_ex),.a(_1st_operand_temp),.b(_2nd_operand),.ALUop(aluop_ex),.d(s_shamt_ex));
	
	//MEM
	ex_mem EX_MEM(	.clock(clock),						.reset(reset),
					.npc_ex(npc_ex),					.zero_ex(zero_ex),
					.alu_result_ex(alu_result_ex),		.data2_ex(data2_ex),
					.num_write_ex(num_write_ex),		.mem_write_ex(mem_write_ex),
					.s_data_write_ex(s_data_write_ex),	.reg_write_ex(reg_write_ex),
					.s_npc_ex(s_npc_ex),				.mem_read_ex(mem_read_ex),
					.npc_mem(npc_mem),					.zero_mem(zero_mem),
					.alu_result_mem(alu_result_mem),	.data2_mem(data2_mem),
					.num_write_mem(num_write_mem),		.mem_write_mem(mem_write_mem),
					.s_data_write_mem(s_data_write_mem),.reg_write_mem(reg_write_mem),
					.s_npc_mem(s_npc_mem),				.mem_read_mem(mem_read_mem));
	
	assign data_write_back=data2_mem;	
	dm DM(.data_out(mem_data_out_mem),.clock(clock),.mem_write(mem_write_mem),.address(alu_result_mem),.data_in(data_write_back));
	
	//WB
	mem_wb MEM_WB(	.clock(clock),							.reset(reset),
					.mem_write_mem(mem_write_mem),			
					.mem_data_out_mem(mem_data_out_mem),	.alu_result_mem(alu_result_mem),
					.num_write_mem(num_write_mem),			.s_data_write_mem(s_data_write_mem),
					.reg_write_mem(reg_write_mem),			.npc_mem(npc_mem),
					.mem_data_out_wb(mem_data_out_wb),
					.reg_write_wb(reg_write_wb),			.s_data_write_wb(s_data_write_wb),
					.num_write_wb(num_write_wb),			.alu_result_wb(alu_result_wb),
					.npc_wb(npc_wb));
endmodule