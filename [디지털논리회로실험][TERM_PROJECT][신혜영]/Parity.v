module Parity(sw,clk,key,HEX0,HEX1,HEX2,HEX3,HEX4);

	input [15:0]sw;
	input clk;
	input [3:0]key;
	output [0:6] HEX0,HEX1,HEX2,HEX3,HEX4;
	wire [3:0] wp;
	wire [3:0] hp;
	wire [4:0] rwparity0, rwparity1, rwparity2, rwparity3;
	wire [4:0] rhparity0, rhparity1, rhparity2, rhparity3;

	wire [3:0] width, height;
	wire [2:0] f0,f1;
	wire [3:0] rand0;
	reg [3:0] rand1;
	reg [3:0] w,h;
	reg [15:0] num;
	reg [4:0] error;
	reg [26:0] cnt;
	reg start;

	initial begin
		num = sw;
		error = 16;
		w = 0;
		h = 0;
		cnt = 0;
		start = 0;
	end
	
	ParityGenerator w0(sw[3:0],wp[0]);
	ParityGenerator w1(sw[7:4],wp[1]);
	ParityGenerator w2(sw[11:8],wp[2]);
	ParityGenerator w3(sw[15:12],wp[3]);
	
	ParityGenerator h3({sw[3],sw[7],sw[11],sw[15]},hp[3]);
	ParityGenerator h2({sw[2],sw[6],sw[10],sw[14]},hp[2]);
	ParityGenerator h1({sw[1],sw[5],sw[9],sw[13]},hp[1]);
	ParityGenerator h0({sw[0],sw[4],sw[8],sw[12]},hp[0]);
	
	assign rwparity0 = {wp[0],num[3:0]};
	assign rwparity1 = {wp[1],num[7:4]};
	assign rwparity2 = {wp[2],num[11:8]};
	assign rwparity3 = {wp[3],num[15:12]};
	
	assign rhparity0 = {hp[0],num[0],num[4],num[8],num[12]};
	assign rhparity1 = {hp[1],num[1],num[5],num[9],num[13]};
	assign rhparity2 = {hp[2],num[2],num[6],num[10],num[14]};
	assign rhparity3 = {hp[3],num[3],num[7],num[11],num[15]};
	
	OneCounter c0(rwparity0,width[0]);
	OneCounter c1(rwparity1,width[1]);
	OneCounter c2(rwparity2,width[2]);
	OneCounter c3(rwparity3,width[3]);
	
	OneCounter c4(rhparity0,height[0]);
	OneCounter c5(rhparity1,height[1]);
	OneCounter c6(rhparity2,height[2]);
	OneCounter c7(rhparity3,height[3]);
	
	error_inspect e0(width,f0);
	error_inspect e1(height,f1);
	
	randomGenerator rg(clk,key[1],rand0);
	
	always @(negedge key[0],negedge key[1],negedge key[2]) begin
		
		error = 4 * f0 + f1;
		
		if(key[0] == 0) num = sw;
		if(key[1] == 0) begin
		
			num[rand0] = ~sw[rand0];
			rand1 = rand0;
	
			
		end
		
		if(key[2] == 0) begin
			if(error <= 15) num[error] = ~num[error];	
		end
	
	end
		
	
	display_7seg d0(num[3:0],HEX0);
	display_7seg d1(num[7:4],HEX1);
	display_7seg d2(num[11:8],HEX2);
	display_7seg d3(num[15:12],HEX3);
	display_7seg d4(rand1,HEX4);	

	
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
                (sw == 4'b1010) ? 7'b0001000: //A
                (sw == 4'b1011) ? 7'b1100000: //b
                (sw == 4'b1100) ? 7'b0110001: //C
                (sw == 4'b1101) ? 7'b1000010: //d
                (sw == 4'b1110) ? 7'b0110000: //E
                (sw == 4'b1111) ? 7'b0111000: 7'b1111111; //F else nothing
   
endmodule

module ParityGenerator(data_in, parity_out);

	input [3:0] data_in;
	output parity_out;

	assign parity_out = ^data_in;

endmodule

module OneCounter(data_in, normality);

	input [4:0] data_in;
	output normality;
	
	integer oneCount, i = 0;
	
	always @(data_in or oneCount) begin
	
		oneCount = 0;
		
		for(i=0; i<5; i=i+1) begin
			if(data_in[i]) oneCount = oneCount + 1;
		end
	end
	
	assign normality = (oneCount%2 == 0) ? 1'b0 : 1'b1;
	
endmodule

module error_inspect(data,out_data);

	input [3:0] data;
	output [2:0] out_data;
	
	assign out_data = (data == 8) ? 3:
							(data == 4) ? 2:
							(data == 2) ? 1:
							(data == 1) ? 0: 4;

endmodule

module randomGenerator(clk,key,randResult);

	input clk,key;
	output [3:0]randResult;
	
	reg [26:0] cnt;
	reg [3:0] randTemp;
	
	initial begin
		randTemp = 0;
		cnt = 0;
	end
	always @(posedge clk) begin
		if(key == 0) cnt = cnt + 1;
		else 
			randTemp = cnt % 15 + 1;
	end
	assign randResult = randTemp;
	
endmodule
