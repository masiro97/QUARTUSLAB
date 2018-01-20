module L7part3(key0,key3,clk,sw,LEDR,HEX0,HEX1,HEX2);
 
	input clk,key0,key3; //reset
	input [7:0]sw;
	
	output reg LEDR; //LEDR0
	output [0:6] HEX0,HEX1,HEX2;
	
	wire [7:0]elapsed;
	assign elapsed	= sw[0] + 2*sw[1] + 4*sw[2] + 8*sw[3] + 16*sw[4] + 32*sw[5] + 64*sw[6] + 128*sw[7];
	reg [25:0]t;
	reg [29:0]cnt;
	reg [25:0]cnt2;
	reg [25:0]store;
	reg Isstart;
	wire [3:0]hundreds,tens,ones;
	
	initial begin
	
		t = 0;
		cnt = 0;
		store = 0;
		Isstart = 0;
	
	end
	
	always @(posedge clk) begin
	
		cnt <= cnt + 1;
		
		if(cnt == 50000000 * elapsed) begin
		
			LEDR <= 1;
			t <= 0;
			Isstart <= 1;
			
		end
		
		if(Isstart == 1) begin
		
			cnt2 <= cnt2 + 1;
			
			if(cnt2 == 500000) begin //0.01 second
				t <= t + 1;
				store <= t;
				cnt2 <= 0;
			end
			
		end
		
		if(key3 ==0) begin
			LEDR <= 0;
			Isstart <= 0;
			cnt <= 0;
		end
		
		if(key0 == 0) begin
			cnt <= 0;
			store <= 0;
			t <=0;
			cnt <=0;
		end
			
	end

	assign ones = (store % 100) % 10;
	assign tens = ((store % 100) - ones) / 10;
	assign hundreds = (store - tens * 10 - ones) / 100;
	
	display_7seg d2(hundreds,HEX2);
	display_7seg d1(tens,HEX1);
	display_7seg d0(ones,HEX0);
	
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
