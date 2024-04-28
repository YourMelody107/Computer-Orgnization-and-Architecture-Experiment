`include "header.v"

module hazard_check(num_write_ex,rs,rt,mem_read_mem, mem_read_wb,op,funct,a,b,alu_result_mem,num_write_mem, num_write_wb,pc_write,IF_ID_write,ID_EXE_flush,IF_ID_flush,zero_id);
  input [4:0] num_write_ex;
  input [4:0] rs;
  input [4:0] rt;
  input 		mem_read_mem;
  input 		mem_read_wb;
  input [5:0]	op;
  input [5:0] funct;
  input [31:0] a;
  input [31:0] b;
  input [31:0] alu_result_mem;
  input [4:0] num_write_mem;
  input [4:0] num_write_wb;

  output reg pc_write;
  output reg IF_ID_write;
  output reg ID_EXE_flush;
  output reg IF_ID_flush;
  output zero_id;

  always@(*)
  begin
    if(mem_read_mem && (op==`OP_R || op == `OP_BEQ) && (num_write_ex == rs || num_write_ex == rt))
    begin
      ID_EXE_flush<=1;
      pc_write<=0;
      IF_ID_write<=0;
    end
    else if (mem_read_mem && (	op==`OP_ADDI ||
                               op==`OP_ADDIU||
                               op==`OP_ANDI ||
                               op==`OP_ORI	 ||
                               op==`OP_LUI  ||
                               op==`OP_LW   ||
                               op==`OP_SW	)
             && num_write_ex == rs)
    begin
      ID_EXE_flush<=1'b1;
      pc_write<=1'b0;
      IF_ID_write<=1'b0;
    end
    else if(op==`OP_BEQ && (num_write_ex == rs || num_write_ex == rt))
    begin
      ID_EXE_flush<=1'b1;
      pc_write<=1'b0;
      IF_ID_write<=1'b0;
    end
    else if(op == `OP_BEQ && mem_read_wb &&(num_write_wb == rs || num_write_wb == rt))
    begin
      ID_EXE_flush<=1'b1;
      pc_write<=1'b0;
      IF_ID_write<=1'b0;
    end
    else
    begin
      ID_EXE_flush<=1'b0;
      pc_write<=1'b1;
      IF_ID_write<=1'b1;
    end

    if(	op==`OP_J 	||
        op==`OP_JAL ||
        (op==`OP_R && funct==`FUNCT_JR)||
        (op==`OP_BEQ && a==b)
      )
    begin
      IF_ID_flush	<=	1'b1;
    end
    else
    begin
      IF_ID_flush	<=	1'b0;
    end

  end
  assign zero_id=	(op==`OP_BEQ)?(
           (num_write_ex != rs && num_write_ex != rt)?a==b:
           (num_write_mem == rs && num_write_mem != rt)?alu_result_mem==b:
           (num_write_mem != rs && num_write_mem == rt)?a==alu_result_mem:
           1'b1
         ):
         1'b0;
endmodule
