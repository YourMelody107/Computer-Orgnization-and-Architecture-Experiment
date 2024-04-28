module dm(data_out,clock,mem_write,address,data_in); 

output [31:0] data_out; 

input clock;

input mem_write;

input [31:0] address;

input [31:0] data_in;



reg [31:0] data_memory[1023:0]; 

always@(posedge clock)
begin
	if(mem_write)//1有效
		data_memory[address[11:2]] <= data_in; 
end
assign data_out =  data_memory[address[11:2]];//读：组合逻辑

endmodule