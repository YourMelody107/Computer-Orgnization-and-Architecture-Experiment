module forward(ins_ID_EXE,num_write_EXE_MEM,num_write_MEM_WB,FA,FB);

	input [31:0]ins_ID_EXE;
	input [4:0]num_write_EXE_MEM;
	input [4:0]num_write_MEM_WB;
	
	output reg [1:0] FA;
	output reg [1:0] FB;
	
	always@(*) 
		begin
			FA<=2'b10;
			FB<=2'b10;
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