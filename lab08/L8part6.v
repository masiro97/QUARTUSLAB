module L8part6(S,sw,clk,LEDG,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7);
	input clk;
	input [17:0] sw; //17 write 16 select 15-8:A,C 7-0:B,D
	output reg[15:0]S;
	output [0:6]HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;
	output LEDG; //LEDG8 cout
	reg [3:0] A,B,C,D;
	reg overflow;
	assign LEDG = overflow;
	always @(posedge clk) begin
		

				if(sw[16] == 1) begin
					 A = sw[15:8];
					 B = sw[7:0];
				end
				if(sw[16] == 0) begin
				
					C = sw[15:8];
					D = sw[7:0];
					
				end
				
			if(sw[17] == 1) begin
				S <= (A*B) + (C*D);
				
			end
		
	end
	
	wire [3:0]onesA,tensA,onesB,tensB,onesS,tensS,hundS,thouS;
	assign onesA = sw[15:8] % 16;
   assign tensA = (sw[15:8] - onesA) / 16;
   assign onesB = sw[7:0] % 16;
   assign tensB = (sw[7:0] - onesB) / 16;
	assign onesS = (S % 4096) % 256 % 16;
	assign tensS = ((S % 4096 % 256) - onesS) /16;
	assign hundS = (S - tensS * 16 - onesS) / 256;
	assign thouS = (S - hundS * 256 - tensS *16 - onesS) / 4096;
	display_7seg d7(tensA,HEX7);
	display_7seg d6(onesA,HEX6);
	display_7seg d5(tensB,HEX5);
	display_7seg d4(onesB,HEX4);
	display_7seg d3(thouS,HEX3);
	display_7seg d2(hundS,HEX2);
	display_7seg d1(tensS,HEX1);
	display_7seg d0(onesS,HEX0);
	
endmodule


module display_7seg(sw,HEX);

	input[3:0] sw;
	output [0:6]HEX;
	
	assign HEX = (sw == 4'b0000) ? 7'b0000001: //0
					 (sw == 4'b0001) ? 7'b1001111: //1
					 (sw == 4'b0010) ? 7'b0010010: //2
					 (sw == 4'b0011) ? 7'b0000110: //3
					 (sw == 4'b0100) ? 7'b1001100: //4
					 (sw == 4'b0101) ? 7'b0100100: //5
					 (sw == 4'b0110) ? 7'b0100000: //6
					 (sw == 4'b0111) ? 7'b0001101: //7
					 (sw == 4'b1000) ? 7'b0000000: //8
					 (sw == 4'b1001) ? 7'b0000100: //9
					 (sw == 4'b1010) ? 7'b0001000:
					 (sw == 4'b1011) ? 7'b1100000:
					 (sw == 4'b1100) ? 7'b0110001:
					 (sw == 4'b1101) ? 7'b1000010:
					 (sw == 4'b1110) ? 7'b0110000:
					 (sw == 4'b1111) ? 7'b0111000: 7'b1111111;
	
endmodule

module FA(a,b,cin,s,cout); //full-adder module

	input a,b,cin;
	output s,cout;
	
	assign cout = (b & cin) | (a & cin) | (a & b); //assign cout
	assign s = a ^ b ^ cin; //assign s
	
endmodule
