module gpr(a,b,clock,reg_write,num_write,rs,rt,data_write);
	output [31:0] a;  //寄存器1的值
	output [31:0] b;  //寄存器2的值
	input clock;
	input reg_write;  //写使能信号
	input [4:0] rs; //读寄存器1编号
	input [4:0] rt; //读寄存器2编号
	input [4:0] num_write; //写寄存器编号
	input [31:0] data_write; //写数据

	reg [31:0] gp_registers[31:0]; 
	
	always@(posedge clock)
	begin
		if(reg_write && num_write!=0)
		begin
			gp_registers[num_write]<=data_write;
		end
	end
	
	assign a=gp_registers[rs];
	assign b=gp_registers[rt];
endmodule
