module id_ex(clock,				reset,
			npc_id,				data1_id,
			data2_id,			imm_ext_id,
			/*num_write_id,*/		s_b_id,s_a_id,
			aluop_id,			s_data_write_id,
			mem_write_id,		reg_write_id,
			/*ext_id,*/				s_npc_id,
			s_num_write_id,		mem_read_id,
			rs_id,s_shamt_ex,s_shamt_id,
			rt_id,				rd_id,
			ID_EXE_flush,
			npc_ex,				data1_ex,
			data2_ex,			imm_ext_ex,
			/*num_write_ex,*/		s_b_ex,s_a_ex,
			s_data_write_ex,	aluop_ex,
			mem_write_ex,		reg_write_ex,
			/*ext_ex,*/				s_npc_ex,
			s_num_write_ex,		mem_read_ex,
			rs_ex,
			rt_ex,				rd_ex);
			
	input clock;
	input reset;
	input [31:0] 	npc_id;
	input [31:0] 	data1_id;
	input [31:0] 	data2_id;
	input [31:0] 	imm_ext_id;
	// input [4:0] 	num_write_id;
	input			s_b_id;
	input s_a_id;
	input [1:0] 	s_data_write_id;
	input [3:0] 	aluop_id;
	input 			mem_write_id;
	input 			reg_write_id;
	// input 		ext_id;
	input [1:0]		s_npc_id;
	input [1:0]		s_num_write_id;
	input 			mem_read_id;
	input [4:0]		rs_id;
	input [4:0]		rt_id;
	input [4:0]		rd_id;
	input 			ID_EXE_flush;
	input[4:0]      s_shamt_id;

	output reg [31:0] 	npc_ex;
	output reg [31:0] 	data1_ex;
	output reg [31:0] 	data2_ex;
	output reg [31:0] 	imm_ext_ex;
	// output reg [4:0] 	num_write_ex;
	output reg			s_b_ex;
	output reg          s_a_ex;
	output reg [1:0] 	s_data_write_ex;
	output reg [3:0] 	aluop_ex;
	output reg 			mem_write_ex;
	output reg 			reg_write_ex;
	// output reg 			ext_ex;
	output reg [1:0]	s_npc_ex;
	output reg [1:0]	s_num_write_ex;
	output reg 			mem_read_ex;
	output reg [4:0]	rs_ex;
	output reg [4:0]	rt_ex;
	output reg [4:0]	rd_ex;
	output reg [4:0]     s_shamt_ex;
	
	always@(posedge clock)
	begin
		if(!reset || ID_EXE_flush)
		begin
			npc_ex			<=	0;
			data1_ex		<=	0;
			data2_ex		<=	0;
			imm_ext_ex		<=	0;
			s_b_ex			<=	0;
			s_a_ex          <=  0;
			s_data_write_ex	<=	0;
			mem_write_ex	<=	0;
			aluop_ex		<=	0;
			reg_write_ex	<=	0;
			s_npc_ex		<=	0;
			s_num_write_ex	<=	0;
			mem_read_ex		<=	0;
			rs_ex			<=	0;
			rt_ex			<=	0;
			rd_ex			<=	0;
			s_shamt_ex      <=0;
			
		end
		else
		begin
			npc_ex			<=	npc_id			;
			data1_ex		<=	data1_id		;		
			data2_ex		<=	data2_id		;
			imm_ext_ex		<=	imm_ext_id		;
			s_b_ex			<=	s_b_id			;
			s_a_ex          <=  s_a_id;
			s_data_write_ex	<=	s_data_write_id	;
			mem_write_ex	<=	mem_write_id	;
			aluop_ex		<=	aluop_id		;
			reg_write_ex	<=	reg_write_id	;
			s_npc_ex		<=	s_npc_id		;
			s_num_write_ex	<=	s_num_write_id	;
			mem_read_ex		<=	mem_read_id		;
			rs_ex			<=	rs_id			;
			rt_ex			<=	rt_id			;
			rd_ex			<=	rd_id			;
			s_shamt_ex      <=s_shamt_id;
		end
	end
endmodule