`timescale 1ns / 1ps

`include "../Add/add32x1.v"
`include "../Add/add1x1.v"
`include "../Sub/sub32x1.v"
`include "../Sub/not/not1x1.v"
`include "../Sub/not/not32x1.v"
`include "../Xor/xor32x1.v"
`include "../Xor/xor1x1.v"
`include "../And/and32x1.v"
`include "../And/and1x1.v"

module alu(
  input [1:0]control,
  input signed [31:0]a,
  input signed [31:0]b,
  output signed [31:0]ans,
  output overflow
  );
  
  wire signed [31:0]ans1;
  wire signed [31:0]ans2;
  wire signed [31:0]ans3;
  wire signed [31:0]ans4;
  reg signed [31:0]ansfinal;
  reg overflowfinal;

  add32x1 g1(a,b,ans1,overflow1); 
  sub32x1 g2(a,b,ans2,overflow2);
  and32x1 g3(a,b,ans3);
  xor32x1 g4(a,b,ans4);
  always @(*)
  begin
    case(control)
      2'b00:begin
          ansfinal=ans1;
          overflowfinal=overflow1;
        end
      2'b01:begin
          ansfinal=ans2;
          overflowfinal=overflow2;
        end    
      2'b10:begin
          ansfinal=ans3;
          overflowfinal=1'b0;
        end
      2'b11:begin
          ansfinal=ans4;
          overflowfinal=1'b0;
        end
    endcase
  end  

  assign ans= ansfinal;
  assign overflow= overflowfinal;
endmodule