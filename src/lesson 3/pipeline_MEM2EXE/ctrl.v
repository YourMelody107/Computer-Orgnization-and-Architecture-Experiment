module ctrl(reg_write,mem_write,s_data_write,s_num_write,s_b,ext,aluop,op,funct,s_npc);

	output reg reg_write;
	output reg [3:0] aluop;

	output reg [1:0] s_num_write;//rd寄存器值
	output reg s_b;//第二个寄存器值
	output reg ext;//零扩展
	output reg mem_write;

	output reg [1:0] s_data_write;
	output reg [1:0] s_npc;

	input [5:0] op;
	input [5:0] funct;

always@(*)
	begin
		case(op)
			6'b000000: 
				begin
					case(funct)
						6'b100001://addu
							begin 
								aluop<=4'b0000;
								ext<=0;
								mem_write<=0;
								reg_write<=1;
								s_b<=0;
								s_data_write<=2'b01;
								s_npc<=2'b11;
								s_num_write<=2'b01;
							end
						6'b100011://subu
							begin
								aluop<=4'b0001;
								ext<=0;
								mem_write<=0;
								reg_write<=1;
								s_b<=0;
								s_data_write<=2'b01;
								s_npc<=2'b11;
								s_num_write<=2'b01;
							end
						6'b100000://add
							begin
								aluop<=4'b0010;
								ext<=0;
								mem_write<=0;
								reg_write<=1;
								s_b<=0;
								s_data_write<=2'b01;
								s_npc<=2'b11;
								s_num_write<=2'b01;
							end
						6'b100100://and
							begin
								aluop<=4'b0011;
								ext<=0;
								mem_write<=0;
								reg_write<=1;
								s_b<=0;
								s_data_write<=2'b01;
								s_npc<=2'b11;
								s_num_write<=2'b01;
							end
						6'b100101://or
							begin 
								aluop<=4'b0100;
								ext<=0;
								mem_write<=0;
								reg_write<=1;
								s_b<=0;
								s_data_write<=2'b01;
								s_npc<=2'b11;
								s_num_write<=2'b01;
							end
						6'b101010://slt
							begin
								aluop<=4'b0101;
								ext<=0;
								mem_write<=0;
								reg_write<=1;
								s_b<=0;
								s_data_write<=2'b01;
								s_npc<=2'b11;
								s_num_write<=2'b01;
							end
						6'b001000://jr
							begin      
								reg_write<=0;
								s_npc<=2'b01;
							end
						default: 
							begin
								aluop<=4'b0000;
								mem_write<=0;
								reg_write<=1;
								s_data_write<=2'b01;
								s_num_write<=2'b01;
							end
					endcase 
				end
			6'b001000: //addi
				begin
					aluop<=4'b0110; 
					ext<=1;   //符号扩展
					mem_write <=0;
					reg_write<=1;
					s_b<=1;
					s_data_write<=2'b01;
					s_npc<=2'b11;
					s_num_write<=2'b00;
				end
			6'b001001:  //addiu
				begin
					aluop<=4'b0111; 
					ext<=1;   //符号扩展
					mem_write<=0;
					reg_write<=1;
					s_b<=1;
					s_data_write<=2'b01;
					s_npc<=2'b11;
					s_num_write<=2'b00;
				end
	
			6'b001100: //andi
				begin 
					aluop<=4'b1000;   
					ext<=0;   //零扩展
					mem_write<=0;
					reg_write<=1;
					s_b<=1;
					s_data_write<=2'b01;
					s_npc<=2'b11;
					s_num_write<=2'b00;	
				end
			6'b001101: //ori
				begin
					aluop<=4'b1001;   
					ext<=0;    //零扩展
					mem_write<=0;
					reg_write<=1;
					s_b<=1;
					s_data_write<=2'b01;
					s_npc<=2'b11;
					s_num_write<=2'b00;
				end
			6'b001111: //lui
				begin
					aluop<=4'b1010; 
					ext<=0;							
					mem_write<=0;
					reg_write<=1;
					s_b<=1;
					s_data_write<=2'b01;
					s_npc<=2'b11;
					s_num_write<=2'b00;
				end	
			6'b101011: //sw
				begin
					aluop<=4'b1011;   
					ext<=1;	
					mem_write<=1;
					reg_write<=0;
					s_b<=1;
					s_npc<=2'b11;
					s_num_write<=2'b00;
				end	
			6'b100011: //lw
				begin
					aluop<=4'b1100;  
					ext<=1;
					mem_write<=0;
					reg_write<=1;
					s_b<=1;	
					s_data_write<=2'b10;
					s_npc<=2'b11;
					s_num_write<=2'b00;
				end	
			6'b000010: //j
				begin  
					mem_write<=0;
					reg_write<=0;
					s_npc<=2'b10;
				end
	
			6'b000011://jal 
				begin  
					reg_write<=1;
					s_data_write<=2'b00;
					s_npc<=2'b10;
					s_num_write<=2'b10;
				end
	
			6'b000100://beq 
				begin  
					aluop<=4'b1101;
					ext<=1;
					reg_write<=0;
					s_b<=0;
					s_npc<=2'b00;					
				end

			default: 
				begin
					aluop<=4'bxxxx;
					mem_write<=1'bx;
					reg_write<=1'bx;
					s_data_write<=2'bxx;
					s_num_write<=2'bxx;	
				end
	endcase
end

endmodule








