module L5part1(Clk,R,S,Q);
  input Clk,R,S;
  output Q;

  reg R_g, S_g /* synthesis keep */ ;
  wire Qa,Qb;

  always @(Clk,R,S) begin
 
  R_g = R & Clk;
  S_g = S & Clk;
  
  end
  
  assign Qa = ~(R_g|Qb);
  assign Qb = ~(S_g|Qa);
  assign Q = Qa;
  
endmodule
