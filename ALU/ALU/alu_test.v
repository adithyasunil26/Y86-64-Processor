`timescale 1ns / 1ps

module Alu_test;
  reg [1:0]control;
  reg signed [31:0]a;
  reg signed [31:0]b;

  wire signed [31:0]ans;
  wire overflow;

  alu uut(
    .control(control),
    .a(a),
    .b(b),
    .ans(ans),
    .overflow(overflow)
  );

  initial begin
		$dumpfile("Alu_test.vcd");
    $dumpvars(0,Alu_test);
    control=2'b00;
		a = 32'b0;
		b = 32'b0;

		#100;

		#20 control=2'b00;a=32'b1011;b=32'b0100;
    #20 control=2'b01;a=32'b1011;b=32'b0100;
    #20 control=2'b10;a=32'b1011;b=32'b0100;
    #20 control=2'b11;a=32'b1011;b=32'b0100;
    #20 control=2'b00;a=-32'b1011;b=32'b0100;
    #20 control=2'b01;a=-32'b1011;b=32'b0100;
    #20 control=2'b10;a=-32'b1011;b=32'b0100;
    #20 control=2'b11;a=-32'b1011;b=32'b0100;
    #20 control=2'b00;a=32'b1011;b=-32'b0100;
    #20 control=2'b01;a=32'b1011;b=-32'b0100;
    #20 control=2'b10;a=32'b1011;b=-32'b0100;
    #20 control=2'b11;a=32'b1011;b=-32'b0100;
    #20 control=2'b00;a=-32'b1011;b=-32'b0100;
    #20 control=2'b01;a=-32'b1011;b=-32'b0100;
    #20 control=2'b10;a=-32'b1011;b=-32'b0100;
    #20 control=2'b11;a=-32'b1011;b=-32'b0100;
    #20 control=2'b00;a=32'd2147483647;b=32'd1;
    #20 control=2'b01;a=32'd2147483647;b=-32'd1;
    #20 control=2'b00;a=32'b0;b=32'b0;
	end
	
  initial 
		$monitor("control=%b a=%b b=%b ans=%b overflow=%b\n",control,a,b,ans,overflow);
endmodule