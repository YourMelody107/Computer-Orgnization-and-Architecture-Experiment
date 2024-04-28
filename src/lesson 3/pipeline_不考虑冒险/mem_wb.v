module mem_wb(clock,reset,npc_EXE_MEM,c_EXE_MEM,num_write_EXE_MEM,s_data_write_EXE_MEM,reg_write_EXE_MEM,
npc_MEM_WB,c_MEM_WB,data_out_MEM_WB,num_write_MEM_WB,s_data_write_MEM_WB,reg_write_MEM_WB,data_out);

	input clock;
	input reset;

	input [31:0]data_out;
	
	input [31:0]c_EXE_MEM;
	input [31:0]npc_EXE_MEM;
	
	input [4:0]num_write_EXE_MEM;
	input reg_write_EXE_MEM;
	input [1:0]s_data_write_EXE_MEM;
	
	output reg [31:0]c_MEM_WB;
	output reg [31:0]npc_MEM_WB;
	
	output reg [31:0]data_out_MEM_WB;
	output reg[4:0]num_write_MEM_WB;
	output reg reg_write_MEM_WB;
	output reg [1:0]s_data_write_MEM_WB;

	always @(posedge clock) 
		begin
			if(reset) 
				begin
					c_MEM_WB<=c_EXE_MEM;
					npc_MEM_WB<=npc_EXE_MEM;
					data_out_MEM_WB<=data_out;
					num_write_MEM_WB<=num_write_EXE_MEM;
					reg_write_MEM_WB<=reg_write_EXE_MEM;
					s_data_write_MEM_WB<=s_data_write_EXE_MEM;
				end
			else 
				begin
					c_MEM_WB<=32'h0000_0000;
					npc_MEM_WB<=32'h0000_0000;
					data_out_MEM_WB<=32'h0000_0000;
					num_write_MEM_WB<=5'b00000;
					reg_write_MEM_WB<=0;
					s_data_write_MEM_WB<=2'b00;
				end   
		end
endmodule