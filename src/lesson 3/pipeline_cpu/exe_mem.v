module exe_mem(
			   input [31:0] npc_in,c_in,b_in,
			   output reg [31:0] npc_out,c_out,b_out,
			   input [4:0] num_write_in,
			   output reg [4:0] num_write_out,
			   input mem_write_in,
			   output reg mem_write_out,
			   input [1:0] s_data_write_in,
			   output reg [1:0] s_data_write_out,
			   input reg_write,
			   output reg reg_write_out,
			   input [31:0] instruction,
			   output reg [31:0] instruction_out,
			   input clock,
			   input reset,
			   input exe_mem_write
			   );

always@(posedge clock)
begin
	if(!reset)
		begin
		npc_out <= 32'h0000_3000;
		c_out <= 32'h0000_0000;
		b_out <= 32'h0000_0000;
		num_write_out <= 5'b00000;
		mem_write_out <= 0;
		s_data_write_out <= 0;
		reg_write_out <= 0;
		instruction_out <= 32'h0000_0000;
		end
	else 
		begin
		if(exe_mem_write==1)
			begin
			npc_out <= npc_in;
			c_out <= c_in;
			b_out <= b_in;
			num_write_out <= num_write_in;
			mem_write_out <= mem_write_in;
			s_data_write_out <= s_data_write_in;
			reg_write_out <= reg_write;
			instruction_out <= instruction;
			end
		end
end

endmodule
