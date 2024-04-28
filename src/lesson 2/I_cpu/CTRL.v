`include "HEADER.v"

module ctrl(aluop,op,funct,s_num_write,s_ext,s_b);

output reg [3:0] aluop;
input [5:0] op;
input [5:0] funct;
output reg s_num_write,s_ext,s_b;

always@(*)
	begin
	if(op==0) //op
		begin
		case(funct)
		`FUNCT_ADDU:aluop=`add;//addu
		`FUNCT_SUBU:aluop=`sub;//subu
		`FUNCT_ADD:aluop=`add;//add
		`FUNCT_AND:aluop=`and;//and
		`FUNCT_OR:aluop=`or;//or
		`FUNCT_SLT:aluop=`slt;//slt
		default:aluop=`and;
		endcase
		s_num_write=1;
		s_b=0;
		end
	else
		begin
		case(op)
		`opaddi:begin
			aluop=`add;
			s_ext=1;
			end
		`opaddiu:begin
			aluop=`add;
			s_ext=0;
			end
		`opandi:begin
			aluop=`and;
			s_ext=0;
			end
		`opori:begin
			aluop=`or;
			s_ext=0;
			end
		`oplui:begin
			aluop=`lui;
			s_ext=0;
			end
		endcase
		s_num_write=0;
		s_b=1;
		end
	end

endmodule