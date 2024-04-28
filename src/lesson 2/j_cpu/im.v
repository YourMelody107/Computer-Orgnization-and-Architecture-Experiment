module im(instruction,pc);



output reg[31:0] instruction;

input [31:0] pc;


reg [31:0] ins_memory[1023:0]; //4k指令存储器

// 取指令时只取pc的低12位作为地址
reg [31:0] addr;
always @(*)
begin
addr = pc[11:0];
// 将指令存储器中对应地址的指令输出
instruction = ins_memory[addr>>2];
end 
endmodule