`timescale 1ns / 1ps

module add32(
  input signed [31:0]a,
  input signed [31:0]b,
  output signed [31:0]sum,
  output overflow);

  wire [32:0]c;
  assign c[0]=1'b0;
  
  genvar i;

  generate for(i=0; i<32; i=i+1) 
  begin
    add1 g1(a[i],b[i],c[i],sum[i],c[i+1]);
  end
  endgenerate

  xor g2(overflow,c[31],c[32]);

endmodule