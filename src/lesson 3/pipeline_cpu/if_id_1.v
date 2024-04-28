/*
????????????????????????npc(?????????)
???????????????????????
*/
module if_id(
			 input [31:0] npc_in,
			 output reg [31:0] npc_out,
			 //output [1:0] s_npc,???????????npc??pc+4
			 input [31:0] instruction_in,
			 output reg [31:0] instruction_out,
			 
			 input clock,
			 input reset,//reset???????????
			 input if_id_write//if_id????????????
			 );

always@(posedge clock)
begin
	if(!reset)//???????
	begin
		npc_out <= 32'h0000_3000;
		instruction_out <= 32'h0000_0000;
	end
	else 
	begin
	if(if_id_write)//?????????????
	begin
		npc_out <= npc_in;
		instruction_out <= instruction_in;
	end
	end
end

endmodule