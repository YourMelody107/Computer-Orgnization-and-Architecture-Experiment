module detect(rs,rt,rt0,num_write,pc_write,write_IF_ID,clear_ID_EXE,lw0);

    input [4:0] rs; 
	input [4:0] rt;
	input [4:0] num_write;
    input rt0;
	input lw0;
    output reg pc_write;
	output reg write_IF_ID;
	output reg clear_ID_EXE;


always @(*)
	begin
        pc_write = 1;
        write_IF_ID = 1;
        clear_ID_EXE = 0;
        if (lw0) 
			begin
				if (rs != 0  && rt0) 
					begin
						if (rs == num_write)
							begin
								pc_write = 0;
								write_IF_ID = 0;
								clear_ID_EXE = 1;
							end
               end 
		else 
				if ( rt != 0 && rt0 && rs!=0)
    			   begin
						if (rt == num_write) 
							begin
								pc_write = 0;
								write_IF_ID = 0;
								clear_ID_EXE = 1;
							end
                   end
			end
    end

endmodule