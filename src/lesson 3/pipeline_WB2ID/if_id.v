module if_id(clock,reset,ins,pc3,ins_IF_ID,npc_IF_ID,w_IF_ID);

	input clock,reset;

	input [31:0] ins;

	input [31:0] pc3;	//在J型单周期CPU中用pc3表示pc+4

	output reg [31:0]ins_IF_ID;
	output reg [31:0]npc_IF_ID;

	input w_IF_ID;

always@(posedge clock) 
	begin
		if(w_IF_ID==0) 
			begin
				ins_IF_ID<=ins;
				npc_IF_ID<=pc3;
			end
		else if(reset==0)
			begin
				ins_IF_ID<=32'h0000_0000;
				npc_IF_ID<=32'h0000_0000;
			end
	end

endmodule