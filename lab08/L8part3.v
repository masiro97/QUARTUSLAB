module L8part3(A,B,HEX6,HEX4,HEX1,HEX0);
	input [3:0]A,B;
	output [0:6] HEX0,HEX1,HEX4,HEX6;
	
	wire [3:0] pp0,pp1,pp2,pp3;
	wire s0,s1,s2,s3,s4,s5;
	wire c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10;
	wire [7:0]P;
	wire [3:0] onesP,tensP;
	assign onesP = P % 16;
	assign tensP = (P - onesP) / 16;
	
	calculator cc1 (A,B[0],pp0[3:0]);
	calculator cc2 (A,B[1],pp1[3:0]);
	calculator cc3 (A,B[2],pp2[3:0]);
	calculator cc4 (A,B[3],pp3[3:0]);
	
	display_7seg d6(A,HEX6);
	display_7seg d4(B,HEX4);
	display_7seg d1(tensP,HEX1);
	display_7seg d0(onesP,HEX0);
	
	assign P[0] = pp1[0];
	
	FA f0(pp0[1],pp1[0],0,P[1],c0);
	FA f1(pp0[2],pp1[1],c0,s0,c1);
	FA f2(pp0[3],pp1[2],c1,s1,c2);
	FA f3(0,pp1[3],c2,s2,c3);
	
	FA f4(s0,pp2[0],0,P[2],c4);
	FA f5(s1,pp2[1],c4,s3,c5);
	FA f6(s2,pp2[2],c5,s4,c6);
	FA f7(c3,pp2[3],c6,s5,c7);
	
	FA f8(s3,pp3[0],0,P[3],c8);
	FA f9(s4,pp3[1],c8,P[4],c9);
	FA f10(s5,pp3[2],c9,P[5],c10);
	FA f11(c7,pp3[3],c10,P[6],P[7]);
	
endmodule

module calculator(a,b,pp);
	input [3:0]a;
	input b;
	output[3:0] pp;
	
	assign pp[0] = a[0] & b;
	assign pp[1] = a[1] & b;
	assign pp[2] = a[2] & b;
	assign pp[3] = a[3] & b;

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

