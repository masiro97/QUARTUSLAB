module muxx(s,x,led,y,m);

   input [7:0]x;
	input [7:0]y;
	input s;
	output [16:0]led;
	output [7:0]m;
	
	assign led[7:0] = x;
	assign led[15:8] = y;
	assign led[16] = s;
	assign m = (s ==1'b1) ? y:x;
endmodule
