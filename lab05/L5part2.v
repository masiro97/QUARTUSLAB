module L5part2 (Clk, D, Q);

  input Clk, D;
  output Q;

  reg R,S,R_g, S_g /* synthesis keep */ ;
  wire Qa,Qb;

  always @(Clk,D) begin
 
  R = ~D;
  S = D;
  R_g = R & Clk;
  S_g = S & Clk;
  
  end
  
  assign Qa = ~(R_g|Qb);
  assign Qb = ~(S_g|Qa);
  assign Q = Qa;
  
endmodule
