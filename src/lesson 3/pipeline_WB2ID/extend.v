module extend(imm_16,ext,extend);

	input [15:0]imm_16;//16位立即数
	input ext;
	output reg [31:0]extend;//扩展后32位立即数

always@(imm_16,ext)		//将指令低16位表示的立即数扩展为32位立即数
	begin
		if(ext)		//如果ext不为零，则进行符号扩展
			extend<={{16{imm_16[15]}},imm_16};	
		else 		 //如果ext为零，则进行零扩展
			begin
			extend[15:0]=imm_16;
			extend[31:16]=16'h0000;
			end
	end

endmodule
