//冒险检测单元，用来产生应对mem级数据冒险的控制信号
module check(
			 output reg pc_write,//接到pc逻辑里面，判断是pc值保持不变，还是取pc+4
			 output reg if_id_write,//id_id流水线寄存器写信号，接到if_id模块上
			 output reg id_exe_flush,//接到id_exe模块上，用来控制是暂停还是正常执行指令
			 input [31:0] instruction_lw,//第三级流水线的指令输出
			 input [31:0] instruction_ir//第二级流水线寄存器的指令输出
			 );
always@(*)
begin
	if(instruction_lw[31:26] == 6'b100011)
	begin
		if(instruction_ir[31:26] == 6'b000000)
		begin
			if(instruction_lw[20:16] == instruction_ir[20:16] || instruction_lw[20:16] == instruction_ir[25:21])
			//存在mem数据冒险
			begin
				pc_write = 0;
				if_id_write = 0;
				id_exe_flush = 1;//1有效使得寄存器清空
			end
			else
			begin
				pc_write = 1;
				if_id_write = 1;
				id_exe_flush = 0;
			end
		end
		else if(instruction_ir[31:26] != 6'b100011 && instruction_ir[31:26] != 6'b000000)
		//sw指令或者I型指令
		begin
			if(instruction_lw[20:16] == instruction_ir[25:21])
			begin
				pc_write = 0;
				if_id_write = 0;
				id_exe_flush = 1;//1有效使得寄存器清空
			end
			else
			begin
				pc_write = 1;
				if_id_write = 1;
				id_exe_flush = 0;
			end
		end
	end
	else
	begin
		pc_write = 1;
		if_id_write = 1;
		id_exe_flush = 0;
	end
end
endmodule