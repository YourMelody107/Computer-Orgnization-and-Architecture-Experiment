module id_exe(clock,reset,s_b_IF_ID,s_data_write_IF_ID,mem_write_IF_ID,aluop_IF_ID,a_IF_ID, b_IF_ID, num_imm_IF_ID,reg_write_in,num_write_IF_ID,
rs_IF_ID,rt_IF_ID,clear_ID_EXE,s_rt_IF_ID,s_lw_in,s_rt_ID_EXE,s_lw_out,s_b_ID_EXE,s_data_write_ID_EXE,mem_write_ID_EXE,aluop_ID_EXE,
a_ID_EXE,b_ID_EXE,num_imm_ID_EXE,rs_ID_EXE,rt_ID_EXE,reg_write_ID_EXE,num_write_ID_EXE);
				
	input clock;
	input reset;
	input s_b_IF_ID;
	input mem_write_IF_ID;
	input reg_write_in;
	input [1:0] s_data_write_IF_ID;
	input [3:0]aluop_IF_ID;
	input [31:0] a_IF_ID;
	input [31:0] b_IF_ID;
	input [31:0] num_imm_IF_ID;
	input [4:0] num_write_IF_ID;
	input [4:0] rs_IF_ID;
	input [4:0]rt_IF_ID;
	input clear_ID_EXE;
	input s_rt_IF_ID;
	input s_lw_in;

	output reg s_b_ID_EXE;
	output reg mem_write_ID_EXE;
	output reg reg_write_ID_EXE;
	output reg [1:0] s_data_write_ID_EXE;
	output reg [3:0]aluop_ID_EXE;
	output reg [31:0] a_ID_EXE;
	output reg [31:0] b_ID_EXE;
	output reg [31:0] num_imm_ID_EXE;
	output reg [4:0]num_write_ID_EXE;
	output reg [4:0]rs_ID_EXE,rt_ID_EXE;
	output reg s_rt_ID_EXE;
	output reg s_lw_out;

always @(posedge clock) 
begin
   if(reset==0 || clear_ID_EXE)
       begin 
	    s_b_ID_EXE=0;
		mem_write_ID_EXE=0;
		reg_write_ID_EXE=0;
        s_data_write_ID_EXE=0;
        aluop_ID_EXE=0;
        a_ID_EXE=0;
		b_ID_EXE=0; 
		num_imm_ID_EXE=0;
        num_write_ID_EXE=0;
		rt_ID_EXE=0;
		rs_ID_EXE=0;
		s_rt_ID_EXE=1;
		s_lw_out=0;
       end
	else
	   begin
	   s_b_ID_EXE=s_b_IF_ID;
		mem_write_ID_EXE=mem_write_IF_ID;
		reg_write_ID_EXE=reg_write_in;
        s_data_write_ID_EXE=s_data_write_IF_ID;
        aluop_ID_EXE=aluop_IF_ID;
        a_ID_EXE=a_IF_ID;
		b_ID_EXE=b_IF_ID; 
		num_imm_ID_EXE=num_imm_IF_ID;
        num_write_ID_EXE=num_write_IF_ID;
		rs_ID_EXE=rs_IF_ID;
		rt_ID_EXE=rt_IF_ID;
		s_rt_ID_EXE=s_rt_IF_ID;
		s_lw_out=s_lw_in;
	   
	   end
end

endmodule 
				