module alu(c,a,b);

output [31:0] c;
input [31:0] a;
input [31:0] b;

//目前只是实现 + 功能。
//其他功能和输入输出信号根据需要慢慢添加

assign c=a+b;

endmodule