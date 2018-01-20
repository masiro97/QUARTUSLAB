module L7part2(key0,key1,clk,sw,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7);

	input key0,key1,clk; //key0 : reset key1 : sw
	input [16:0]sw;
	output [0:6] HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;
	reg [4:0] hour;
	reg [5:0] minute, second;
	reg [25:0] cnt;
	reg [3:0] h1,h0,m1,m0,s1,s0;
	//HEX7-6 : hour HEX5-4: minute HEX 3-2: second
	
	initial begin
	hour = 15;
	minute = 0;
	second = 0;

	end
	
	always @(posedge clk) begin
	
		cnt <= cnt + 1;
		
		if(key0 == 0) begin
			hour <= 15;
			minute <= 0;
			second <= 0;
		
		end
		
		if(key1 ==0) begin
		hour <= sw[12] + 2*sw[13] + 4*sw[14] + 8*sw[15] + 16*sw[16];
		minute <= sw[6] + 2*sw[7] + 4*sw[8] + 8*sw[9] + 16*sw[10] + 32*sw[11];
		second <= sw[0] + 2*sw[1] + 4 *sw[2] + 8*sw[3] + 16*sw[4] + 32 *sw[5];
		
		end
		
		if(cnt == 50000000) begin
			second <= second + 1;
			if(second == 59) begin
				minute <= minute + 1;
				second <= 0;
				if(minute ==59) begin
					hour <= hour + 1;
					minute <=0;
					if(hour ==23)
						hour <= 0;
				end
			end
		end
		
		h0 = hour % 10;
		h1 = (hour - h0) / 10;
		
		m0 = minute % 10;
		m1 = (minute - m0) / 10;
		
		s0 = second % 10;
		s1 = (second - s0) / 10;
	end
	
	display_7seg d7(h1,HEX7);
	display_7seg d6(h0,HEX6);
	display_7seg d5(m1,HEX5);
	display_7seg d4(m0,HEX4);
	display_7seg d3(s1,HEX3);
	display_7seg d2(s0,HEX2);
	
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

