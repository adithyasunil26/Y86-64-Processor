`timescale 1ns / 1ps

module add_test;
  reg signed [31:0]a;
  reg signed [31:0]b;

  wire signed [31:0]sum;
  wire overflow;

  add32 uut(
    .a(a),
    .b(b),
    .sum(sum),
    .overflow(overflow)
  );

  initial begin
		$dumpfile("add_test.vcd");
    $dumpvars(0,add_test);
		a = 32'b0;
		b = 32'b0;

		#100;

		#20 a=32'd2147483647;b=32'd1;
    #20 a=-32'd2147483648;b=-32'd1;
    #20 a=32'd23;b=-32'd0;
    #20 a=32'b1001;b=32'b1001;
    #20 a=32'b1001;b=-32'b1001;
    #20 a=-32'd2;b=32'd13;
    #20 a=-32'd2;b=-32'd13;
    #20 a=32'd2;b=-32'd13;
    #20 a=32'd0;b=32'd0;
	end
	
  initial 
		$monitor("a=%d b=%d sum=%d overflow=%d\n",a,b,sum,overflow);
endmodule