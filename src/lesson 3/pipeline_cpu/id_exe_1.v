/*
译码、计算间的寄存器；
接收到的是if_id级传出来的instruction以及pc+4；
在这一阶段会进行译码操作，故传输出去的传输过去的是执行指令的所有控制信号(ctrl模块的)和数据；
只起到一个暂存数据，让数据推迟一周期传递的效果
*/
module id_exe(
			 //传输的数据
			 input [31:0] npc_in,
			 output reg [31:0] npc_out,
			 //output [1:0] s_npc,因为没有控制冒险，所以npc只取pc+4
			 input [31:0] a_in,
			 output reg [31:0] a_out,
			 input [31:0] b_in,
			 output reg [31:0] b_out,
			 input [31:0] ext_imm_in,
			 output reg [31:0] ext_imm_out,
			 input [4:0] num_write_in,
			 output reg [4:0] num_write_out,
			 //传输的控制信号
			 input [1:0] s_data_write_in,
			 output reg [1:0] s_data_write_out,
			 input s_b_in,
			 output reg s_b_out,
			 input [3:0] aluop_in,
			 output reg [3:0] aluop_out,
			 input mem_write_in,
			 output reg mem_write_out,
			 input reg_write,
			 output reg reg_write_out,
			 input [31:0] instruction,
			 output reg [31:0] instruction_out,
			 input clock,
			 input reset,//同步低电平有效
			 input id_exe_write,//id_exe级流水线寄存器写使能信号
			 input id_exe_flush//寄存器清零信号，由check模块产生，同步清零 
			 );

always@(posedge clock)
begin
	if(id_exe_flush)
	begin 
		npc_out <= 32'h0000_3000;
		a_out <= 32'h0000_0000;
		b_out <= 32'h0000_0000;
		ext_imm_out <= 32'h0000_0000;
		num_write_out <= 5'b00000;
		s_data_write_out <= 2'b00;
		s_b_out <= 2'b00;
		aluop_out <= 4'b0000;
		mem_write_out <= 1'b0;
		reg_write_out <= 1'b0;
		instruction_out <= 32'h0000_0000;
	end
	else if(!reset)
	begin
		npc_out <= 32'h0000_3000;
		a_out <= 32'h0000_0000;
		b_out <= 32'h0000_0000;
		ext_imm_out <= 32'h0000_0000;
		num_write_out <= 5'b00000;
		s_data_write_out <= 2'b00;
		s_b_out <= 2'b00;
		aluop_out <= 4'b0000;
		mem_write_out <= 1'b0;
		reg_write_out <= 1'b0;
		instruction_out <= 32'h0000_0000;
	end
	else 
	begin
	if(id_exe_write)
	begin
		npc_out <= npc_in;
		a_out <= a_in;
		b_out <= b_in;
		ext_imm_out <= ext_imm_in;
		num_write_out <= num_write_in;
		s_data_write_out <= s_data_write_in;
		s_b_out <= s_b_in;
		aluop_out <= aluop_in;
		mem_write_out <= mem_write_in;
		reg_write_out <= reg_write;
		instruction_out <= instruction;
	end
	end
end

endmodule

