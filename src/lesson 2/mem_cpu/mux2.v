module mux2 #(parameter width = 32) (out, s, d0, d1);

output [width-1:0] out;
input s;
input [width-1:0] d0, d1;

assign out = s? d1: d0;

endmodule