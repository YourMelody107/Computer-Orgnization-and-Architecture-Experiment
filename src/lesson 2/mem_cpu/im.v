module im(instruction,pc);
output [31:0] instruction;
input [31:0] pc;
//指令存储器只有4k大小，所以pc低12位地址有效（屏蔽掉高位）
reg [31:0] ins_memory[1023:0]; //4kB指令存储器

assign instruction = ins_memory[pc[11:2]];

endmodule