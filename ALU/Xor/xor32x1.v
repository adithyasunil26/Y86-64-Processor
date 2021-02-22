`timescale 1ns / 1ps

module xor32x1(
  input signed [31:0]a,
  input signed [31:0]b,
  output signed [31:0]ans
  );

  genvar i;

  generate for(i=0; i<32; i=i+1) 
  begin
    xor1x1 g1(a[i],b[i],ans[i]);
  end
  endgenerate  
endmodule