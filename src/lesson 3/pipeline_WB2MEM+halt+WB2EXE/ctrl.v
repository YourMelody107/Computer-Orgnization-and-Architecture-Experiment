`include "header.v"

module ctrl(s_rt,s_lw,reg_write,aluop,s_num_write,s_ext ,s_b,mem_write,s_data_write,op,funct);
output reg_write;
output [3:0] aluop;
output [1:0]s_num_write;
output s_ext,s_b;
output mem_write;
output s_rt,s_lw;
output [1:0]s_data_write;
//output [1:0]s_npc;

input [5:0] op;
input [5:0] funct;

reg reg_w;
reg [3:0]reg_aluop;
reg [1:0]rs_num_write;
reg rs_ext,rs_b;
reg rmem_write;
reg [1:0]rs_data_write;
reg [1:0]rs_npc;
reg rs_rt;
reg rs_lw;

assign reg_write=reg_w;
assign aluop=reg_aluop;

always @(*)
begin
 rs_b=0;
 rs_ext=0;
 rmem_write=0;
 rs_num_write=1;
 rs_data_write=0;
 rs_npc=3;
 reg_w=0;
 reg_aluop=0000;
 
 rs_rt = 1;
 rs_lw = 0;
 
   case(op)
      000000  :begin
	            reg_w=1;
	             case(funct)
	    ` FUNCT_ADDU :reg_aluop=funct[3:0];
                  ` FUNCT_SUBU :reg_aluop=funct[3:0];
                  ` FUNCT_ADD  :reg_aluop=funct[3:0];
                  ` FUNCT_AND  :reg_aluop=funct[3:0];
                  ` FUNCT_OR   :reg_aluop=funct[3:0];
                  ` FUNCT_SLT  :reg_aluop=funct[3:0];
			   
                   ` FUNCT_JR   :begin 
			 rs_npc=1; 
                                                  reg_w=0;
                                           end
			  
	  endcase       
               end
	  
     `OP_ADDI :begin
	            reg_aluop={1'b0,op[2:0]};
	            reg_w=1;
				rs_num_write=0;
	            rs_ext=1;
	            rs_b=1;
				rmem_write=0;
			    rs_data_write=0;
				rs_rt=0;
				end
				
	 `OP_ADDIU:begin
	           reg_aluop={1'b0,op[2:0]};
	           reg_w=1;
			   rs_num_write=0;
	           rs_ext=1;
	           rs_b=1;
			   rmem_write=0;
			   rs_data_write=0;
			   rs_rt=0;
	           end
			   
	 `OP_ANDI:begin
	           reg_aluop={1'b0,op[2:0]};
	           reg_w=1;
			   rs_num_write=0;
	           rs_ext=0;
	           rs_b=1;
			   rmem_write=0;
			   rs_data_write=0;
			   rs_rt=0;
	           end
			   
	 `OP_ORI :begin
	           reg_aluop={1'b0,op[2:0]};
	           reg_w=1;
			   rs_num_write=0;
	           rs_ext=0;
	           rs_b=1;
			   rmem_write=0;
			   rs_data_write=0;
			   rs_rt=0;
	           end
	 
	 `OP_LUI:begin
	           reg_aluop=op[3:0];
	           reg_w=1;
			   rs_num_write=0;
	           rs_ext=0;
	           rs_b=1;
			   rmem_write=0;
			   rs_data_write=0;
			   rs_rt=0;
	           end
	 ` OP_SW:begin
	          reg_aluop=0000;
			  reg_w=0;
			  rs_num_write=0;
	          rs_ext=1;
	          rs_b=1;
			  rmem_write=1;
			  rs_data_write=0;
             end
      `OP_LW:begin
	          reg_aluop=0000;
			  reg_w=1;
			  rs_num_write=0;
	          rs_ext=1;
	          rs_b=1;
			  rmem_write=0;
			  rs_data_write=1;
			  rs_lw = 1;
             end
      			 
	   `OP_J:begin
		      rs_npc=2;
			  reg_w=0;
              end	  
       `OP_JAL:begin 
	          rs_npc=2;
			  reg_w=1;
			  rs_num_write=2;
			  rs_data_write=2;
			   end	
  		   
        `OP_BEQ:begin
		        rs_ext=1;
				rs_npc=0;
				reg_w=0;
                end				   
		
	endcase
     
end


assign s_num_write=rs_num_write;
assign s_ext=rs_ext;
assign s_b=rs_b;
assign mem_write=rmem_write;
assign s_data_write=rs_data_write;
assign s_rt=rs_rt;
assign s_lw=rs_lw;
//assign s_npc=rs_npc;

endmodule
