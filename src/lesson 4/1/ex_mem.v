module ex_mem(	clock,				reset,
				npc_ex,				zero_ex,
				alu_result_ex,		data2_ex,
				num_write_ex,		mem_write_ex,
				s_data_write_ex,	reg_write_ex,
				s_npc_ex,			mem_read_ex,
				npc_mem,			zero_mem,
				alu_result_mem,		data2_mem,
				num_write_mem,		mem_write_mem,
				s_data_write_mem,	reg_write_mem,
				s_npc_mem,			mem_read_mem);
				
	input clock;
	input reset;
	
	input [31:0] 	npc_ex;
	input 			zero_ex;
	input [31:0] 	alu_result_ex;
	input [31:0] 	data2_ex;
	input [4:0] 	num_write_ex;
	input 			mem_write_ex;
	input [1:0] 	s_data_write_ex;
	input 			reg_write_ex;
	input [1:0]		s_npc_ex;
	input 			mem_read_ex;
	
	output reg [31:0] 	npc_mem;
	output reg 			zero_mem;
	output reg [31:0] 	alu_result_mem;
	output reg [31:0] 	data2_mem;
	output reg [4:0] 	num_write_mem;
	output reg 			mem_write_mem;
	output reg [1:0] 	s_data_write_mem;
	output reg			reg_write_mem;
	output reg [1:0]	s_npc_mem;
	output reg			mem_read_mem;

	always@(posedge clock)
	begin
		if(!reset)
		begin
			npc_mem				<=	0;
			zero_mem			<=	0;
			alu_result_mem		<=	0;
			data2_mem			<=	0;
			num_write_mem		<=	0;
			mem_write_mem		<=	0;
			s_data_write_mem	<=	0;
			reg_write_mem		<=	0;
			s_npc_mem			<=	0;
			// s_num_write_mem		<=	0;
			mem_read_mem		<=	0;
		end
		else
		begin
			npc_mem				<=	npc_ex			;
			zero_mem			<=	zero_ex			;
			alu_result_mem		<=	alu_result_ex	;
			data2_mem			<=	data2_ex		;
			num_write_mem		<=	num_write_ex	;
			mem_write_mem		<=	mem_write_ex	;
			s_data_write_mem	<=	s_data_write_ex	;
			reg_write_mem		<=	reg_write_ex	;
			s_npc_mem			<=	s_npc_ex		;
			mem_read_mem		<=	mem_read_ex		;
		end
	end
	
endmodule