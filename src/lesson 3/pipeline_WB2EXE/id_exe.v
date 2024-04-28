module id_exe(clock,reset,npc_IF_ID,npc_ID_EXE,a_ID_EXE,b_ID_EXE,imm_extend_ID_EXE,num_write_ID_EXE,s_b_ID_EXE,aluop_ID_EXE,mem_write_ID_EXE,
s_data_write_ID_EXE,reg_write_ID_EXE,a,b,imm_extend,num_write,aluop,s_b,mem_write,s_data_write,reg_write,ins_IF_ID,ins_ID_EXE,clear_ID_EXE);

	input clock;
	input reset;
	
	input [31:0] npc_IF_ID;
	
	input [31:0] a;
	input [31:0] b;
	input [3:0] aluop;

	input [31:0] imm_extend;
	input mem_write;	
	input [4:0] num_write;
	input reg_write;
	input s_b;
	input [1:0] s_data_write;

	input [31:0] ins_IF_ID;

	input clear_ID_EXE;

	output reg [31:0] npc_ID_EXE;
	
	output reg [31:0] a_ID_EXE;
	output reg [31:0] b_ID_EXE;
	output reg [3:0] aluop_ID_EXE;

	output reg [31:0] imm_extend_ID_EXE;	
	output reg mem_write_ID_EXE;
	output reg [4:0] num_write_ID_EXE;
	output reg reg_write_ID_EXE;
	output reg s_b_ID_EXE;
	output reg [1:0] s_data_write_ID_EXE;

	output reg [31:0] ins_ID_EXE;
	
	
	always@(posedge clock) 
		begin
			if(reset==0||clear_ID_EXE) 
				begin
					npc_ID_EXE<=32'h0000_0000;
					a_ID_EXE<=32'h0000_0000;
					b_ID_EXE<=32'h0000_0000;
					aluop_ID_EXE<=4'b0000;
					imm_extend_ID_EXE<=32'h0000_0000;
					mem_write_ID_EXE<=0;
					num_write_ID_EXE<=5'b00000;
					reg_write_ID_EXE<=0;
					s_b_ID_EXE<=0;
					s_data_write_ID_EXE<=2'b00;
					ins_ID_EXE<=32'h0000_0000;
				end
			else 
				begin
					npc_ID_EXE<=npc_IF_ID;
					a_ID_EXE<=a;
					b_ID_EXE<=b;
					aluop_ID_EXE<=aluop;
					imm_extend_ID_EXE<=imm_extend;
					mem_write_ID_EXE<=mem_write;
					num_write_ID_EXE<=num_write;
					reg_write_ID_EXE<=reg_write;
					s_b_ID_EXE<=s_b;
					s_data_write_ID_EXE<=s_data_write;
					ins_ID_EXE<=ins_IF_ID;
				end
		end

endmodule