`include "header.v"
module ctrl(op,funct,data1_id,data2_id,aluop,ext,s_num_write,s_b,shamt,s_shamt_id,mem_write,reg_write,s_data_write,s_npc,zero_id);
	input [5:0] op;//all zero,noneffective here
	input [5:0] funct;
	input [31:0]data1_id;
	input [31:0]data2_id; 
	input [4:0] shamt;
	output[3:0] aluop;
	output ext;
	output [1:0] s_num_write;
	output s_b;
	output mem_write;
	output reg_write;
	output [1:0] s_data_write;
	output [1:0] s_npc;
	output zero_id;
	output [4:0] s_shamt_id;
	assign aluop=	(op==`OP_R)		?  ((funct==`FUNCT_ADDU)	?	`ADDU	:
										(funct==`FUNCT_SUBU)	?	`SUBU	:
										(funct==`FUNCT_ADD)		?	`ADD	:
										(funct==`FUNCT_AND)		?	`AND	:
										(funct==`FUNCT_OR)		?	`OR		:
										(funct==`FUNCT_SLT)		?	`SLT	:
										(funct==`FUNCT_SLL)		?	`FUNCT_SLL:0
									   ):
					(op==`OP_ADDI)	?	`ADD	:
					(op==`OP_ADDIU)	?	`ADD	:
					(op==`OP_SW)	?	`ADD	:
					(op==`OP_LW)	?	`ADD	:
					(op==`OP_ANDI)	?	`AND	:
					(op==`OP_ORI)	?	`OR		:
										`LUI	;
					
					
					
	assign ext=	(op==`OP_ADDI)		?	1'b1:
				(op==`OP_ADDIU)		?	1'b1:
				(op==`OP_LW)		?	1'b1:
				(op==`OP_SW)		?	1'b1:
				(op==`OP_BEQ)		?	1'b1:
										1'b0;
				
	//all Rtype ins writes back to register except for FUNCT_JR 
	assign reg_write=	(op==`OP_R)		?	(
											(funct==`FUNCT_JR)?	1'b0:
																1'b1):
						//all Itype writes back to register	 except for sw									
						(op==`OP_ADDI)	? 	1'b1:
						(op==`OP_ADDIU)	?	1'b1:
						(op==`OP_ANDI)	?	1'b1:
						(op==`OP_ORI)	?	1'b1:
						(op==`OP_LUI)	?	1'b1:
						(op==`OP_LW)	?	1'b1:
						(op==`OP_JAL)	?	1'b1:
											1'b0;
											
	assign s_num_write=	(op==`OP_R)		?	2'b01:
						(op==`OP_JAL)	?	2'b10:
											2'b00;
	
	assign s_b= (op==`OP_ADDI)  ? 	1'b1:
				(op==`OP_ADDIU) ? 	1'b1:
				(op==`OP_ANDI)  ? 	1'b1:
				(op==`OP_ORI)   ? 	1'b1:
				(op==`OP_LUI)   ? 	1'b1:
				(op==`OP_SW)    ? 	1'b1:
				(op==`OP_LW)    ? 	1'b1:
									1'b0;
									
	assign s_data_write=	(op==`OP_R)		?	2'b01:
							(op==`OP_ADDI)	? 	2'b01:
							(op==`OP_ADDIU)	?	2'b01:
							(op==`OP_ANDI)	?	2'b01:
							(op==`OP_ORI)	?	2'b01:
							(op==`OP_LUI)	?	2'b01:
							(op==`OP_LW)	?	2'b10:
												2'b00;
												
	assign s_shamt_id = (funct==`FUNCT_SLL)?shamt:1'b0;												
	assign s_npc=	(op==`OP_BEQ)	?	2'b00:
					(op==`OP_JAL)	?	2'b10:
					(op==`OP_J)		?	2'b10:
					(op==`OP_R)		?	(funct==`FUNCT_JR)	?	2'b01:
																2'b11:
										2'b11;
	assign mem_write=op==`OP_SW;
	
	assign zero_id=(data1_id==data2_id);
endmodule