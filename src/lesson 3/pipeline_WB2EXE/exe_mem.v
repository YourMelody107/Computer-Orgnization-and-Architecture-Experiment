module exe_mem(clock,reset,npc_ID_EXE,c,b_ID_EXE,num_write_ID_EXE,mem_write_ID_EXE,s_data_write_ID_EXE,reg_write_ID_EXE,
npc_EXE_MEM,c_EXE_MEM,b_EXE_MEM,num_write_EXE_MEM,mem_write_EXE_MEM,s_data_write_EXE_MEM,reg_write_EXE_MEM,ins_ID_EXE,ins_EXE_MEM);

	input clock;
	input reset;
	
	input [31:0]c;
	
	input [31:0]b_ID_EXE;
	input [31:0]npc_ID_EXE;
	
	input mem_write_ID_EXE;
	input [4:0]num_write_ID_EXE;
	input reg_write_ID_EXE;
	input [1:0]s_data_write_ID_EXE;
	
	input [31:0]ins_ID_EXE;

	output reg [31:0]b_EXE_MEM;
	output reg [31:0]c_EXE_MEM;
	output reg [31:0]npc_EXE_MEM;
	
	output reg mem_write_EXE_MEM;
	output reg [4:0]num_write_EXE_MEM;
	output reg reg_write_EXE_MEM;
	output reg [1:0]s_data_write_EXE_MEM;

	output reg [31:0]ins_EXE_MEM;

	always@(posedge clock) 
		begin
			if(reset) 
				begin
					b_EXE_MEM<=b_ID_EXE;
					c_EXE_MEM<=c;
					npc_EXE_MEM<=npc_ID_EXE;
					mem_write_EXE_MEM<=mem_write_ID_EXE;
					num_write_EXE_MEM<=num_write_ID_EXE;
					reg_write_EXE_MEM<=reg_write_ID_EXE;
					s_data_write_EXE_MEM<=s_data_write_ID_EXE;
					ins_EXE_MEM<=ins_ID_EXE;

				end
			else 
				begin
					b_EXE_MEM<=32'h0000_0000;
					c_EXE_MEM<=32'h0000_0000;
					npc_EXE_MEM<=32'h0000_0000;
					mem_write_EXE_MEM<=1'b0;
					num_write_EXE_MEM<=5'b00000;
					reg_write_EXE_MEM<=1'b0;
					s_data_write_EXE_MEM<=2'b00;
					ins_EXE_MEM<=32'h0000_0000;
				end
		end

endmodule