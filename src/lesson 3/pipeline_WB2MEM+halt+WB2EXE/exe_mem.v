module exe_mem(clock,reset,s_data_write_ID_EXE,mem_write_ID_EXE,c_ID_EXE ,b_ID_EXE,rt_ID_EXE,reg_write_ID_EXE,num_write_ID_EXE,
s_rt_ID_EXE,s_lw_ID_EXE,s_rt_EXE_MEM,s_lw_EXE_MEM,s_data_write_EXE_MEM,mem_write_EXE_MEM,c_EXE_MEM,b_EXE_MEM,
rt_EXE_MEM,reg_write_EXE_MEM,num_write_EXE_MEM);
			   
	input clock;
	input reset;
	input [1:0] s_data_write_ID_EXE;
	input mem_write_ID_EXE;
	input reg_write_ID_EXE;
	input [31:0] c_ID_EXE;
	input [31:0] b_ID_EXE;
	input [4:0] num_write_ID_EXE;
	input [4:0] rt_ID_EXE;
	input s_rt_ID_EXE;
	input s_lw_ID_EXE;

	output reg [1:0]s_data_write_EXE_MEM;
	output reg mem_write_EXE_MEM;
	output reg reg_write_EXE_MEM;
	output reg [31:0] c_EXE_MEM;
	output reg [31:0] b_EXE_MEM;
	output reg [4:0] num_write_EXE_MEM;
	output reg [4:0]rt_EXE_MEM;
	output reg s_rt_EXE_MEM;
	output reg s_lw_EXE_MEM;

always @(posedge clock) 
begin
   if(reset==0)
       begin 
	   s_data_write_EXE_MEM=0;
	   mem_write_EXE_MEM=0;
	   reg_write_EXE_MEM=0;
	   c_EXE_MEM=0;
	   b_EXE_MEM=0;
	   num_write_EXE_MEM=0;
	   rt_EXE_MEM=0;
	   
	   s_rt_EXE_MEM=0;
	   s_lw_EXE_MEM=0;
	   end
	else
	 begin
	   s_data_write_EXE_MEM=s_data_write_ID_EXE;
	   mem_write_EXE_MEM=mem_write_ID_EXE;
	   reg_write_EXE_MEM=reg_write_ID_EXE;
	   c_EXE_MEM=c_ID_EXE;
	   b_EXE_MEM=b_ID_EXE;
	   num_write_EXE_MEM=num_write_ID_EXE;
	   rt_EXE_MEM=rt_ID_EXE;
	   
	   s_rt_EXE_MEM=s_rt_ID_EXE;
	   s_lw_EXE_MEM=s_lw_ID_EXE;
	 end
	
end
	 
endmodule