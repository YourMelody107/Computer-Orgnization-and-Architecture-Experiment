`include "header.v"
module pipeline_cpu(clock, reset);
  input clock;
  input reset;

  wire [4:0] shamt_id, shamt_ex;
  wire [5:0] op;
  wire [4:0] rs;
  wire [4:0] rt;
  wire [4:0] rd;
  wire [15:0] imm;
  wire [31:0] imm_ext;
  wire [5:0] funct;

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
  wire mem_read_wb;

  wire [4:0] rs_ex;
  wire [4:0] rt_ex;
  wire [4:0] rd_ex;
  wire [31:0] data1_id;
  wire [31:0] data2_id;
  wire [31:0] data1_ex;
  wire [31:0] data2_ex;
  wire [31:0] data2_mem;
  wire [31:0] _1st_operand;
  wire [31:0] _2nd_operand;
  wire [31:0] _2nd_operand_temp;
  wire [31:0] mem_data_out_wb;
  wire [31:0] alu_result_wb;
  wire [31:0] data_write;
  wire [31:0] data_write_back_ex;
  wire [31:0]	data_write_back_mem;
  wire [31:0] alu_result_ex;
  wire [31:0] mem_data_out_mem;
  wire [31:0] abs_addr;
  wire [1:0] forwardA;
  wire [1:0] forwardB;
  wire pc_write;
  wire IF_ID_write;
  wire ID_EXE_flush;
  wire [1:0] forwardA_id;
  wire [1:0] forwardB_id;
  wire forwardB4;
  wire [31:0] data1_id_temp;
  wire [31:0] data2_id_temp;
  wire IF_ID_flush;
  wire zero_id;



  pc PC(.pc(pc),.clock(clock),.reset(reset),.npc(npc_if),.pc_write(pc_write));


  mux_4 #(.width(32))MUX_4_NPC_IF(.a(beq_addr),.b(data1_id_temp),.c(abs_addr),.d(pc+32'h00000004),.e(npc_if),.sel(s_npc_id));

  mux_2 #(.width(32))MUX_2_BEQ_ADDR(.a(pc+32'h00000004),.b((npc_id)+(imm_ext_id<<2)),.c(beq_addr),.sel(zero_id));

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
  assign funct=instruction_id[5:0];
  assign imm=instruction_id[15:0];
  assign shamt_id = instruction_id[10:6];

  ctrl CTRL(	.op(op),		.funct(funct),					.data1_id(data1_id),	.data2_id(data2_id),
             .aluop(aluop_id),
             .ext(ext_id),	.s_num_write(s_num_write_id),	.s_b(s_b_id),
             .mem_write(mem_write_id),						.reg_write(reg_write_id),
             .s_data_write(s_data_write_id),					.s_npc(s_npc_id)/*,.zero_id(zero_id)*/);


  mux_3 #(.width(32))MUX_3_DATA_WRITE(.a(npc_wb),.b(alu_result_wb),.c(mem_data_out_wb),.d(data_write),.sel(s_data_write_wb));
  gpr GPR(.a(data1_id_temp),	.b(data2_id_temp),	.clock(clock),
          .reg_write(reg_write_wb),		.num_write(num_write_wb),
          .rs(rs),		.rt(rt),		.data_write(data_write));

  extend ENTEND(.imm(imm),.ext(ext_id),.imm_out(imm_ext_id));

  hazard_check HAZARD_CHECK(	.num_write_ex(num_write_ex),
                             .rs(rs),						.rt(rt),
                             .mem_read_mem(mem_read_mem),       .mem_read_wb(mem_read_wb),	.op(op),
                             .pc_write(pc_write),			.funct(funct),
                             .a(data1_id),					.b(data2_id),
                             .alu_result_mem(alu_result_mem),.num_write_mem(num_write_mem), .num_write_wb(num_write_wb),
                             .IF_ID_write(IF_ID_write),		.ID_EXE_flush(ID_EXE_flush),
                             .IF_ID_flush(IF_ID_flush),.zero_id(zero_id));

  assign mem_read_ex=(op==`OP_LW);

  mux_3 #(.width(32))MUX_3_DATA1_ID(
          .a(data1_id_temp),	.b(data_write),
          .c(alu_result_mem),	.d(data1_id),
          .sel(forwardA_id));
  mux_3 #(.width(32))MUX_3_DATA2_ID(
          .a(data2_id_temp),	.b(data_write),
          .c(alu_result_mem),	.d(data2_id),
          .sel(forwardB_id));

  //EX
  id_ex ID_EX(.clock(clock),						.reset(reset),
              .npc_id(npc_id),					.data1_id(data1_id),
              .data2_id(data2_id),				.imm_ext_id(imm_ext_id),
              /*num_write_id,*/					.s_b_id(s_b_id),
              .aluop_id(aluop_id),				.s_data_write_id(s_data_write_id),
              .mem_write_id(mem_write_id),		.reg_write_id(reg_write_id),
              /*ext_id,*/							.s_npc_id(s_npc_id),
              .s_num_write_id(s_num_write_id),	.mem_read_id(mem_read_id),
              .rs_id(rs),
              .rt_id(rt),							.rd_id(rd),
              .shamt_id(shamt_id),
              .ID_EXE_flush(ID_EXE_flush),
              .npc_ex(npc_ex),					.data1_ex(data1_ex),
              .data2_ex(data2_ex),				.imm_ext_ex(imm_ext_ex),
              /*num_write_ex,*/					.s_b_ex(s_b_ex),
              .s_data_write_ex(s_data_write_ex),	.aluop_ex(aluop_ex),
              .mem_write_ex(mem_write_ex),		.reg_write_ex(reg_write_ex),
              /*ext_ex,*/							.s_npc_ex(s_npc_ex),
              .s_num_write_ex(s_num_write_ex),	.mem_read_ex(mem_read_ex),
              .rs_ex(rs_ex),
              .rt_ex(rt_ex),						.rd_ex(rd_ex),
              .shamt_ex(shamt_ex));


  mux_3 #(.width(5))MUX_3_NUM_WRITE_EX(.a(rt_ex),.b(rd_ex),.c(5'b11111),.d(num_write_ex),.sel(s_num_write_ex));

  bypass BYPASS(	.ex_mem_rd(num_write_mem),.mem_wb_rd(num_write_wb),
                 .id_ex_rs(rs_ex),.id_ex_rt(rt_ex),
                 .rs(rs),	.rt(rt),        .mem_rt(num_write_mem),
                 .reg_write_mem(reg_write_mem),.reg_write_wb(reg_write_wb),
                 .forwardA(forwardA),.forwardB(forwardB),
                 .forwardA_id(forwardA_id),.forwardB_id(forwardB_id), .forwardB4(forwardB4));

  mux_3 #(.width(32))MUX_3_1ST_OPPERAND(.a(data1_ex),.b(data_write),.c(alu_result_mem),.d(_1st_operand),.sel(forwardA));
  mux_3 #(.width(32))MUX_3_2ND_OPPERAND(.a(data2_ex),.b(data_write),.c(alu_result_mem),.d(_2nd_operand_temp),.sel(forwardB));
  assign _2nd_operand=(s_b_ex)?imm_ext_ex:_2nd_operand_temp;
  alu ALU(.c(alu_result_ex),.zero(zero_ex),.a(_1st_operand),.b(_2nd_operand),.ALUop(aluop_ex), .shamt(shamt_ex));
  assign data_write_back_ex=_2nd_operand_temp;

  //MEM
  ex_mem EX_MEM(	.clock(clock),						.reset(reset),
                 .npc_ex(npc_ex),					.zero_ex(zero_ex),
                 .alu_result_ex(alu_result_ex),		.data2_ex(data2_ex),
                 .num_write_ex(num_write_ex),		.mem_write_ex(mem_write_ex),
                 .s_data_write_ex(s_data_write_ex),	.reg_write_ex(reg_write_ex),
                 .s_npc_ex(s_npc_ex),				.mem_read_ex(mem_read_ex),
                 .data_write_back_ex(data_write_back_ex),
                 .npc_mem(npc_mem),					.zero_mem(zero_mem),
                 .alu_result_mem(alu_result_mem),	.data2_mem(data2_mem),
                 .num_write_mem(num_write_mem),		.mem_write_mem(mem_write_mem),
                 .s_data_write_mem(s_data_write_mem),.reg_write_mem(reg_write_mem),
                 .s_npc_mem(s_npc_mem),				.mem_read_mem(mem_read_mem),
                 .data_write_back_mem(data_write_back_mem));

  wire[31:0] data_in;
  assign data_in = forwardB4 ? data_write : data_write_back_mem;

  dm DM(.data_out(mem_data_out_mem),.clock(clock),.mem_write(mem_write_mem),.address(alu_result_mem),.data_in(data_in));

  //WB
  mem_wb MEM_WB(	.clock(clock),							.reset(reset),
                 .mem_write_mem(mem_write_mem),			.mem_read_mem(mem_read_mem),
                 .mem_data_out_mem(mem_data_out_mem),	.alu_result_mem(alu_result_mem),
                 .num_write_mem(num_write_mem),			.s_data_write_mem(s_data_write_mem),
                 .reg_write_mem(reg_write_mem),			.npc_mem(npc_mem),
                 .mem_data_out_wb(mem_data_out_wb),             .mem_read_wb(mem_read_wb),
                 .reg_write_wb(reg_write_wb),			.s_data_write_wb(s_data_write_wb),
                 .num_write_wb(num_write_wb),			.alu_result_wb(alu_result_wb),
                 .npc_wb(npc_wb));
endmodule
