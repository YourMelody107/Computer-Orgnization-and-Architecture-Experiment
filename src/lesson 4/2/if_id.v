module if_id(clock,reset,npc_if,instruction_if,if_id_write,if_id_flush,npc_id,instruction_id);
	input clock;
	input reset;
	input [31:0] npc_if;
	input [31:0] instruction_if;
	input if_id_write;
	input if_id_flush;
	output reg [31:0] npc_id;
	output reg [31:0] instruction_id;
	always@(posedge clock)
	begin
		if(!reset)
		begin
			npc_id			<=	0;
			instruction_id	<=	0;
		end
		else if(if_id_write)
		begin
			npc_id			<=	npc_if;
			instruction_id	<=	if_id_flush	?0:instruction_if;
		end
		else
		begin
			npc_id			<=	npc_id;
			instruction_id	<=	if_id_flush	?0:instruction_id;
		end
	end
endmodule