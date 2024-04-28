module pc(pc,clock,reset,npc);

output [31:0] pc;

input clock;

input reset;

input [31:0] npc;

reg [31:0] pc;

always@(posedge clock)
begin
	if(!reset)
		pc <= 32'h00003000;
	else
		pc <= npc;

end

endmodule




