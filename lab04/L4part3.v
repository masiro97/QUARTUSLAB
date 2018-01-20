module L4part3(a,b,ci,LEDG,LEDR);
	
	//connecnt input LEDR output LEDG
	input [3:0]a,b; //4-bit input
	input ci; //carry-in
	output [8:0]LEDR;
	output [4:0]LEDG;
	
	wire c1, c2, c3, co; //cout
	
	wire [3:0]s; //5-bit output but because of s[4] = co, define 4-bit
	assign LEDR[7:4] = a;
	assign LEDR[3:0] = b;
	assign LEDR[8] = ci;
	assign LEDG[3:0] = s;
	assign LEDG[4] = co; //co = s[4]
	
	FA F1(a[0],b[0],ci,s[0],c1);//cin = ci cout = c1
	FA F2(a[1],b[1],c1,s[1],c2);//cin = c1 cout = c2
	FA F3(a[2],b[2],c2,s[2],c3);//cin = c2 cout = c3
	FA F4(a[3],b[3],c3,s[3],co);//cin = c3 cout = c4
	
endmodule

module FA(a,b,cin,s,cout); //full-adder module

	input a,b,cin;
	output s,cout;
	
	assign cout = (b & cin) | (a & cin) | (a & b); //assign cout
	assign s = a ^ b ^ cin; //assign s
	
endmodule
