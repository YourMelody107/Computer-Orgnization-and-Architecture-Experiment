module bypass(ex_mem_rd,mem_wb_rd,id_ex_rs,id_ex_rt,rs,rt,reg_write_mem,reg_write_wb,forwardA,forwardB,forwardA_id,forwardB_id);
	input [4:0] ex_mem_rd;
	input [4:0] mem_wb_rd;
	input [4:0] id_ex_rs;
	input [4:0] id_ex_rt;
	input [4:0] rs;
	input [4:0] rt;
	input reg_write_mem;
	input reg_write_wb;
	
	output reg [1:0] forwardA;
	output reg [1:0] forwardB;
	output reg forwardA_id;
	output reg forwardB_id;
	
	always@(*)
	begin
		if(reg_write_mem && ex_mem_rd != 5'b00000 && ex_mem_rd == id_ex_rs)
			forwardA<=2'b10;
		else if(reg_write_wb && mem_wb_rd	!= 5'b00000 && mem_wb_rd == id_ex_rs)
			forwardA<=2'b01;
		else 
			forwardA<=2'b00;
		
		if(reg_write_mem && ex_mem_rd != 5'b00000 && ex_mem_rd == id_ex_rt)
			forwardB<=2'b10;
		else if(reg_write_wb && mem_wb_rd != 5'b00000 && mem_wb_rd == id_ex_rt)
			forwardB<=2'b01;
		else
			forwardB<=2'b00;
			
		if(reg_write_wb && mem_wb_rd != 5'b00000 && mem_wb_rd == rs)
			forwardA_id<=1'b1;
		else
			forwardA_id<=1'b0;
			
		if(reg_write_wb && mem_wb_rd != 5'b00000 &&mem_wb_rd == rt)
			forwardB_id<=1'b1;
		else
			forwardB_id<=1'b0;
	end
	
endmodule