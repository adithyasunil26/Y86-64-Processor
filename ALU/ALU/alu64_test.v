`timescale 1ns / 1ps

module Alu_test;
  reg [1:0]control;
  reg signed [63:0]a;
  reg signed [63:0]b;

  wire signed [63:0]ans;
  wire overflow;

  alu uut(
    .control(control),
    .a(a),
    .b(b),
    .ans(ans),
    .overflow(overflow)
  );

  initial begin
    control=2'b00;
		a = 64'b0;
		b = 64'b0;

		#100;

		#20 control=2'b00;a=64'b1011;b=64'b0100;
    #20 control=2'b01;a=64'b1011;b=64'b0100;
    #20 control=2'b10;a=64'b1011;b=64'b0100;
    #20 control=2'b11;a=64'b1011;b=64'b0100;
    #20 control=2'b00;a=-64'b1011;b=64'b0100;
    #20 control=2'b01;a=-64'b1011;b=64'b0100;
    #20 control=2'b10;a=-64'b1011;b=64'b0100;
    #20 control=2'b11;a=-64'b1011;b=64'b0100;
    #20 control=2'b00;a=64'b1011;b=-64'b0100;
    #20 control=2'b01;a=64'b1011;b=-64'b0100;
    #20 control=2'b10;a=64'b1011;b=-64'b0100;
    #20 control=2'b11;a=64'b1011;b=-64'b0100;
    #20 control=2'b00;a=-64'b1011;b=-64'b0100;
    #20 control=2'b01;a=-64'b1011;b=-64'b0100;
    #20 control=2'b10;a=-64'b1011;b=-64'b0100;
    #20 control=2'b11;a=-64'b1011;b=-64'b0100;
    #20 control=2'b00;a=64'd2147483647;b=64'd1;
    #20 control=2'b01;a=64'd2147483647;b=-64'd1;
    #20 control=2'b00;a=64'b0;b=64'b0;
	end
	
  initial 
		$monitor("control=%b a=%b b=%b ans=%b overflow=%b\n",control,a,b,ans,overflow);
endmodule