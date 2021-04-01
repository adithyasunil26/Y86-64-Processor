`timescale 1ns / 1ps

module not64x1(
  input signed [63:0]a,
  output signed [63:0]ans
);

  genvar i;

  generate for(i=0; i<64; i=i+1) 
  begin
    not1x1 g1(a[i],ans[i]);
  end
  endgenerate  

endmodule