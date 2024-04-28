module mem_wb(	clock,
				reset,
				mem_write_mem,
				mem_data_out_mem,
				alu_result_mem,
				num_write_mem,
				s_data_write_mem,
				reg_write_mem,
				npc_mem,
				mem_data_out_wb,
                reg_write_wb,
                s_data_write_wb,
                num_write_wb,
                alu_result_wb,
				npc_wb);
				
	input 			clock;
	input 			reset;
	input 			mem_write_mem;
	input [31:0] 	mem_data_out_mem;
	input [31:0] 	alu_result_mem;
	input [4:0]		num_write_mem;
	input [1:0]		s_data_write_mem;
	input 			reg_write_mem;
	input [31:0]	npc_mem;
	
	output reg [31:0] 	mem_data_out_wb;
	output reg 			reg_write_wb;
	output reg [1:0] 	s_data_write_wb;
	output reg [4:0] 	num_write_wb;
	output reg [31:0] 	alu_result_wb;
	output reg [31:0]	npc_wb;
	
	always@(posedge clock)
	begin
		if(!reset)
		begin
			mem_data_out_wb		<=	0;
			reg_write_wb		<=	0;
			s_data_write_wb		<=	0;
			num_write_wb		<=	0;
			alu_result_wb		<=	0;
			npc_wb				<=	0;
		end
		else
		begin
			mem_data_out_wb		<=	mem_data_out_mem;
			reg_write_wb		<=	reg_write_mem	;
			s_data_write_wb		<=	s_data_write_mem;
			num_write_wb		<=	num_write_mem	;
			alu_result_wb		<=	alu_result_mem	;
			npc_wb				<=	npc_mem			;
		end
	end
	
endmodule