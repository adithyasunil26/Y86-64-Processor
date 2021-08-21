`timescale 1ns / 1ps

module add_test;
  reg signed [63:0]a;
  reg signed [63:0]b;

  wire signed [63:0]sum;
  wire overflow;

  add64 uut(
    .a(a),
    .b(b),
    .sum(sum),
    .overflow(overflow)
  );

  initial begin
		$dumpfile("add_test.vcd");
    $dumpvars(0,add_test);
		a = 64'b0;
		b = 64'b0;

		#100;

		#20 a=64'd2147483647;b=64'd1;
    #20 a=-64'd2147483648;b=-64'd1;
    #20 a=64'd23;b=-64'd0;
    #20 a=64'b1001;b=64'b1001;
    #20 a=64'b1001;b=-64'b1001;
    #20 a=-64'd2;b=64'd13;
    #20 a=-64'd2;b=-64'd13;
    #20 a=64'd2;b=-64'd13;
    #20 a=64'd0;b=64'd0;
	end
	
  initial 
		$monitor("a=%d b=%d sum=%d overflow=%d\n",a,b,sum,overflow);
endmodule