`timescale 1ns/1ns
module tb_pipeline_cpu;

reg clock,reset;

pipeline_cpu PIPELINE_CPU(clock,reset);
integer i;
initial 
begin 
  
  $readmemh("F:/s_cycle_cpu/code01.txt",S_CYCLE_CPU.IM.ins_memory);//得到的汇编码
$monitor("PC=0x%8X",S_CYCLE_CPU.PC.pc);
clock=1;
reset=0;
for(i=0;i<=31;i=i+1)
PIPELINE_CPU.GPR.gp_registers[i]=0;

//PIPELINE_CPU.GPR.gp_registers[31]=32'h0000_303c;

#20
reset=1; 
end
always
begin
fork
#50 clock=~clock;
#200 $monitor("PC=0x%8X Aluop=0x%4b\n a=0x%8h b=0x%8h c=0x%8h",
PIPELINE_CPU.PC.pc,PIPELINE_CPU.ALU.aluop,PIPELINE_CPU.ALU.a,PIPELINE_CPU.ALU.b,PIPELINE_CPU.ALU.c);
join
end

pipeline_cpu UUT_pipeline_cpu(.clock(clock),.reset(reset));
endmodule
