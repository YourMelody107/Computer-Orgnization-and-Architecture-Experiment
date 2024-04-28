module gpr(a,b,clock,reg_write,num_write,rs,rt,data_write);

output [31:0] a;  

output [31:0] b;

input clock;

input reg_write;

input [4:0] rs; //????1

input [4:0] rt; //????2

input [4:0] num_write; //????

input [31:0] data_write; //???

reg [31:0] gp_registers[31:0];  //32????

reg [31:0] a;
reg [31:0] b;


//?????????
always@(posedge clock)
begin
	if(reg_write && num_write != 0)	
		gp_registers[num_write] <= data_write;
end

//?????
always@(*)
begin
	 a = gp_registers[rs];
	 b = gp_registers[rt];
end
endmodule



