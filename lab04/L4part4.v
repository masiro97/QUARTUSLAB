module L4part4(A,B,cin,HEX6,HEX4,HEX1,HEX0,LEDG, LEDR);
	input [3:0]A,B; //4-bit input
	input cin; //carry-in
	output [0:6] HEX6, HEX4, HEX1, HEX0; //7-segment
	output [8:0] LEDR, LEDG;
	wire [4:0]s; //5-bit output
	wire c1, c2, c3, co; //carry-out
	wire z0,z1; //inspect input is bigger than 9
	
	comparator_3bit C0 (A, z0); // A > 9 : z0 = 1
   comparator_3bit C1 (B, z1); // B > 9 : z1 = 1
	
	assign LEDR[7:4] = A;
	assign LEDR[3:0] = B;
	assign LEDR[8] = cin;
	assign LEDG[7:5] = 0;
	assign LEDG[8] = z0 | z1;
	
	// A(4-bit) + B(4-bit) = S(5-bit)
	FA F1(A[0],B[0],cin,s[0],c1);
	FA F2(A[1],B[1],c1,s[1],c2);
	FA F3(A[2],B[2],c2,s[2],c3);
	FA F4(A[3],B[3],c3,s[3],s[4]);
	
	assign LEDG[4:0] = s[4:0];
	
   wire z;
   wire [3:0] T, M;

   comparator_4bit C2 (s[4:0], z); //if s > 9 : z = 1
   circuitA a (s[3:0], T); // if z = 1 : assign T
	mux m (z,s[3:0],T,M); // if z = 0: M = s[3:0], if z = 1: M = T
	circuitB b(z,HEX1);
	display_7seg h0(M,HEX0);
	display_7seg h1(A,HEX6);
	display_7seg h2(B,HEX4);
	
endmodule

module circuitB (z, HEX);

  input z;
  output [0:6] HEX;

  assign HEX = (z == 1'b0) ? 7'b0000001:7'b1001111;
  
endmodule


module circuitA (V, A);
  input [3:0] V;
  output [3:0] A;

  assign A[0] = V[0];
  assign A[1] = ~V[1];
  assign A[2] = (~V[3] & ~V[1]) | (V[2] & V[1]);
  assign A[3] = (~V[3] & V[1]);
  
endmodule

module mux(z,U,V,M);

 //if z = 0 U z = 1 V
 input z;
 input [3:0]U,V;
 output [3:0]M;
 
// assign M = (z == 1'b0) ? U: V;
 assign M[0] = (z & V[0]) | (~z & U[0]);
 assign M[1] = (z & V[1]) | (~z & U[1]);
 assign M[2] = (z & V[2]) | (~z & U[2]);
 assign M[3] = (z & V[3]) | (~z & U[3]);

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


module FA(a,b,cin,s,cout);

	input a,b,cin;
	output s,cout;
	
	assign cout = (b & cin) | (a & cin) | (a & b);
	assign s = a ^ b ^ cin;

endmodule

module comparator_3bit (V, z);
  input [3:0] V;
  output z;

  assign z = (V[3] & (V[2] | V[1]));
  
endmodule

module comparator_4bit (V, z);

  input [4:0] V;
  output z;

  assign z = V[4] |(V[3] & (V[2] | V[1]));
  
endmodule



