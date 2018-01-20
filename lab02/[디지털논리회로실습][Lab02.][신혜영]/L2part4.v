module L2part4(c,led,HEX0);

	input[2:0]c; 
	output [2:0]led; //led connected c
	output [0:6]HEX0; // 7seg showing alphabet
	
	assign HEX0 = (c ==3'b000) ? 7'b1001000: // alphabet 'H'
					  (c ==3'b001) ? 7'b0110000: // alphabet 'E'
					  (c ==3'b010) ? 7'b1110001: // alphabet 'L'
					  (c ==3'b011) ? 7'b0000001: // alphabet 'O'
										  7'b1111111; // blank
endmodule
