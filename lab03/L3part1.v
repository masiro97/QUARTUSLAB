module L3part1(sw0,sw1,sw2,sw3,HEX0,HEX1,HEX2,HEX3);
	input[3:0] sw0,sw1,sw2,sw3;
	output [0:6] HEX0,HEX1,HEX2,HEX3;
	
	display_7seg H0(sw0,HEX0);
	display_7seg H1(sw1,HEX1);
	display_7seg H2(sw2,HEX2);
	display_7seg H3(sw3,HEX3);
	

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
											 7'b1111111;
endmodule
