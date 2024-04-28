`include "header.v"
module hazard_check(num_write_ex,rs,rt,mem_read_mem,op,funct,pc_write,IF_ID_write,ID_EXE_flush,IF_ID_flush);
	input [4:0] num_write_ex;
	input [4:0] rs;
	input [4:0] rt;
	input 		mem_read_mem;
	input [5:0]	op;
	input [5:0] funct;
	output reg pc_write;
	output reg IF_ID_write;
	output reg ID_EXE_flush;
	output reg IF_ID_flush;
	
	always@(*)
	begin
		if(mem_read_mem && op==`OP_R && (num_write_ex == rs || num_write_ex == rt))
		begin
			ID_EXE_flush<=1'b1;
			pc_write<=1'b0;
			IF_ID_write<=1'b0;
		end
		else if (mem_read_mem && (	op==`OP_ADDI || 
									op==`OP_ADDIU||
									op==`OP_ANDI ||	
		                            op==`OP_ORI	 ||
		                            op==`OP_LUI  ||
		                            op==`OP_LW   ||	
		                            op==`OP_SW	) 
									&& num_write_ex == rs)
		begin
			ID_EXE_flush<=1'b1;
			pc_write<=1'b0;
			IF_ID_write<=1'b0;
		end
		else
		begin
			ID_EXE_flush<=1'b0;
			pc_write<=1'b1;
			IF_ID_write<=1'b1;
		end
		
		if(	op==`OP_J 	||
			op==`OP_JAL ||
			(op==`OP_R && funct==`FUNCT_JR)
		  )
			IF_ID_flush	<=	1;
		else
			IF_ID_flush	<=	0;
	end
endmodule