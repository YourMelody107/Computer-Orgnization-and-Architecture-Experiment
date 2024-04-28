module if_id(clock,reset,ins_IF_ID,npc_IF_ID,ins,pc3);

	input clock,reset;

	input [31:0] ins;

	input [31:0] pc3;	//在J型单周期CPU中用pc3表示pc+4

	output reg [31:0]ins_IF_ID;
	output reg [31:0]npc_IF_ID;

always@(posedge clock) 
	begin
		if(reset) 
			begin
				ins_IF_ID<=ins;
				npc_IF_ID<=pc3;
			end
		else 
			begin
				ins_IF_ID<=32'h0000_0000;
				npc_IF_ID<=32'h0000_0000;
			end
	end

endmodule