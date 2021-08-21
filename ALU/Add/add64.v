`timescale 1ns / 1ps

module add64(
  input signed [63:0]a,
  input signed [63:0]b,
  output signed [63:0]sum,
  output overflow
);

  wire [64:0]c;
  assign c[0]=1'b0;
  
  genvar i;

  generate for(i=0; i<64; i=i+1) 
  begin
    add1x1 g1(a[i],b[i],c[i],sum[i],c[i+1]);
  end
  endgenerate

  xor g2(overflow,c[63],c[64]);

endmodule