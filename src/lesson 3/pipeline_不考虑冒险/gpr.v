module gpr(a,b,clock,reg_write,num_write,rs,rt,data_write);

    output [31:0] a;  
    output [31:0] b;
    input clock;
    input reg_write;
    input [4:0] rs;
    input [4:0] rt;
    input [4:0] num_write;
    input [31:0] data_write;
    reg [31:0] gp_registers[31:0];

    
    initial begin
	gp_registers[0]<=32'h0000_0000;  
    end

always @(posedge clock) 
	begin
		if(num_write !=0&&reg_write==1) 
			begin
			gp_registers[num_write]<=data_write;
			end
		else 
			begin
			gp_registers[num_write]<=gp_registers[num_write];
			end
	end

    assign a = gp_registers[rs];
    assign b = gp_registers[rt];

endmodule