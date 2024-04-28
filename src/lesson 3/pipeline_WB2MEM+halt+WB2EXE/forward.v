module forward(rs_ID_EXE,rt_ID_EXE,rs_IF_ID,rt_IF_ID,num_write_EXE_MEM,num_write_MEM_WB,rt_EXE_MEM,rt_MEM_WB,FA,FB,FA1,FB1,F,reg_write_MEM_WB,reg_write_EXE_MEM);
	
	input [4:0] rs_ID_EXE;
	input [4:0] rt_ID_EXE;
	input [4:0] rs_IF_ID;
	input [4:0] rt_IF_ID;
	input [4:0] num_write_EXE_MEM;
	input [4:0] num_write_MEM_WB;
	input [4:0] rt_EXE_MEM;
	input [4:0] rt_MEM_WB;
	input reg_write_EXE_MEM;
	input reg_write_MEM_WB;
	output reg [1:0] FA;
	output reg [1:0] FB;
	output reg F;
	output reg FA1;
	output reg FB1;
always@(*)
	begin
		FA = 2;FB = 2;
		FA1 = 1;FB1 = 1;
		F = 0;
		
        if (rs_ID_EXE == num_write_EXE_MEM && num_write_EXE_MEM!=0 && reg_write_EXE_MEM)
            FA = 0;
		else if (rs_ID_EXE == num_write_MEM_WB && num_write_MEM_WB!=0 && reg_write_MEM_WB)
             FA = 1;
        if (rt_ID_EXE == num_write_EXE_MEM && num_write_EXE_MEM!=0 && reg_write_EXE_MEM)
            FB = 0;
		else if (rt_ID_EXE == num_write_MEM_WB && num_write_MEM_WB!=0 && reg_write_MEM_WB)
            FB = 1;
			
		if (rs_IF_ID == num_write_MEM_WB && num_write_MEM_WB!=0 && reg_write_MEM_WB)
             FA1= 0;
        if (rt_IF_ID == num_write_MEM_WB && num_write_MEM_WB!=0 && reg_write_MEM_WB)
            FB1 = 0;
			
		if(rt_EXE_MEM == num_write_MEM_WB  && reg_write_MEM_WB && rt_EXE_MEM!=0  )
		   F=1;

	end

endmodule
