module BlackJack2(sw,key,clk,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7);

	input [17:0]sw;
	input [3:0]key;
	input clk;
	output [0:6] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7;
	output reg[17:0] LEDR;
	
	reg [3:0] myCard1,myCard2,myCard3,myCard4,myCard5,myCard6;
	reg [3:0] deCard1,deCard2,deCard3,deCard4,deCard5,deCard6;
	reg [3:0] rand1,rand2,rand3,rand4,rand5,rand6,rand7,rand8;
	reg [2:0] result;
	reg [4:0] score; //1 : lose 2: win 3: draw 4: blackjack win
	wire [3:0] rand0;
	wire [3:0] isAto11;
	wire isHaveA;
	wire [4:0] mySum,deSum;
	wire [23:0] myCard,deCard;
	wire [1:0] c1,c2,c3,c4,c5,c6;
	wire [1:0] d1,d2,d3,d4,d5,d6;
	wire [2:0] batting;

	
	assign c1 = (myCard1 == 11) ? 1:
					(myCard1 == 12) ? 2:
					(myCard1 == 13) ? 3: 0;
					
	assign c2 = (myCard2 == 11) ? 1:
					(myCard2 == 12) ? 2:
					(myCard2 == 13) ? 3: 0;
					
	assign c3 = (myCard3 == 11) ? 1:
					(myCard3 == 12) ? 2:
					(myCard3 == 13) ? 3: 0;
					
	assign c4 = (myCard4 == 11) ? 1:
					(myCard4 == 12) ? 2:
					(myCard4 == 13) ? 3: 0;
					
	assign c5 = (myCard5 == 11) ? 1:
					(myCard5 == 12) ? 2:
					(myCard5 == 13) ? 3: 0;
													
	assign c6 = (myCard6 == 11) ? 1:
					(myCard6 == 12) ? 2:
					(myCard6 == 13) ? 3: 0;
					
	assign d1 = (deCard1 == 11) ? 1:
					(deCard1 == 12) ? 2:
					(deCard1 == 13) ? 3: 0;
					
	assign d2 = (deCard2 == 11) ? 1:
					(deCard2 == 12) ? 2:
					(deCard2 == 13) ? 3: 0;
					
	assign d3 = (deCard3 == 11) ? 1:
					(deCard3 == 12) ? 2:
					(deCard3 == 13) ? 3: 0;
					
	assign d4 = (deCard4 == 11) ? 1:
					(deCard4 == 12) ? 2:
					(deCard4 == 13) ? 3: 0;
					
	assign d5 = (deCard5 == 11) ? 1:
					(deCard5 == 12) ? 2:
					(deCard5 == 13) ? 3: 0;
													
	assign d6 = (deCard6 == 11) ? 1:
					(deCard6 == 12) ? 2:
					(deCard6 == 13) ? 3: 0;				
									
		
	assign batting = sw[9:7];				

	assign myCard = (result != 0) ? 0 :{myCard1,myCard2,myCard3,myCard4,myCard5,myCard6};
	assign deCard = (result != 0) ? 0 :{deCard1,deCard2,deCard3,deCard4,deCard5,deCard6};
	
	assign isHaveA = myCard1 == 1 | myCard2 == 1 | myCard3 == 1|
							myCard4 == 1 | myCard5 ==1 | myCard6 == 1;
							
	assign isAto11 = (sw[17] == 1 & isHaveA) ? 10 : 0;
	
	randomGenerator r0(clk,key,rand0);
	
	assign mySum = myCard1 + myCard2 + myCard3 + myCard4 + myCard5 + myCard6
							+isAto11 - c1 - c2 - c3 -c4 -c5 -c6;
							
	assign deSum = deCard1 + deCard2 + deCard3 + deCard4 + deCard5 + deCard6
						- d1 - d2 - d3 -d4 - d5 - d6;
						 

	wire [3:0] ones,tens;
	
	assign ones = mySum % 10;
	assign tens = (mySum - ones) / 10;
	
	display_7seg ds0(myCard[11:8],sw[16],result,HEX0);
	display_7seg ds1(myCard[15:12],sw[16],result,HEX1);
	display_7seg ds2(myCard[19:16],sw[16],result,HEX2);
	display_7seg ds3(myCard[23:20],sw[16],result,HEX3);
	display_7seg ds4(deCard[23:20],sw[16],result,HEX4);
	display_7seg ds5(deCard[19:16],sw[16],result,HEX5);
	display_7seg2 ds6(ones,HEX6);
	display_7seg2 ds7(tens,HEX7);
	
	initial begin
	
		myCard1 = 0; myCard2 = 0; myCard3 = 0;
		myCard4 = 0; myCard5 = 0; myCard6 = 0;
		deCard1 = 0; deCard2 = 0; deCard3 = 0;
		deCard4 = 0; deCard5 = 0; deCard6 = 0;
		rand1 = 0; rand2 = 0; rand3 = 0; rand4 = 0; rand5 = 0; rand6 = 0; rand7 = 0; rand8 = 0;
		result = 0; score = 0; LEDR = 0;
	
	end
	
	integer i = 0;
	integer j = 0;
	
	always @(posedge sw[16]) begin
	
			if(result != 0)begin
				if(result == 1) begin
					if(score > 0) score = score - batting * 2;
				end
				else if(result == 2) score = score + batting * 2;
				else if(result == 3) score = score;
				else if(result == 4) score = score + batting * 3;
				
			end
			for(i=0;i<18;i=i+1) begin
				if(i == score) LEDR[i] = 1;
				else LEDR[i] = 0;
			end
	end
	
	always @(posedge clk) begin
		
		if(key[1] ==0) begin
			result = 0;
			
			myCard1 = rand1;
			myCard2 = rand2;
			deCard1 = rand3;
			deCard2 = rand4;
			
			myCard3 = 0; myCard4 = 0;
			myCard5 = 0; myCard6 = 0;
			deCard3 = 0; deCard4 = 0;
			deCard5 = 0; deCard6 = 0;
			
			if(mySum == 21) result = 4;
			
		end
		
		else if(key[2] == 0) begin //hit
			
			if(sw[1] == 1) begin
			
				myCard3 = rand5;
				if(mySum > 21) result  = 1;
				else if(mySum == 21) result = 4;
				
			end
			
			else if(sw[2] == 1) begin
				myCard4 = rand6;
				if(mySum > 21) result = 1;
				else if(mySum == 21) result = 4;
				
			end
			
			else if(sw[3] == 1) begin
				myCard5 = rand7;
				if(mySum > 21) result = 1;
				else if(mySum == 21) result = 4;
				
			end
			
			else if(sw[4] == 1) begin
			
				myCard6 = rand8;
				if(mySum > 21) result = 1;
				else if(mySum == 21) result = 4;			
				
			end						
		end
		
		else if(key[3] == 0) begin
			
			if(deSum <= 16) begin
				for(j=0;j<4;j=j+1) begin
					if(deSum <= 16) begin
						if(j == 0) deCard3 = rand5;
						else if(j == 1) deCard4 = rand6;
						else if(j == 2) deCard5 = rand7;
						else deCard6 = rand8;
					
					end			
				
				end
			
			end
			
			if(mySum == 21) result = 4;
			else if(deSum > 21) result = 2;
			else if(mySum == deSum) result = 3;
			else if(mySum > deSum) result = 2;
			else result = 1;
		
		end
		
	end
	
	always @(negedge key[1], negedge key[2]) begin
		
		if(key[1] == 0) begin
			
			rand1 = rand0 % 13 + 1;
			rand2 = (rand0 + 23) % 13 + 1;
			rand3 = (rand0 + 33) % 13 + 1;
			rand4 = (rand0 + 43) % 13 + 1;
		
		end
		
		if(key[2] == 0)begin
	
			rand5 = rand0 % 13 + 1;
			rand6 = (rand0 + 25) % 13 + 1;
			rand6 = (rand0 + 15) % 13 + 1;
			rand6 = (rand0 + 35) % 13 + 1;
			
		end

	end

