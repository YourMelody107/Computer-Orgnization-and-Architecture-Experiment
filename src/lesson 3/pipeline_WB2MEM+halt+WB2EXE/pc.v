module pc(pc,clock,reset,npc,pc_write);

	output reg[31:0] pc; 
	input clock;
	input reset;
	input [31:0] npc;
	input pc_write;

always @(posedge clock) 
begin
	if (!reset) 
		pc <= 32'h0000_3000;
	else  
		if(pc_write)
			pc <= npc;

end
endmodule


