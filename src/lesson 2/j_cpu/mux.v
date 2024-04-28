module mux22 #(parameter width = 32) (out, s, d0, d1);

output [width-1:0] out;
input s;
input [width-1:0] d0, d1;

assign out = s? d1: d0;

endmodule



module mux33 #(parameter width = 32) (out, s, d0, d1, d2);

output reg [width-1:0] out;
input [1:0] s;
input [width-1:0] d0, d1, d2;

always @(s or d0 or d1 or d2) 
begin
    case(s)
        2'b00: out = d0;
        2'b01: out = d1;
        2'b10: out = d2;
    endcase
end

endmodule



module mux44 #(parameter width = 32) (out, s, d0, d1, d2, d3);

output reg [width-1:0] out;
input [1:0] s;
input [width-1:0] d0, d1, d2, d3;

always @(s or d0 or d1 or d2 or d3) 
begin
    case(s)
        2'b00: out = d0;
        2'b01: out = d1;
        2'b10: out = d2;
        2'b11: out = d3;
    endcase
end

endmodule