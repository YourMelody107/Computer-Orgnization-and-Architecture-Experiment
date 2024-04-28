module mem_wb(clock,reset,s_data_write_EXE_MEM,c_EXE_MEM,data_out_EXE_MEM,rt_EXE_MEM,reg_write_EXE_MEM,num_write_EXE_MEM,
s_lw_EXE_MEM,s_lw_MEM_WB,s_data_write_MEM_WB,c_MEM_WB,data_out_MEM_WB,rt_MEM_WB,reg_write_MEM_WB,num_write_MEM_WB);
			  
	input clock;
	input reset;
	input [1:0] s_data_write_EXE_MEM;
	input [31:0] c_EXE_MEM;
	input [31:0] data_out_EXE_MEM;
	input reg_write_EXE_MEM;
	input [4:0] num_write_EXE_MEM;
	input [4:0] rt_EXE_MEM;
	input s_lw_EXE_MEM;

	output reg [1:0] s_data_write_MEM_WB;
	output reg [31:0] c_MEM_WB;
	output reg [31:0] data_out_MEM_WB;
	output reg reg_write_MEM_WB;
	output reg [4:0]num_write_MEM_WB;
	output reg [4:0]rt_MEM_WB;
	output reg s_lw_MEM_WB;

always @(posedge clock)
begin
   if(reset==0)
     begin 
	   s_data_write_MEM_WB=0;
	   c_MEM_WB=0;
	   data_out_MEM_WB=0;
	   reg_write_MEM_WB=0;
	   num_write_MEM_WB=0;
	   rt_MEM_WB=0;
	   s_lw_MEM_WB=0;
	 end
	else
	  begin
	    s_data_write_MEM_WB=s_data_write_EXE_MEM;
		c_MEM_WB=c_EXE_MEM;
		data_out_MEM_WB=data_out_EXE_MEM;
		reg_write_MEM_WB=reg_write_EXE_MEM;
		num_write_MEM_WB=num_write_EXE_MEM;
		rt_MEM_WB=rt_EXE_MEM;
		s_lw_MEM_WB=s_lw_EXE_MEM;
		end
end

endmodule 