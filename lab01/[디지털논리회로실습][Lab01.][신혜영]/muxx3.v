module muxx3(s,led,u,v,w,x,y,m);

	input [2:0]x;
	input [2:0]y;
	input [2:0]u;
	input [2:0]v;
	input [2:0]w;
	
	input [2:0]s;
   output [17:0]led;
   output [2:0]m;
	assign led[17:15] = s;
	assign led[14:12] = u;
	assign led[11:9] = v;
	assign led[8:6] = w;
	assign led[5:3] = x;
	assign led[2:0] = y;
   
	assign m =  (s ==3'b000) ? u :
					(s ==3'b001) ? v :
					(s ==3'b010) ? w :
					(s ==3'b011) ? x : y;
					
endmodule