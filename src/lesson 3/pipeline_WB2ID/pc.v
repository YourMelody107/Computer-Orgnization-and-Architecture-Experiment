module pc(pc,clock,reset,npc,w);

output reg [31:0] pc;
input clock;
input reset;
input [31:0] npc;

input w;

always@(posedge clock) 
begin
	if(w==0) 
		pc<=npc;
	else if(reset==0)
		pc<=32'h0000_3000;
end
endmodule
  