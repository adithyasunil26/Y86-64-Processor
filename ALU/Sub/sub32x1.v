`timescale 1ns / 1ps

module sub32x1(
  input signed [31:0]a,
  input signed [31:0]b,
  output signed [31:0]ans,
  output overflow);

  wire [31:0]nb;
  not32x1 g1(b,nb);

  wire [31:0]l;
  assign l=32'b1;

  wire [31:0]bcomp;
  add32x1 g2(nb,l,bcomp,c);

  add32x1 g3(a,bcomp,ans,overflow);

endmodule