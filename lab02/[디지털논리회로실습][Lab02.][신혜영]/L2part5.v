
module L2part5(s,u,v,w,x,y,led,HEX0, HEX1, HEX2, HEX3, HEX4);

	input [2:0]s,u,v,w,x,y;
  
   output [0:6]HEX0, HEX1, HEX2, HEX3, HEX4;
   output [17:0]led;
   
   assign led[17:15] = s; // s is order control input
	assign led[14:12] = u; // u is always 000 showing 'H'
	assign led[11:9] = v; // v is always 001 showing 'E'
	assign led[8:6] = w; // w is always 010 showing 'L'
	assign led[5:3] = x; // x is always 010 showing 'L'
	assign led[2:0] = y; // y is always 100 showing 'O'
   
	wire [2:0]m0,m1,m2,m3,m4; // m? is temporay variable showing  alphabet on HEX?
	 
   assign m4 = (s ==3'b000) ? u: //s=000: m4 = 000
               (s ==3'b001) ? v: //s=001: m4 = 001
               (s ==3'b010) ? w: //s=010: m4 = 010
               (s ==3'b011) ? x: //s=011: m4 = 010
				                 	y; //s=100 ~ 111: m4 = 100
               
   assign m3 = (s ==3'b000) ? v: //s=000: m3 = 001
               (s ==3'b001) ? w: //s=001: m3 = 010
               (s ==3'b010) ? x: //s=010: m3 = 010
               (s ==3'b011) ? y: //s=011: m3 = 100
					               u; //s=100 ~ 111: m3 = 000
               
   assign m2 = (s ==3'b000) ? w: //s=000: m2 = 010
               (s ==3'b001) ? x: //s=001: m2 = 010
               (s ==3'b010) ? y: //s=010: m2 = 100
               (s ==3'b011) ? u: //s=011: m2 = 000
					               v; //s=100 ~ 111: m2 = 001
               
   assign m1 = (s ==3'b000) ? x: //s=000: m1 = 010
               (s ==3'b001) ? y: //s=001: m1 = 100
               (s ==3'b010) ? u: //s=010: m1 = 000
               (s ==3'b011) ? v: //s=011: m1 = 001
				               	w; //s=100 ~ 111: m1 = 010
										
   assign m0 = (s ==3'b000) ? y: //s=000: m0 = 100
               (s ==3'b001) ? u: //s=001: m0 = 000
               (s ==3'b010) ? v: //s=010: m0 = 001
               (s ==3'b011) ? w: //s=011: m0 = 010
				               	x; //s=100 ~ 111: m0 = 010
               
   
   assign HEX4 = (m4 ==3'b000) ? 7'b1001000: //if m4 = 000: HEX4 shows 'H'
                 (m4 ==3'b001) ? 7'b0110000: //if m4 = 001: HEX4 shows 'E'
                 (m4 ==3'b010) ? 7'b1110001: //if m4 = 010: HEX4 shows 'L'
                 (m4 ==3'b011) ? 7'b0000001: //if m4 = 011: HEX4 shows 'O'
					                  7'b1111111; //if m4 = 100 ~ 111: HEX4 shows 'blank'
                 
   assign HEX3 = (m3 ==3'b000) ? 7'b1001000: //if m3 = 000: HEX3 shows 'H'
                 (m3 ==3'b001) ? 7'b0110000: //if m3 = 001: HEX3 shows 'E'
                 (m3 ==3'b010) ? 7'b1110001: //if m3 = 010: HEX3 shows 'L'
                 (m3 ==3'b011) ? 7'b0000001: //if m3 = 011: HEX3 shows 'O'
					                  7'b1111111; //if m3 = 100 ~ 111: HEX3 shows 'blank'
                 
   assign HEX2 = (m2 ==3'b000) ? 7'b1001000: //if m2 = 000: HEX2 shows 'H'
                 (m2 ==3'b001) ? 7'b0110000: //if m2 = 001: HEX2 shows 'E'
                 (m2 ==3'b010) ? 7'b1110001: //if m2 = 010: HEX2 shows 'L'
                 (m2 ==3'b011) ? 7'b0000001: //if m2 = 011: HEX2 shows 'O'
					                  7'b1111111; //if m2 = 100 ~ 111: HEX2 shows 'blank'
                 
   assign HEX1 = (m1 ==3'b000) ? 7'b1001000: //if m1 = 000: HEX1 shows 'H'
                 (m1 ==3'b001) ? 7'b0110000: //if m1 = 001: HEX1 shows 'E'
                 (m1 ==3'b010) ? 7'b1110001: //if m1 = 010: HEX1 shows 'L'
                 (m1 ==3'b011) ? 7'b0000001: //if m1 = 011: HEX1 shows 'O'
					                  7'b1111111; //if m1 = 100 ~ 111: HEX1 shows 'blank'
                 
   assign HEX0 = (m0 ==3'b000) ? 7'b1001000: //if m0 = 000: HEX0 shows 'H'
                 (m0 ==3'b001) ? 7'b0110000: //if m0 = 001: HEX0 shows 'E'
                 (m0 ==3'b010) ? 7'b1110001: //if m0 = 010: HEX0 shows 'L'
                 (m0 ==3'b011) ? 7'b0000001: //if m0 = 011: HEX0 shows 'O'
					                  7'b1111111; //if m0 = 100 ~ 111: HEX0 shows 'blank'
					  
endmodule
