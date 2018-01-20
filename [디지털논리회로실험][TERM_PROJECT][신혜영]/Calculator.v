module Calculator(sw,key,clk,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7,LEDR);

	input [17:0]sw;
	input [3:0]key;
	input clk;
	output [0:6] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;
	output [17:0] LEDR;
	
	wire [14:0] num1, num2;
	wire [14:0] result,result0,result1,result2,result3,result4,result5;
	wire [14:0] result33,result6,result7,result8,result9,result10;
	
	wire [14:0] newNum1;
	wire [14:0] lastnum1,lastnum2,lastNum1;
	wire [3:0] op;
	wire [14:0] lastResult,temp;
	assign num1 = {sw[5],9'b000000000,sw[4:0]};
	assign num2 = {sw[11],9'b000000000,sw[10:6]};
	assign op = sw[15:12];
	assign LEDR = sw;
	
	mul m0(num1,15'b000000001100100,newNum1);
	add ad(15'b000000000000001,~result,temp);
	
	isNegative n0(num1,lastnum1);
	isNegative n1(num2,lastnum2);
	isNegative n2(newNum1,lastNum1);

	assign lastResult = (result[14] == 1) ? temp : result;
	
	add a(lastnum1,lastnum2,result0);
	sub s(lastnum2,lastnum1,result1);
	mul m(lastnum1,lastnum2,result2);
	div d(lastnum2,lastNum1,result3);
	rem r(lastnum2,lastnum1,result4);
	facf f(num1,result5);
	sinf sf(lastnum1,result6);
	cosf c(lastnum1,result7);
	tanf t(lastnum1,result8);
	squaref sq(lastnum1,result9);
	expf e(lastnum1,result10);
	
	assign result = (op == 4'b0001 & sw[17] == 1) ? result0 : // +
						 (op == 4'b0010 & sw[17] == 1) ? result1 : // -
						 (op == 4'b0011 & sw[17] == 1) ? result2 : // *
						 (op == 4'b0100 & sw[17] == 1) ? result3 : // /
						 (op == 4'b0101 & sw[17] == 1) ? result4 : // %
						 (op == 4'b0110 & sw[17] == 1 & num1 != 15'b000000000000111) ? result5 :
						 (op == 4'b0111 & sw[17] == 1) ? result6 :
						 (op == 4'b1000 & sw[17] == 1) ? result7 :
						 (op == 4'b1001 & sw[17] == 1) ? result8 :
						 (op == 4'b1010 & sw[17] == 1) ? result9 :
						 (op == 4'b1011 & sw[17] == 1) ? result10 : 15'b000000000000000;
	
	wire [14:0] in_ones1,in_tens1,in_ones2,in_tens2;
	wire [14:0] ones,tens,hundreds,thous;
	wire [14:0] temp1,temp2,temp3,temp4,temp5,temp6,temp7,temp8;
	wire [14:0] temp9,temp15,temp16;
	wire [14:0] chun,bak,sib;
	
	assign chun = 15'b000001111111100;
	assign bak = 15'b000000001100100;
	assign sib = 15'b000000000001010;
	
	rem r0(chun,lastResult,temp1);
	rem r1(bak,temp1,temp2);
	rem r2(sib,temp2,ones);
	
	rem r3(chun,lastResult,temp3);
	rem r4(bak,temp3,temp4);
	sub s0(ones,temp4,temp5);
	div d0(sib,temp5,tens);
	
	mul mm0(sib,tens,temp6);
	rem r5(chun,lastResult,temp7);
	sub s1(temp6,temp7,temp8);
	sub s2(ones,temp8,temp9);
	div d1(bak,temp9,hundreds);
	
	rem r6(sib,{1'b0,num1[13:0]},in_ones1);
	sub s6(in_ones1,{1'b0,num1[13:0]},temp15);
	div d3(sib,temp15,in_tens1);
	
	rem r7(sib,{1'b0,num2[13:0]},in_ones2);
	sub s7(in_ones2,{1'b0,num2[13:0]},temp16);
	div d4(sib,temp16,in_tens2);
	
	wire [14:0] h0,h1;
	wire n;
	assign n = (num1[14] ^ num2[14]) & ~sw[15] & sw[14] & ~sw[13];
	assign h0 = (num1 == 15'b000000100111010) ? 15'b000000000000000 : in_ones1;
	assign h1 = (num1 == 15'b000000100111010) ? 15'b000000000000000 : in_tens1;
	
	display_7seg ds0(ones[3:0],HEX0);
	display_7seg ds1(tens[3:0],HEX1);
	display_7seg ds2(hundreds[3:0],HEX2);
	assign HEX3 = (result[14] == 1'b1 | n) ? 7'b1111110 : 7'b1111111;
	display_7seg ds4(in_ones2[3:0],HEX4);
	display_7seg ds5(in_tens2[3:0],HEX5);
	display_7seg ds6(h0[3:0],HEX6);
	display_7seg ds7(h1[3:0],HEX7);
	
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
                (sw == 4'b1001) ? 7'b0000100: 7'b1111111; //F else nothing
   
endmodule

module add(A,result,resultA);

	input [14:0]A;
	input [14:0]result;
	output [14:0]resultA;
	
	wire [15:0] c;
	wire [15:0] S;
	wire [14:0] a = A;
	assign c[0] = 0;
	
	FA f0(a[0],result[0],c[0],S[0],c[1]);
	FA f1(a[1],result[1],c[1],S[1],c[2]);
	FA f2(a[2],result[2],c[2],S[2],c[3]);
	FA f3(a[3],result[3],c[3],S[3],c[4]);
	FA f4(a[4],result[4],c[4],S[4],c[5]);
	FA f5(a[5],result[5],c[5],S[5],c[6]);
	FA f6(a[6],result[6],c[6],S[6],c[7]);
	FA f7(a[7],result[7],c[7],S[7],c[8]);
	FA f8(a[8],result[8],c[8],S[8],c[9]);
	FA f9(a[9],result[9],c[9],S[9],c[10]);
	FA f10(a[10],result[10],c[10],S[10],c[11]);
	FA f11(a[11],result[11],c[11],S[11],c[12]);
	FA f12(a[12],result[12],c[12],S[12],c[13]);
	FA f13(a[13],result[13],c[13],S[13],c[14]);
	FA f14(a[14],result[14],c[14],S[14],S[15]);
	
	assign resultA = S[14:0];
	
endmodule

module isNegative(A,result);
	
	input [14:0]A;
	output [14:0]result;
	
	wire [13:0] Atemp;
	wire [14:0] resultemp;
	assign Atemp = ~A[13:0];
	
	add a1(15'b000000000000001,{1'b1,Atemp},resultemp);
	
	assign result = (A[14] == 1) ? resultemp : A;

endmodule

module sub(A,result,resultA);

	input [14:0]A;
	input [14:0]result;
	output [14:0]resultA;
	
	wire [15:0] c;
	wire [15:0] S;
	wire [14:0] B;
	
	assign B = ~A;
	assign c[0] = 1;
	
	FA f0(B[0],result[0],c[0],S[0],c[1]);
	FA f1(B[1],result[1],c[1],S[1],c[2]);
	FA f2(B[2],result[2],c[2],S[2],c[3]);
	FA f3(B[3],result[3],c[3],S[3],c[4]);
	FA f4(B[4],result[4],c[4],S[4],c[5]);
	FA f5(B[5],result[5],c[5],S[5],c[6]);
	FA f6(B[6],result[6],c[6],S[6],c[7]);
	FA f7(B[7],result[7],c[7],S[7],c[8]);
	FA f8(B[8],result[8],c[8],S[8],c[9]);
	FA f9(B[9],result[9],c[9],S[9],c[10]);
	FA f10(B[10],result[10],c[10],S[10],c[11]);
	FA f11(B[11],result[11],c[11],S[11],c[12]);
	FA f12(B[12],result[12],c[12],S[12],c[13]);
	FA f13(B[13],result[13],c[13],S[13],c[14]);
	FA f14(B[14],result[14],c[14],S[14],S[15]);
	
	assign resultA = S[14:0];
	
endmodule

module mul(A,result,resultA);
	
	input [14:0]A;
	input [14:0]result;
	output [14:0]resultA;
	
	wire [14:0] pp0, pp1, pp2, pp3, pp4, pp5, pp6, pp7, pp8;
	wire [14:0] pp9, pp10, pp11, pp12, pp13, pp14;
	wire [29:0] P;
	wire [15:0] c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13,c14;
	wire s2,s27;
	wire [1:0] s3,s26;
	wire [2:0] s4,s25;
	wire [3:0] s5,s24;
	wire [4:0] s6,s23;
	wire [5:0] s7,s22;
	wire [6:0] s8,s21;
	wire [7:0] s9,s20;
	wire [8:0] s10,s19;
	wire [9:0] s11,s18;
	wire [10:0] s12,s17;
	wire [11:0] s13,s16;
	wire [12:0] s14,s15;
	
	calPP p0(A,result[0],pp0);
	calPP p1(A,result[1],pp1);
	calPP p2(A,result[2],pp2);
	calPP p3(A,result[3],pp3);
	calPP p4(A,result[4],pp4);
	calPP p5(A,result[5],pp5);
	calPP p6(A,result[6],pp6);
	calPP p7(A,result[7],pp7);
	calPP p8(A,result[8],pp8);
	calPP p9(A,result[9],pp9);
	calPP p10(A,result[10],pp10);
	calPP p11(A,result[11],pp11);
	calPP p12(A,result[12],pp12);
	calPP p13(A,result[13],pp13);
	calPP p14(A,result[14],pp14);
	
	assign P[0] = pp0[0];
	assign c1[0] = 0;
	assign c2[0] = 0;
	assign c3[0] = 0;
	assign c4[0] = 0;
	assign c5[0] = 0;
	assign c6[0] = 0;
	assign c7[0] = 0;
	assign c8[0] = 0;
	assign c9[0] = 0;
	assign c10[0] = 0;
	assign c11[0] = 0;
	assign c12[0] = 0;
	assign c13[0] = 0;
	assign c14[0] = 0;
	
	//P[1]
	FA f0(pp0[1],pp1[0],c1[0],P[1],c1[1]);
	
	//P[2]
	
	FA f1(pp0[2],pp1[1],c1[1],s2,c1[2]);
	FA f2(pp2[0],s2,c2[0],P[2],c2[1]);
	
	//P[3]
	
	FA f3(pp0[3],pp1[2],c1[2],s3[0],c1[3]);
	FA f4(pp2[1],s3[0],c2[1],s3[1],c2[2]);
	FA f5(pp3[0],s3[1],c3[0],P[3],c3[1]);
	
	//P[4]
	
	FA f6(pp0[4],pp1[3],c1[3],s4[0],c1[4]);
	FA f7(pp2[2],s4[0],c2[2],s4[1],c2[3]);
	FA f8(pp3[1],s4[1],c3[1],s4[2],c3[2]);
	FA f9(pp4[0],s4[2],c4[0],P[4],c4[1]);
	
	//P[5]
	
	FA f10(pp0[5],pp1[4],c1[4],s5[0],c1[5]);
	FA f11(pp2[3],s5[0],c2[3],s5[1],c2[4]);
	FA f12(pp3[2],s5[1],c3[2],s5[2],c3[3]);
	FA f13(pp4[1],s5[2],c4[1],s5[3],c4[2]);
	FA f14(pp5[0],s5[3],c5[0],P[5],c5[1]);
	
	//P[6]
	
	FA f15(pp0[6],pp1[5],c1[5],s6[0],c1[6]);
	FA f16(pp2[4],s6[0],c2[4],s6[1],c2[5]);
	FA f17(pp3[3],s6[1],c3[3],s6[2],c3[4]);
	FA f18(pp4[2],s6[2],c4[2],s6[3],c4[3]);
	FA f19(pp5[1],s6[3],c5[1],s6[4],c5[2]);
	FA f20(pp6[0],s6[4],c6[0],P[6],c6[1]);
	
	//P[7]
	
	FA f21(pp0[7],pp1[6],c1[6],s7[0],c1[7]);
	FA f22(pp2[5],s7[0],c2[5],s7[1],c2[6]);
	FA f23(pp3[4],s7[1],c3[4],s7[2],c3[5]);
	FA f24(pp4[3],s7[2],c4[3],s7[3],c4[4]);
	FA f25(pp5[2],s7[3],c5[2],s7[4],c5[3]);
	FA f26(pp6[1],s7[4],c6[1],s7[5],c6[2]);
	FA f27(pp7[0],s7[5],c7[0],P[7],c7[1]);
	
	//P[8]
	
	FA f28(pp0[8],pp1[7],c1[7],s8[0],c1[8]);
	FA f29(pp2[6],s8[0],c2[6],s8[1],c2[7]);
	FA f30(pp3[5],s8[1],c3[5],s8[2],c3[6]);
	FA f31(pp4[4],s8[2],c4[4],s8[3],c4[5]);
	FA f32(pp5[3],s8[3],c5[3],s8[4],c5[4]);
	FA f33(pp6[2],s8[4],c6[2],s8[5],c6[3]);
	FA f34(pp7[1],s8[5],c7[1],s8[6],c7[2]);
	FA f35(pp8[0],s8[6],c8[0],P[8],c8[1]);
	
	//P[9]
	
	FA f36(pp0[9],pp1[8],c1[8],s9[0],c1[9]);
	FA f37(pp2[7],s9[0],c2[7],s9[1],c2[8]);
	FA f38(pp3[6],s9[1],c3[6],s9[2],c3[7]);
	FA f39(pp4[5],s9[2],c4[5],s9[3],c4[6]);
	FA f40(pp5[4],s9[3],c5[4],s9[4],c5[5]);
	FA f41(pp6[3],s9[4],c6[3],s9[5],c6[4]);
	FA f42(pp7[2],s9[5],c7[2],s9[6],c7[3]);
	FA f43(pp8[1],s9[6],c8[1],s9[7],c8[2]);
	FA f44(pp9[0],s9[7],c9[0],P[9],c9[1]);
	
	//P[10]
	
	FA f45(pp0[10],pp1[9],c1[9],s10[0],c1[10]);
	FA f46(pp2[8],s10[0],c2[8],s10[1],c2[9]);
	FA f47(pp3[7],s10[1],c3[7],s10[2],c3[8]);
	FA f48(pp4[6],s10[2],c4[6],s10[3],c4[7]);
	FA f49(pp5[5],s10[3],c5[5],s10[4],c5[6]);
	FA f50(pp6[4],s10[4],c6[4],s10[5],c6[5]);
	FA f51(pp7[3],s10[5],c7[3],s10[6],c7[4]);
	FA f52(pp8[2],s10[6],c8[2],s10[7],c8[3]);
	FA f53(pp9[1],s10[7],c9[1],s10[8],c9[2]);
	FA f54(pp10[0],s10[8],c10[0],P[10],c10[1]);
	
	//P[11]
	
	FA f55(pp0[11],pp1[10],c1[10],s11[0],c1[11]);
	FA f56(pp2[9],s11[0],c2[9],s11[1],c2[10]);
	FA f57(pp3[8],s11[1],c3[8],s11[2],c3[9]);
	FA f58(pp4[7],s11[2],c4[7],s11[3],c4[8]);
	FA f59(pp5[6],s11[3],c5[6],s11[4],c5[7]);
	FA f60(pp6[5],s11[4],c6[5],s11[5],c6[6]);
	FA f61(pp7[4],s11[5],c7[4],s11[6],c7[5]);
	FA f62(pp8[3],s11[6],c8[3],s11[7],c8[4]);
	FA f63(pp9[2],s11[7],c9[2],s11[8],c9[3]);
	FA f64(pp10[1],s11[8],c10[1],s11[9],c10[2]);
	FA f65(pp11[0],s11[9],c11[0],P[11],c11[1]);
	
	//P[12]
	
	FA f66(pp0[12],pp1[11],c1[11],s12[0],c1[12]);
	FA f67(pp2[10],s12[0],c2[10],s12[1],c2[11]);
	FA f68(pp3[9],s12[1],c3[9],s12[2],c3[10]);
	FA f69(pp4[8],s12[2],c4[8],s12[3],c4[9]);
	FA f70(pp5[7],s12[3],c5[7],s12[4],c5[8]);
	FA f71(pp6[6],s12[4],c6[6],s12[5],c6[7]);
	FA f72(pp7[5],s12[5],c7[5],s12[6],c7[6]);
	FA f73(pp8[4],s12[6],c8[4],s12[7],c8[5]);
	FA f74(pp9[3],s12[7],c9[3],s12[8],c9[4]);
	FA f75(pp10[2],s12[8],c10[2],s12[9],c10[3]);
	FA f76(pp11[1],s12[9],c11[1],s12[10],c11[2]);
	FA f77(pp12[0],s12[10],c12[0],P[12],c12[1]);
	
	//P[13]
	
	FA f78(pp0[13],pp1[12],c1[12],s13[0],c1[13]);
	FA f79(pp2[11],s13[0],c2[11],s13[1],c2[12]);
	FA f80(pp3[10],s13[1],c3[10],s13[2],c3[11]);
	FA f81(pp4[9],s13[2],c4[9],s13[3],c4[10]);
	FA f82(pp5[8],s13[3],c5[8],s13[4],c5[9]);
	FA f83(pp6[7],s13[4],c6[7],s13[5],c6[8]);
	FA f84(pp7[6],s13[5],c7[6],s13[6],c7[7]);
	FA f85(pp8[5],s13[6],c8[5],s13[7],c8[6]);
	FA f86(pp9[4],s13[7],c9[4],s13[8],c9[5]);
	FA f87(pp10[3],s13[8],c10[3],s13[9],c10[4]);
	FA f88(pp11[2],s13[9],c11[2],s13[10],c11[3]);
	FA f89(pp12[1],s13[10],c12[1],s13[11],c12[2]);
	FA f90(pp13[0],s13[11],c13[0],P[13],c13[1]);
	
	//P[14]
	
	FA f91(pp0[14],pp1[13],c1[13],s14[0],c1[14]);
	FA f92(pp2[12],s14[0],c2[12],s14[1],c2[13]);
	FA f93(pp3[11],s14[1],c3[11],s14[2],c3[12]);
	FA f94(pp4[10],s14[2],c4[10],s14[3],c4[11]);
	FA f95(pp5[9],s14[3],c5[9],s14[4],c5[10]);
	FA f96(pp6[8],s14[4],c6[8],s14[5],c6[9]);
	FA f97(pp7[7],s14[5],c7[7],s14[6],c7[8]);
	FA f98(pp8[6],s14[6],c8[6],s14[7],c8[7]);
	FA f99(pp9[5],s14[7],c9[5],s14[8],c9[6]);
	FA f100(pp10[4],s14[8],c10[4],s14[9],c10[5]);
	FA f101(pp11[3],s14[9],c11[3],s14[10],c11[4]);
	FA f102(pp12[2],s14[10],c12[2],s14[11],c12[3]);
	FA f103(pp13[1],s14[11],c13[1],s14[12],c13[2]);
	FA f104(pp14[0],s14[12],c14[0],P[14],c14[1]);
	
	//P[15]
	
	FA f105(1'b0,pp1[14],c1[14],s15[0],c1[15]);
	FA f106(pp2[13],s15[0],c2[13],s15[1],c2[14]);
	FA f107(pp3[12],s15[1],c3[12],s15[2],c3[13]);
	FA f108(pp4[11],s15[2],c4[11],s15[3],c4[12]);
	FA f109(pp5[10],s15[3],c5[10],s15[4],c5[11]);
	FA f110(pp6[9],s15[4],c6[9],s15[5],c6[10]);
	FA f111(pp7[8],s15[5],c7[8],s15[6],c7[9]);
	FA f112(pp8[7],s15[6],c8[7],s15[7],c8[8]);
	FA f113(pp9[6],s15[7],c9[6],s15[8],c9[7]);
	FA f114(pp10[5],s15[8],c10[5],s15[9],c10[6]);
	FA f115(pp11[4],s15[9],c11[4],s15[10],c11[5]);
	FA f116(pp12[3],s15[10],c12[3],s15[11],c12[4]);
	FA f117(pp13[2],s15[11],c13[2],s15[12],c13[3]);
	FA f118(pp14[1],s15[12],c14[1],P[15],c14[2]);
	
	//P[16]
	
	FA f119(c1[15],pp2[14],c2[14],s16[0],c2[15]);
	FA f120(pp3[13],s16[0],c3[13],s16[1],c3[14]);
	FA f121(pp4[12],s16[1],c4[12],s16[2],c4[13]);
	FA f122(pp5[11],s16[2],c5[11],s16[3],c5[12]);
	FA f123(pp6[10],s16[3],c6[10],s16[4],c6[11]);
	FA f124(pp7[9],s16[4],c7[9],s16[5],c7[10]);
	FA f125(pp8[8],s16[5],c8[8],s16[6],c8[9]);
	FA f126(pp9[7],s16[6],c9[7],s16[7],c9[8]);
	FA f127(pp10[6],s16[7],c10[6],s16[6],c10[7]);
	FA f128(pp11[5],s16[8],c11[5],s16[7],c11[6]);
	FA f129(pp12[4],s16[9],c12[4],s16[8],c12[5]);
	FA f130(pp13[3],s16[10],c13[3],s16[9],c13[4]);
	FA f131(pp14[2],s16[11],c14[2],P[16],c14[3]);
	
	//P[17]
	
	FA f132(c2[15],pp3[14],c3[14],s17[0],c3[15]);
	FA f133(pp4[13],s17[0],c4[13],s17[1],c4[14]);
	FA f134(pp5[12],s17[1],c5[12],s17[2],c5[13]);
	FA f135(pp6[11],s17[2],c6[11],s17[3],c6[12]);
	FA f136(pp7[10],s17[3],c7[10],s17[4],c7[11]);
	FA f137(pp8[9],s17[4],c8[9],s17[5],c8[10]);
	FA f138(pp9[8],s17[5],c9[8],s17[6],c7[9]);
	FA f139(pp10[7],s17[6],c10[7],s17[7],c10[8]);
	FA f140(pp11[6],s17[7],c11[6],s17[8],c11[7]);
	FA f141(pp12[5],s17[8],c12[5],s17[9],c12[6]);
	FA f142(pp13[4],s17[9],c13[4],s17[10],c13[5]);
	FA f143(pp14[3],s17[10],c14[3],P[17],c14[4]);
	
	//P[18]
	
	FA f144(c3[15],pp4[14],c4[14],s18[0],c4[15]);
	FA f145(pp5[13],s18[0],c5[13],s18[1],c5[14]);
	FA f146(pp6[12],s18[1],c6[12],s18[2],c6[13]);
	FA f147(pp7[11],s18[2],c7[11],s18[3],c7[12]);
	FA f148(pp8[10],s18[3],c8[10],s18[4],c8[11]);
	FA f149(pp9[9],s18[4],c9[9],s18[5],c9[10]);
	FA f150(pp10[8],s18[5],c10[8],s18[6],c10[9]);
	FA f151(pp11[7],s18[6],c11[7],s18[7],c11[8]);
	FA f152(pp12[6],s18[7],c12[6],s18[8],c12[7]);
	FA f153(pp13[5],s18[7],c13[5],s18[9],c13[6]);
	FA f154(pp14[4],s18[9],c14[4],P[18],c14[5]);
	
	//P[19]
	
	FA f155(c4[15],pp5[14],c5[14],s19[0],c5[15]);
	FA f156(pp6[13],s19[0],c6[13],s19[1],c6[14]);
	FA f157(pp7[12],s19[1],c7[12],s19[2],c7[13]);
	FA f158(pp8[11],s19[2],c8[11],s19[3],c8[12]);
	FA f159(pp9[10],s19[3],c9[10],s19[4],c9[11]);
	FA f160(pp10[9],s19[4],c10[9],s19[5],c10[10]);
	FA f161(pp11[8],s19[5],c11[8],s19[6],c11[9]);
	FA f162(pp12[7],s19[6],c12[7],s19[7],c12[8]);
	FA f163(pp13[6],s19[7],c13[6],s19[8],c13[7]);
	FA f164(pp14[5],s19[8],c14[5],P[19],c14[6]);
	
	//P[20]
	
	FA f165(c5[15],pp6[14],c6[14],s20[0],c6[15]);
	FA f166(pp7[13],s20[0],c7[13],s20[1],c7[14]);
	FA f167(pp8[12],s20[1],c8[12],s20[2],c8[13]);
	FA f168(pp9[11],s20[2],c9[11],s20[3],c9[12]);
	FA f169(pp10[10],s20[3],c10[10],s20[4],c10[11]);
	FA f170(pp11[9],s20[4],c11[9],s20[5],c11[10]);
	FA f171(pp12[8],s20[5],c12[8],s20[6],c12[9]);
	FA f172(pp13[7],s20[6],c13[7],s20[7],c13[8]);
	FA f173(pp14[6],s20[7],c14[6],P[20],c14[7]);
	
	//P[21]
	
	FA f174(c6[15],pp7[14],c7[14],s21[0],c7[15]);
	FA f175(pp8[13],s21[0],c8[13],s21[1],c8[14]);
	FA f176(pp9[12],s21[1],c9[12],s21[2],c9[13]);
	FA f177(pp10[11],s21[2],c10[11],s21[3],c10[12]);
	FA f178(pp11[10],s21[3],c11[10],s21[4],c11[11]);
	FA f179(pp12[9],s21[4],c12[9],s21[5],c12[10]);
	FA f180(pp13[8],s21[5],c13[8],s21[6],c13[9]);
	FA f181(pp14[7],s21[6],c14[7],P[21],c14[8]);
	
	//P[22]
	
	FA f182(c7[15],pp8[14],c8[14],s22[0],c8[15]);
	FA f183(pp9[13],s22[0],c9[13],s22[1],c9[14]);
	FA f184(pp10[12],s22[1],c10[12],s22[2],c10[13]);
	FA f185(pp11[11],s22[2],c11[11],s22[3],c11[12]);
	FA f186(pp12[10],s22[3],c12[10],s22[4],c12[11]);
	FA f187(pp13[9],s22[4],c13[9],s22[5],c13[10]);
	FA f188(pp14[8],s22[5],c14[8],P[22],c14[9]);
	
	//P[23]
	
	FA f189(c8[15],pp9[14],c9[14],s23[0],c9[15]);
	FA f190(pp10[13],s23[0],c10[13],s23[1],c10[14]);
	FA f191(pp11[12],s23[1],c11[12],s23[2],c11[13]);
	FA f192(pp12[11],s23[2],c12[11],s23[3],c12[12]);
	FA f193(pp13[10],s23[3],c13[10],s23[4],c13[11]);
	FA f194(pp14[9],s23[4],c14[9],P[23],c14[10]);
	
	//P[24]
	
	FA f195(c9[15],pp10[14],c10[14],s24[0],c10[15]);
	FA f196(pp11[13],s24[0],c11[13],s24[1],c11[14]);
	FA f197(pp12[12],s24[1],c12[12],s24[2],c12[13]);
	FA f198(pp13[11],s24[2],c13[11],s24[3],c13[12]);
	FA f199(pp14[10],s24[3],c14[10],P[24],c14[11]);
	
	
	//P[25]
	
	FA f200(c10[15],pp11[14],c11[14],s25[0],c11[15]);
	FA f201(pp12[13],s25[0],c12[13],s25[1],c12[14]);
	FA f202(pp13[12],s25[1],c13[12],s25[2],c13[13]);
	FA f203(pp14[11],s25[2],c14[11],P[25],c14[12]);
	
	//P[26]
	
	FA f204(c11[15],pp12[14],c12[14],s26[0],c12[15]);
	FA f205(pp13[13],s26[0],c13[13],s26[1],c13[14]);
	FA f206(pp14[12],s26[1],c14[12],P[26],c14[13]);
	
	//P[27]
	
	FA f207(c12[15],pp13[14],c13[14],s27,c13[15]);
	FA f208(pp14[13],s27,c14[13],P[27],c14[14]);
	
	//P[28], P[29]
	
	FA f209(c13[15],pp14[14],c14[14],P[28],P[29]);
	
	assign resultA = P[14:0];
	
endmodule

module calPP(a,b,pp);

	input [14:0]a;
	input b;
	output[14:0] pp;
	
	and(pp[0],a[0],b);
	and(pp[1],a[1],b);
	and(pp[2],a[2],b);
	and(pp[3],a[3],b);
	and(pp[4],a[4],b);
	and(pp[5],a[5],b);
	and(pp[6],a[6],b);
	and(pp[7],a[7],b);
	and(pp[8],a[8],b);
	and(pp[9],a[9],b);
	and(pp[10],a[10],b);
	and(pp[11],a[11],b);
	and(pp[12],a[12],b);
	and(pp[13],a[13],b);
	and(pp[14],a[14],b);
	
endmodule

module div(A,result,resultA);
	
	input [14:0]A;
	input [14:0]result;
	output [14:0]resultA;
	
	wire [14:0] R;
	wire [14:0] Q;
	wire [14:0] D;
	wire [14:0] primeR1,primeR2,primeR3,primeR4,primeR5,primeR6,primeR7,primeR8,primeR9,primeR10;
	wire [14:0] primeR11,primeR12,primeR13,primeR14,primeR15;
	wire [14:0] atemp1,atemp2,atemp3,atemp4,atemp5,atemp6,atemp7,atemp8,atemp9,atemp10,atemp11,atemp12,atemp13,atemp14,atemp15;
	wire [14:0] stemp1,stemp2,stemp3,stemp4,stemp5,stemp6,stemp7,stemp8,stemp9,stemp10,stemp11,stemp12,stemp13,stemp14,stemp15;
	
	assign Q = result;
	assign D = A;
	assign R = (Q[14] == 1) ? 15'b111111111111111 : 15'b000000000000000;
	
	wire [29:0] RQ = {R,Q};
	
	wire [29:0] RQ1,RQ2,RQ3,RQ4,RQ5,RQ6,RQ7,RQ8,RQ9,RQ10,RQ11,RQ12,RQ13,RQ14,RQ15;
	wire [29:0] LRQ1,LRQ2,LRQ3,LRQ4,LRQ5,LRQ6,LRQ7,LRQ8,LRQ9,LRQ10,LRQ11,LRQ12,LRQ13,LRQ14,LRQ15;
	
	assign RQ1 = RQ << 1;
	
	add a1(D,RQ1[29:15],atemp1);
	sub s1(D,RQ1[29:15],stemp1);
	
	assign primeR1 = (RQ1[29] ^ D[14]) ? atemp1 : stemp1;
	assign LRQ1 = (primeR1[14] ^ RQ1[29]) ? {RQ1[29:1],1'b0} : {primeR1,RQ1[14:1],1'b1};
	

	assign RQ2 = LRQ1 << 1;
	
	add a2(D,RQ2[29:15],atemp2);
	sub s2(D,RQ2[29:15],stemp2);
	
	assign primeR2 = (RQ2[29] ^ D[14]) ? atemp2 : stemp2;
	assign LRQ2 = (primeR2[14] ^ RQ2[29]) ? {RQ2[29:1],1'b0} : {primeR2,RQ2[14:1],1'b1};
	
	assign RQ3 = LRQ2 << 1;
	
	add a3(D,RQ3[29:15],atemp3);
	sub s3(D,RQ3[29:15],stemp3);
	
	assign primeR3 = (RQ3[29] ^ D[14]) ? atemp3 : stemp3;
	assign LRQ3 = (primeR3[14] ^ RQ3[29]) ? {RQ3[29:1],1'b0} : {primeR3,RQ3[14:1],1'b1};
	
	
	assign RQ4 = LRQ3 << 1;
	
	add a4(D,RQ4[29:15],atemp4);
	sub s4(D,RQ4[29:15],stemp4);
	
	assign primeR4 = (RQ4[29] ^ D[14]) ? atemp4 : stemp4;
	assign LRQ4 = (primeR4[14] ^ RQ4[29]) ? {RQ4[29:1],1'b0} : {primeR4,RQ4[14:1],1'b1};
	
	assign RQ5 = LRQ4 << 1;
	
	add a5(D,RQ5[29:15],atemp5);
	sub s5(D,RQ5[29:15],stemp5);
	
	assign primeR5 = (RQ5[29] ^ D[14]) ? atemp5 : stemp5;
	assign LRQ5 = (primeR5[14] ^ RQ5[29]) ? {RQ5[29:1],1'b0} : {primeR5,RQ5[14:1],1'b1};
	
	assign RQ6 = LRQ5 << 1;
	
	add a6(D,RQ6[29:15],atemp6);
	sub s6(D,RQ6[29:15],stemp6);
	
	assign primeR6 = (RQ6[29] ^ D[14]) ? atemp6 : stemp6;
	assign LRQ6 = (primeR6[14] ^ RQ6[29]) ? {RQ6[29:1],1'b0} : {primeR6,RQ6[14:1],1'b1};
	
	assign RQ7 = LRQ6 << 1;
	
	add a7(D,RQ7[29:15],atemp7);
	sub s7(D,RQ7[29:15],stemp7);
	
	assign primeR7 = (RQ7[29] ^ D[14]) ? atemp7 : stemp7;
	assign LRQ7 = (primeR7[14] ^ RQ7[29]) ? {RQ7[29:1],1'b0} : {primeR7,RQ7[14:1],1'b1};
	
	assign RQ8 = LRQ7 << 1;
	
	add a8(D,RQ8[29:15],atemp8);
	sub s8(D,RQ8[29:15],stemp8);
	
	assign primeR8 = (RQ8[29] ^ D[14]) ? atemp8 : stemp8;
	assign LRQ8 = (primeR8[14] ^ RQ8[29]) ? {RQ8[29:1],1'b0} : {primeR8,RQ8[14:1],1'b1};
	
	assign RQ9 = LRQ8 << 1;
	
	add a9(D,RQ9[29:15],atemp9);
	sub s9(D,RQ9[29:15],stemp9);
	
	assign primeR9 = (RQ9[29] ^ D[14]) ? atemp9 : stemp9;
	assign LRQ9 = (primeR9[14] ^ RQ9[29]) ? {RQ9[29:1],1'b0} : {primeR9,RQ9[14:1],1'b1};
	
	assign RQ10 = LRQ9 << 1;
	
	add a10(D,RQ10[29:15],atemp10);
	sub s10(D,RQ10[29:15],stemp10);
	
	assign primeR10 = (RQ10[29] ^ D[14]) ? atemp10 : stemp10;
	assign LRQ10 = (primeR10[14] ^ RQ10[29]) ? {RQ10[29:1],1'b0} : {primeR10,RQ10[14:1],1'b1};
	
	assign RQ11 = LRQ10 << 1;
	
	add a11(D,RQ11[29:15],atemp11);
	sub s11(D,RQ11[29:15],stemp11);
	
	assign primeR11 = (RQ11[29] ^ D[14]) ? atemp11 : stemp11;
	assign LRQ11 = (primeR11[14] ^ RQ11[29]) ? {RQ11[29:1],1'b0} : {primeR11,RQ11[14:1],1'b1};
	
	assign RQ12 = LRQ11 << 1;
	
	add a12(D,RQ12[29:15],atemp12);
	sub s12(D,RQ12[29:15],stemp12);
	
	assign primeR12 = (RQ12[29] ^ D[14]) ? atemp12 : stemp12;
	assign LRQ12 = (primeR12[14] ^ RQ12[29]) ? {RQ12[29:1],1'b0} : {primeR12,RQ12[14:1],1'b1};
	
	assign RQ13 = LRQ12 << 1;
	
	add a13(D,RQ13[29:15],atemp13);
	sub s13(D,RQ13[29:15],stemp13);

	assign primeR13 = (RQ13[29] ^ D[14]) ? atemp13 : stemp13;
	assign LRQ13 = (primeR13[14] ^ RQ13[29]) ? {RQ13[29:1],1'b0} : {primeR13,RQ13[14:1],1'b1};
	
	assign RQ14 = LRQ13 << 1;
	
	add a14(D,RQ14[29:15],atemp14);
	sub s14(D,RQ14[29:15],stemp14);
	
	assign primeR14 = (RQ14[29] ^ D[14]) ? atemp14 : stemp14;
	assign LRQ14 = (primeR14[14] ^ RQ14[29]) ? {RQ14[29:1],1'b0} : {primeR14,RQ14[14:1],1'b1};
	
	assign RQ15 = LRQ14 << 1;
	
	add a15(D,RQ15[29:15],atemp15);
	sub s15(D,RQ15[29:15],stemp15);
	
	assign primeR15 = (RQ15[29] ^ D[14]) ? atemp15 : stemp15;
	assign LRQ15 = (primeR15[14] ^ RQ15[29]) ? {RQ15[29:1],1'b0} : {primeR15,RQ15[14:1],1'b1};
	
	assign resultA = LRQ15[14:0];
	
endmodule

module rem (A,result,resultA);
	
	input [14:0]A;
	input [14:0]result;
	output [14:0]resultA;
	
	wire [14:0] R;
	wire [14:0] Q;
	wire [14:0] D;
	wire [14:0] primeR1,primeR2,primeR3,primeR4,primeR5,primeR6,primeR7,primeR8,primeR9,primeR10;
	wire [14:0] primeR11,primeR12,primeR13,primeR14,primeR15;
	wire [14:0] atemp1,atemp2,atemp3,atemp4,atemp5,atemp6,atemp7,atemp8,atemp9,atemp10,atemp11,atemp12,atemp13,atemp14,atemp15;
	wire [14:0] stemp1,stemp2,stemp3,stemp4,stemp5,stemp6,stemp7,stemp8,stemp9,stemp10,stemp11,stemp12,stemp13,stemp14,stemp15;
	
	assign Q = result;
	assign D = A;
	assign R = (Q[14] == 1) ? 15'b111111111111111 : 15'b000000000000000;
	
	wire [29:0] RQ = {R,Q};
	
	wire [29:0] RQ1,RQ2,RQ3,RQ4,RQ5,RQ6,RQ7,RQ8,RQ9,RQ10,RQ11,RQ12,RQ13,RQ14,RQ15;
	wire [29:0] LRQ1,LRQ2,LRQ3,LRQ4,LRQ5,LRQ6,LRQ7,LRQ8,LRQ9,LRQ10,LRQ11,LRQ12,LRQ13,LRQ14,LRQ15;
	
	assign RQ1 = RQ << 1;
	
	add a1(D,RQ1[29:15],atemp1);
	sub s1(D,RQ1[29:15],stemp1);
	
	assign primeR1 = (RQ1[29] ^ D[14]) ? atemp1 : stemp1;
	assign LRQ1 = (primeR1[14] ^ RQ1[29]) ? {RQ1[29:1],1'b0} : {primeR1,RQ1[14:1],1'b1};
	

	assign RQ2 = LRQ1 << 1;
	
	add a2(D,RQ2[29:15],atemp2);
	sub s2(D,RQ2[29:15],stemp2);
	
	assign primeR2 = (RQ2[29] ^ D[14]) ? atemp2 : stemp2;
	assign LRQ2 = (primeR2[14] ^ RQ2[29]) ? {RQ2[29:1],1'b0} : {primeR2,RQ2[14:1],1'b1};
	
	assign RQ3 = LRQ2 << 1;
	
	add a3(D,RQ3[29:15],atemp3);
	sub s3(D,RQ3[29:15],stemp3);
	
	assign primeR3 = (RQ3[29] ^ D[14]) ? atemp3 : stemp3;
	assign LRQ3 = (primeR3[14] ^ RQ3[29]) ? {RQ3[29:1],1'b0} : {primeR3,RQ3[14:1],1'b1};
	
	
	assign RQ4 = LRQ3 << 1;
	
	add a4(D,RQ4[29:15],atemp4);
	sub s4(D,RQ4[29:15],stemp4);
	
	assign primeR4 = (RQ4[29] ^ D[14]) ? atemp4 : stemp4;
	assign LRQ4 = (primeR4[14] ^ RQ4[29]) ? {RQ4[29:1],1'b0} : {primeR4,RQ4[14:1],1'b1};
	
	assign RQ5 = LRQ4 << 1;
	
	add a5(D,RQ5[29:15],atemp5);
	sub s5(D,RQ5[29:15],stemp5);
	
	assign primeR5 = (RQ5[29] ^ D[14]) ? atemp5 : stemp5;
	assign LRQ5 = (primeR5[14] ^ RQ5[29]) ? {RQ5[29:1],1'b0} : {primeR5,RQ5[14:1],1'b1};
	
	assign RQ6 = LRQ5 << 1;
	
	add a6(D,RQ6[29:15],atemp6);
	sub s6(D,RQ6[29:15],stemp6);
	
	assign primeR6 = (RQ6[29] ^ D[14]) ? atemp6 : stemp6;
	assign LRQ6 = (primeR6[14] ^ RQ6[29]) ? {RQ6[29:1],1'b0} : {primeR6,RQ6[14:1],1'b1};
	
	assign RQ7 = LRQ6 << 1;
	
	add a7(D,RQ7[29:15],atemp7);
	sub s7(D,RQ7[29:15],stemp7);
	
	assign primeR7 = (RQ7[29] ^ D[14]) ? atemp7 : stemp7;
	assign LRQ7 = (primeR7[14] ^ RQ7[29]) ? {RQ7[29:1],1'b0} : {primeR7,RQ7[14:1],1'b1};
	
	assign RQ8 = LRQ7 << 1;
	
	add a8(D,RQ8[29:15],atemp8);
	sub s8(D,RQ8[29:15],stemp8);
	
	assign primeR8 = (RQ8[29] ^ D[14]) ? atemp8 : stemp8;
	assign LRQ8 = (primeR8[14] ^ RQ8[29]) ? {RQ8[29:1],1'b0} : {primeR8,RQ8[14:1],1'b1};
	
	assign RQ9 = LRQ8 << 1;
	
	add a9(D,RQ9[29:15],atemp9);
	sub s9(D,RQ9[29:15],stemp9);
	
	assign primeR9 = (RQ9[29] ^ D[14]) ? atemp9 : stemp9;
	assign LRQ9 = (primeR9[14] ^ RQ9[29]) ? {RQ9[29:1],1'b0} : {primeR9,RQ9[14:1],1'b1};
	
	assign RQ10 = LRQ9 << 1;
	
	add a10(D,RQ10[29:15],atemp10);
	sub s10(D,RQ10[29:15],stemp10);
	
	assign primeR10 = (RQ10[29] ^ D[14]) ? atemp10 : stemp10;
	assign LRQ10 = (primeR10[14] ^ RQ10[29]) ? {RQ10[29:1],1'b0} : {primeR10,RQ10[14:1],1'b1};
	
	assign RQ11 = LRQ10 << 1;
	
	add a11(D,RQ11[29:15],atemp11);
	sub s11(D,RQ11[29:15],stemp11);
	
	assign primeR11 = (RQ11[29] ^ D[14]) ? atemp11 : stemp11;
	assign LRQ11 = (primeR11[14] ^ RQ11[29]) ? {RQ11[29:1],1'b0} : {primeR11,RQ11[14:1],1'b1};
	
	assign RQ12 = LRQ11 << 1;
	
	add a12(D,RQ12[29:15],atemp12);
	sub s12(D,RQ12[29:15],stemp12);
	
	assign primeR12 = (RQ12[29] ^ D[14]) ? atemp12 : stemp12;
	assign LRQ12 = (primeR12[14] ^ RQ12[29]) ? {RQ12[29:1],1'b0} : {primeR12,RQ12[14:1],1'b1};
	
	assign RQ13 = LRQ12 << 1;
	
	add a13(D,RQ13[29:15],atemp13);
	sub s13(D,RQ13[29:15],stemp13);

	assign primeR13 = (RQ13[29] ^ D[14]) ? atemp13 : stemp13;
	assign LRQ13 = (primeR13[14] ^ RQ13[29]) ? {RQ13[29:1],1'b0} : {primeR13,RQ13[14:1],1'b1};
	
	assign RQ14 = LRQ13 << 1;
	
	add a14(D,RQ14[29:15],atemp14);
	sub s14(D,RQ14[29:15],stemp14);
	
	assign primeR14 = (RQ14[29] ^ D[14]) ? atemp14 : stemp14;
	assign LRQ14 = (primeR14[14] ^ RQ14[29]) ? {RQ14[29:1],1'b0} : {primeR14,RQ14[14:1],1'b1};
	
	assign RQ15 = LRQ14 << 1;
	
	add a15(D,RQ15[29:15],atemp15);
	sub s15(D,RQ15[29:15],stemp15);
	
	assign primeR15 = (RQ15[29] ^ D[14]) ? atemp15 : stemp15;
	assign LRQ15 = (primeR15[14] ^ RQ15[29]) ? {RQ15[29:1],1'b0} : {primeR15,RQ15[14:1],1'b1};
		
	assign resultA = LRQ15[29:15];
	
endmodule


module facf (A,result);

	input [14:0]A;
	output [14:0]result;
	
	wire a,b,c,cntl;
	wire [14:0] zero;
	wire [14:0] res;
	assign zero = 15'b00000000000000;
	assign a = A[2];
	assign b = A[1];
	assign c = A[0];
	assign cntl =  A[3] | A[4] | A[5] | A[6] | A[7] | A[8] | A[9] | A[10] | A[11] | A[12] | A[13];
	
	assign res[14] = 0;
	assign res[13] = 0;
	assign res[12] = a & b & c;
	assign res[11] = 0;
	assign res[10] = 0;
	assign res[9] = a & b;
	assign res[8] = a & b & c;
	assign res[7] = a & b;
	assign res[6] = a & (b ^ c);
	assign res[5] = a & c;
	assign res[4] = a;
	assign res[3] = a & ~b;
	assign res[2] = ~a & b & c;
	assign res[1] = ~a & b;
	assign res[0] = ~a & ~b & c;
	
	assign result = (cntl) ? zero : res;
	
endmodule

module squaref (A,result);

	input [14:0]A;
	output [14:0]result;
	
	wire [29:0] temp;
	
	mul mm(A,A,temp);
	
	assign result = temp[14:0];
	
endmodule

module sinf (A,result);

	input [14:0]A;
	output [14:0]result;
	
	wire [14:0] a2;
	wire [29:0] a3,a5,a7;
	wire [14:0] f3,f5,f7;
	wire [14:0] t3,t5,t7;
	wire [14:0] r1,r2,r3;
	wire [29:0] s1,s2,s3,s4;
	
	facf ff0(15'b000000000000011,f3);
	facf ff1(15'b000000000000101,f5);
	facf ff2(15'b000000000000111,f7);
	
	squaref sq (A,a2);
	mul m12(A,a2,a3);
	mul m23(a2,a3[14:0],a5);
	mul m25(a2,a5[14:0],a7);
	
	mul m0(15'b000000001100100,A,s1);
	mul m1(15'b000000001100100,a3,s2);
	mul m2(15'b000000001100100,a5,s3);
	mul m3(15'b000000001100100,a7,s4);
	
	div d0(f3,s2[14:0],t3);
	div d1(f5,s3[14:0],t5);
	div d2(f7,s4[14:0],t7);
	
	sub sb0(t3,s1[14:0],r1);
	add a(t5,r1,r2);
	sub sb1(t7,r2,r3);
	
	assign result = r3;
	
endmodule

module cosf (A,result);

	input [14:0]A;
	output [14:0]result;
	
	wire [14:0] a1,a2;
	wire [29:0] a4,a6;
	wire [14:0] f2,f4,f6;
	wire [14:0] t2,t4,t6;
	wire [14:0] r1,r2,r3;
	wire [29:0] s2,s3,s4;
	
	facf ff0(15'b000000000000010,f2);
	facf ff1(15'b000000000000100,f4);
	facf ff2(15'b000000000000110,f6);
	
	squaref sq1(A,a2);
	mul m22(a2[14:0],a2[14:0],a4);
	mul m24(a2,a4[14:0],a6);
	
	mul m1(15'b000000001100100,a2,s2);
	mul m2(15'b000000001100100,a4[14:0],s3);
	mul m3(15'b000000001100100,a6[14:0],s4);
	
	div d0(f2,s2[14:0],t2);
	div d1(f4,s3[14:0],t4);
	div d2(f6,s4[14:0],t6);
	
	sub sb0(t2,15'b000000001100100,r1);
	add a(t4,r1,r2);
	sub sb1(t6,r2,r3);
	
	assign result = r3;
	
endmodule

module expf (A,result);

	input [14:0]A;
	output [14:0]result;
	
	wire [14:0] a2;
	wire [29:0] a3,a4,a5,a6,a7;
	wire [14:0] f2,f3,f4,f5,f6,f7;
	wire [14:0] t2,t3,t4,t5,t6,t7;
	wire [14:0] r1,r2,r3,r4,r5,r6,r7;
	wire [29:0] s1,s2,s3,s4,s5,s6,s7;
	
	squaref sq0(A,a2);
	mul m0(a2,A,a3);
	mul m1(a2,a2,a4);
	mul m2(a2,a3[14:0],a5);
	mul m3(a3[14:0],a3[14:0],a6);
	mul m4(a3[14:0],a4[14:0],a7);
	
	facf ff0(15'b000000000000010,f2);
	facf ff1(15'b000000000000011,f3);
	facf ff2(15'b000000000000100,f4);
	facf ff3(15'b000000000000101,f5);
	facf ff4(15'b000000000000110,f6);
	facf ff5(15'b000000000000111,f7);
	
	mul m5(15'b000000001100100,A,s1);
	mul m6(15'b000000001100100,a2,s2);
	mul m7(15'b000000001100100,a3[14:0],s3);
	mul m8(15'b000000001100100,a4[14:0],s4);
	mul m9(15'b000000001100100,a5[14:0],s5);
	mul m10(15'b000000001100100,a6[14:0],s6);
	mul m11(15'b000000001100100,a7[14:0],s7);
	
	div d0(f2,s2[14:0],t2);
	div d1(f3,s3[14:0],t3);
	div d2(f4,s4[14:0],t4);
	div d3(f5,s5[14:0],t5);
	div d4(f6,s6[14:0],t6);
	div d5(f7,s7[14:0],t7);
		
	add ad0(15'b000000001100100,s1,r1);
	add ad1(t2,r1,r2);
	add ad2(t3,r2,r3);
	add ad3(t4,r3,r4);
	add ad4(t5,r4,r5);
	add ad5(t6,r5,r6);
	add ad6(t7,r6,r7);
	
	assign result = r7;
	
endmodule

module tanf (A,result);

	input [14:0]A;
	output [14:0]result;
	
	wire [14:0] cos,sin,res;
	wire [29:0] s1;
	wire [14:0] temp;
	cosf c(A,cos);
	sinf s(A,sin);
	
	mul m0(15'b000000001100100,sin,s1);
	
	div d(cos,s1[14:0],res);
	
	add ad(15'b00000000000001,~res,temp);

	assign result = (cos[14] ^ sin[14]) ? temp : res;
	
endmodule


module FA(a,b,cin,s,cout); //full-adder module

	input a,b,cin;
	output s,cout;
	
	assign cout = (b & cin) | (a & cin) | (a & b); //assign cout
	assign s = a ^ b ^ cin; //assign s
	
endmodule


