module detect(aluop_ID_EXE,num_write_ID_EXE,ins_IF_ID,w,w_IF_ID,clear_ID_EXE);

	input [3:0]aluop_ID_EXE;
	input [31:0]ins_IF_ID;
	input [4:0]num_write_ID_EXE;
	
	output reg clear_ID_EXE;
	output reg w;
	output reg w_IF_ID;


	always@(*) 
		begin
			clear_ID_EXE<=0;
			w<=0;
			w_IF_ID<=0;
			if((aluop_ID_EXE==4'b1100)&&(ins_IF_ID[31:26]==6'b000000)&&((num_write_ID_EXE==ins_IF_ID[25:21])||(num_write_ID_EXE==ins_IF_ID[20:16]))) 
				begin
					clear_ID_EXE<=1;
					w<=1;
					w_IF_ID<=1;					
				end
			if((aluop_ID_EXE==4'b1100)&&(num_write_ID_EXE==ins_IF_ID[25:21])) 
				begin
					clear_ID_EXE<=1;
					w<=1;
					w_IF_ID<=1;
				end
		end
endmodule