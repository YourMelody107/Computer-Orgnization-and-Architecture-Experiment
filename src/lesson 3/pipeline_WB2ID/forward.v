module forward(ins_IF_ID,ins_ID_EXE,num_write_EXE_MEM,num_write_MEM_WB,FA,FB,FA1,FB1);

	input [31:0]ins_IF_ID;
	input [31:0]ins_ID_EXE;
	input [4:0]num_write_EXE_MEM;
	input [4:0]num_write_MEM_WB;
	
	output reg [1:0] FA;
	output reg [1:0] FB;
	output reg FA1;
	output reg FB1;
	
	always@(*) 
		begin
			FA<=2'b10;
			FB<=2'b10;
			FA1<=1;
			FB1<=1;

			if(ins_IF_ID[25:21]&&(ins_IF_ID[25:21]==num_write_MEM_WB))										FA1<=0;
			if(ins_IF_ID[20:16]&&(ins_IF_ID[20:16]==num_write_MEM_WB))	
				FB1<=0; 

			if(ins_ID_EXE[25:21]&&(ins_ID_EXE[25:21]==num_write_MEM_WB))
				FA<=2'b01;
			if(ins_ID_EXE[25:21]&&(ins_ID_EXE[25:21]==num_write_EXE_MEM))   
				FA<=2'b00;
			
			if(ins_ID_EXE[20:16]&&(ins_ID_EXE[20:16]==num_write_MEM_WB))
				FB<=2'b01;
			if(ins_ID_EXE[20:16]&&(ins_ID_EXE[20:16]==num_write_EXE_MEM))
				FB<=2'b00;
		end

endmodule