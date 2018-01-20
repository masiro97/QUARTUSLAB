module L8part2(sw,clk,key0,key1,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7);

	input [16:0]sw;
	input key0,key1,clk;
	
	output [0:6] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;
	
	wire [7:0] wireS, C;
	reg mark;
  reg [7:0] A, B, S;
  reg [6:0] hexA,hexB;
  reg overflow;
  
  fulladder_8bit f (A, B, sw[16], wireS, C);
  
  always @ (posedge clk) begin
    if (key1 == 0) begin
	 
      A = sw[15:8];
      B = sw[7:0];
		hexA = sw[14:8];
		hexB = sw[6:0];
      S = wireS;
		
      overflow = C[7] ^ C[6];
		if(sw[15] == 1) A[6:0] = ~ A[6:0] + 1;
		if(sw[7] == 1) B[6:0] = ~B[6:0] + 1;
		if(sw[16] == 1) B = ~B;
		if(S[7] == 1) begin
		
		S = ~S + 1;
		mark = 1;
		end
		else mark = 0;
    end
	 
    if (key0 == 0) begin
      A = 8'b00000000;
      B = 8'b00000000;
		hexA = 7'b0000000;
		hexB = 7'b0000000;
      S = 8'b00000000;
      overflow = 0;
		mark = 0;
    end
  end

  
	wire [3:0]onesA,tensA,onesB,tensB,onesS,tensS,hundsS;
	
	assign onesA = hexA % 16;
   assign tensA = (hexA - onesA) / 16;
   assign onesB = hexB % 16;
   assign tensB = (hexB - onesB) / 16;
   assign onesS = S % 16;
   assign tensS = (S - onesS) / 16;
   assign hundsS = (S - (tensS * 16) - onesS) / 256;
    
	assign HEX3 = (mark == 1) ? 7'b1111110 : 7'b1111111;
	
   display_7seg d7(tensA,HEX7);
   display_7seg d6(onesA,HEX6);
   display_7seg d5(tensB,HEX5);
   display_7seg d4(onesB,HEX4);
   display_7seg d2(hundsS,HEX2);
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

module fulladder_8bit (A, B, ci, S, CO);
  input [7:0] A, B;
  input ci;
  output [7:0] S;
  output [8:1] CO;

  FA A0 (A[0], B[0], ci, S[0], CO[1]);
  FA A1 (A[1], B[1], CO[1], S[1], CO[2]);
  FA A2 (A[2], B[2], CO[2], S[2], CO[3]);
  FA A3 (A[3], B[3], CO[3], S[3], CO[4]);
  FA A4 (A[4], B[4], CO[4], S[4], CO[5]);
  FA A5 (A[5], B[5], CO[5], S[5], CO[6]);
  FA A6 (A[6], B[6], CO[6], S[6], CO[7]);
  FA A7 (A[7], B[7], CO[7], S[7], CO[8]);
endmodule

module FA(a,b,cin,s,cout); //full-adder module

   input a,b,cin;
   output s,cout;
   
   assign cout = (b & cin) | (a & cin) | (a & b); //assign cout
   assign s = a ^ b ^ cin; //assign s
   
endmodule
