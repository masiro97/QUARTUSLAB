module L5part4 (Clk, D, Qa,Qb,Qc);

  input Clk, D;
  output Qa,Qb,Qc;
  
  D_latch D0 (Clk, D, Qa); 
  flipflop f1 (Clk, D, Qb);
  flipflop f2 (~Clk, D, Qc);
  
endmodule

module flipflop (Clk, D, Q);

 input Clk, D;
  output Q;

  reg R,S,R_g, S_g /* synthesis keep */ ;
  wire Qa,Qb;

  always @(posedge Clk) begin
 
  R = ~D;
  S = D;
  R_g = R & Clk;
  S_g = S & Clk;
  
  end
  
  assign Qa = ~(R_g|Qb);
  assign Qb = ~(S_g|Qa);
  assign Q = Qa;

endmodule

module D_latch (Clk, D, Q);

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


