module decider (
output[1:0] result,  //0:不合格; 1:合格; 2:优秀
input [7:0] in1,
input [7:0] in2,
input [7:0] in3,
input [7:0] in4,
input [7:0] in5,
input [7:0] in6,
input [7:0] in7,
input [7:0] in8  );

reg [7:0] ave;
reg [1:0] tempresult;

always@(in1, in2, in3, in4, in5, in6, in7, in8)
  begin
  ave=(in1+in2+in3+in4+in5+in6+in7+in8)/8;
  if(ave>=8) tempresult=2'b10;
  else if(ave>=6) tempresult=2'b01;
  else tempresult=2'b00;
  end
assign result=tempresult;
endmodule