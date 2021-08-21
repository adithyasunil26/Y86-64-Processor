`timescale 1ns / 1ps

module xor1(
  input a,
  input b,
  output ans
  );

  xor g1(ans,a,b);  

endmodule