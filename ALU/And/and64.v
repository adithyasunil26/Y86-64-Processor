`timescale 1ns / 1ps

module and64(
  input signed [63:0]a,
  input signed [63:0]b,
  output signed [63:0]ans
);

  genvar i;

  generate for(i=0; i<64; i=i+1) 
  begin
    and1x1 g1(a[i],b[i],ans[i]);
  end
  endgenerate
endmodule