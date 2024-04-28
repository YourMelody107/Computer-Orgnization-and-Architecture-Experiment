module pc(pc,clock,reset,npc);
output reg [31:0] pc;  //当前指令地址
input clock;
input reset;
input [31:0] npc;  //下条指令地址


always@(posedge clock)
	begin
	if(!reset)
		pc<=32'h0000_3000;
	else pc<=npc;
	end

assign npc = pc + 4;

endmodule