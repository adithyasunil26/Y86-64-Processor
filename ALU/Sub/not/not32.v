`timescale 1ns / 1ps

module not32(
  input signed [31:0]a,
  output signed [31:0]ans
  );

  genvar i;

  generate for(i=0; i<32; i=i+1) 
  begin
    not1 g1(a[i],ans[i]);
  end
  endgenerate  

endmodule