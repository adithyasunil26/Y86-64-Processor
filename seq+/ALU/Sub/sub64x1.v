`timescale 1ns / 1ps

module sub64x1(
  input signed [63:0]a,
  input signed [63:0]b,
  output signed [63:0]ans,
  output overflow
);

  wire [63:0]nb;
  not64x1 g1(b,nb);

  wire [63:0]l;
  assign l=64'b1;

  wire [63:0]bcomp;
  add64x1 g2(nb,l,bcomp,c);

  add64x1 g3(a,bcomp,ans,overflow);

endmodule