module dm(data_out,clock,mem_write,address,data_in); 

output [31:0] data_out; 

input clock;

input mem_write;

input [31:0] address;

input [31:0] data_in;

reg [31:0] data_memory[1023:0]; //4K数据存储器
reg [31:0] data_out;
//读数据
always@(*)
begin
	data_out = data_memory[address[11:0]>>2];
end

//写数据，时序逻辑
always@(posedge clock)
begin
	if(mem_write)
		data_memory[address[11:0]>>2] = data_in;
end

endmodule