endmodule

module randomGenerator(clk,key,randResult);

	input clk;
	input [3:0]key;
	output [3:0]randResult;
	
	reg [32:0] cnt;
	reg [3:0] randTemp;
	
	initial begin
		randTemp = 0;
		cnt = 0;
	end
	
	always @(posedge clk) begin
	
		if(key[1] == 0 | key[2] == 0 | key[3] == 0) cnt = cnt + 1;
		else randTemp = cnt % 15 + 1;
		
		if(cnt == 500000000) cnt = 0;
		
	end

	assign randResult = randTemp;
	
endmodule

module display_7seg2(sw,HEX);

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

module display_7seg(sw,cntl,res,HEX);

   input[3:0] sw;
	input [2:0] res;
	input cntl;
   output [0:6]HEX;
   
   assign HEX = (sw == 4'b0001 && cntl == 0) ? 7'b0001000: //A
                (sw == 4'b0010 && cntl == 0) ? 7'b0010010: //2
                (sw == 4'b0011 && cntl == 0) ? 7'b0000110: //3
                (sw == 4'b0100 && cntl == 0) ? 7'b1001100: //4
                (sw == 4'b0101 && cntl == 0) ? 7'b0100100: //5
                (sw == 4'b0110 && cntl == 0) ? 7'b0100000: //6
                (sw == 4'b0111 && cntl == 0) ? 7'b0001101: //7
                (sw == 4'b1000 && cntl == 0) ? 7'b0000000: //8
                (sw == 4'b1001 && cntl == 0) ? 7'b0000100: //9
                (sw == 4'b1010 && cntl == 0) ? 7'b0000001: //10
                (sw == 4'b1011 && cntl == 0) ? 7'b0100111: //j
                (sw == 4'b1100 && cntl == 0) ? 7'b0001100: //q
                (sw == 4'b1101 && cntl == 0) ? 7'b1111000:
					 (sw >= 4'b1110 && cntl == 0) ? 7'b1111111: //k else nothing
					 (res == 3'b000 && cntl == 1) ? 7'b0000001:
					 (res == 3'b001 && cntl == 1) ? 7'b1001111:
					 (res == 3'b010 && cntl == 1) ? 7'b0010010:
					 (res == 3'b011 && cntl == 1) ? 7'b0000110:
					 (res == 3'b100 && cntl == 1) ? 7'b1001100: 7'b1111111; 
   
endmodule

