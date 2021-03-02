`timescale 1ns / 1ps

module add1x1(
  input a,
  input b,
  input cin,
  output sum,
  output co);

  xor g1(sum,a,b,cin);
  and g2(k,a,b);
  and g3(l,a,cin);
  and g4(m,b,cin);
  or g5(co,k,l,m);

endmodule