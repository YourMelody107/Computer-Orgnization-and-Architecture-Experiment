module if_id(clock,reset,w_IF_ID,ins,ins_IF_ID);

	input clock,reset;
	input w_IF_ID;

	output [31:0] ins;
	output reg [31:0] ins_IF_ID;


always @(posedge clock)
begin
    if(!reset)
	     ins_IF_ID<=0;
	 else
	    if(w_IF_ID)
	     ins_IF_ID<=ins;
end 

endmodule