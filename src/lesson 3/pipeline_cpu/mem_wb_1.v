module mem_wb(
			  //????
			  input [31:0] npc_in,
			  output reg [31:0] npc_out,
			  input [31:0] c_in,
			  output reg [31:0] c_out,
			  input [31:0] mem_data_out_in,
			  output reg [31:0] mem_data_out_out,
			  input [4:0] num_write_in,
			  output reg [4:0] num_write_out,
			  //??????
			  input [1:0] s_data_write_in,
			  output reg [1:0] s_data_write_out,
			  
			  input reg_write,
			  output reg reg_write_out,
			  input [31:0] instruction,
			  output reg [31:0] instruction_out,
			  input clock,
			  input reset,
			  input mem_wb_write
			  );

always@(posedge clock)
begin
	if(!reset)
	begin
		npc_out <= 32'h0000_3000;
		c_out <= 32'h0000_0000;
		mem_data_out_out <= 32'h0000_0000;
		num_write_out <= 5'b00000;
		s_data_write_out <= 2'b00;
		reg_write_out <= 1'b0;
		instruction_out <= 32'h0000_0000;
		
	end
	else 
	begin 
	if(mem_wb_write)
	begin
		npc_out <= npc_in;
		c_out <= c_in;
		mem_data_out_out <=mem_data_out_in;
		num_write_out <= num_write_in;
		s_data_write_out <= s_data_write_in;
		reg_write_out <= reg_write;
		instruction_out <= instruction;
	end
	end
end

endmodule
