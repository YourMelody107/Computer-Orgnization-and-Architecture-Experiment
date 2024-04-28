module im(instruction,pc);

output [31:0] instruction;
input [31:0] pc;

reg [31:0] ins_memory[1023:0]; //4k指令存储器
//im模块的输入pc为32位，但指令存储器只有4kB大小
//所以取指令时只取pc的低12位作为地址。

wire [11:0] low12bit;

assign low12bit=pc[11:2];//好像由结果可知默认pc低两位不读
assign instruction=ins_memory[low12bit];

endmodule