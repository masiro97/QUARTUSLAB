module L6part4(key0,key1,clk,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7);
	input key0,key1,clk;
	output reg [0:6] HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,HEX6,HEX7; 
	reg [25:0] cnt;
	
	initial begin
	cnt = 0;
	HEX7 = 7'b1111111;
	HEX6 = 7'b1111111;
	HEX5 = 7'b1111111;
	HEX4 = 7'b1001000;
	HEX3 = 7'b0110000;
	HEX2 = 7'b1110001;
	HEX1 = 7'b1110001;
	HEX0 = 7'b0000001;
	
	end
	
	always @(posedge clk) begin
		cnt = cnt + 1;
		if (cnt == 50000000) begin
		
			if(key1 == 0) begin // When key1 is pushed, Stop
			HEX7 <= HEX7;
			HEX6 <= HEX6;
			HEX5 <= HEX5;
			HEX4 <= HEX4;
			HEX3 <= HEX3;
			HEX2 <= HEX2;
			HEX1 <= HEX1;
			HEX0 <= HEX0;
			end
			
			else if(key0 == 0) begin //when key0 is pushed, right shifted
			HEX0 <= HEX1;
			HEX1 <= HEX2;
			HEX2 <= HEX3;
			HEX3 <= HEX4;
			HEX4 <= HEX5;
			HEX5 <= HEX6;
			HEX6 <= HEX7;
			HEX7 <= HEX0;
			end
			
			else begin //when default, left shifted

			HEX7 <= HEX6;
			HEX6 <= HEX5;
			HEX5 <= HEX4;
			HEX4 <= HEX3;
			HEX3 <= HEX2;
			HEX2 <= HEX1;
			HEX1 <= HEX0;
			HEX0 <= HEX7;
			end

		cnt = 0;
		end
	end
endmodule
