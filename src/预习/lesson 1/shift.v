module shift #(parameter WIDTH=8)(
   output  [WIDTH-1 : 0] q, //输出
   input   [WIDTH-1 : 0] in, //输入
   input   clock,
   input   set,    //输入控制信号，set=1时，并行同步输入；
                   //set=0时，正常循环移位工作
   input   reset); //异步复位，低电平有效
   reg [WIDTH-1 : 0] reg1;
   
always@(posedge clock, negedge reset)
begin
	if(!reset) begin
		reg1[WIDTH-1 : 0]<=8'b00000000;//reset低电平有效
	end
	else begin
		if(set==1) begin//并行同步输入
			reg1<=in;
		end
		else begin
			reg1[WIDTH-1]<=reg1[0];
			reg1[WIDTH-2:0]<=reg1[WIDTH-1:1];
		end
	end
end

assign q[WIDTH-1 : 0]=reg1[WIDTH-1 : 0];

endmodule