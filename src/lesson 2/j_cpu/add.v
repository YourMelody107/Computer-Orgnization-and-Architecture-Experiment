module add(out_add, add1, add2);
output [31:0] out_add;
input [31:0] add1, add2;

assign out_add = add1 + add2;

endmodule