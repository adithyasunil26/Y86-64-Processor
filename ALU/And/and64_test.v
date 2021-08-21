`timescale 1ns / 1ps

module And_test;
  reg signed [63:0]a;
  reg signed [63:0]b;

  wire signed [63:0]ans;

  and64 uut(
    .a(a),
    .b(b),
    .ans(ans)
  );

  initial begin
		$dumpfile("And_test.vcd");
    $dumpvars(0,And_test);
		a = 64'b0;
		b = 64'b0;

		#100;

		#20 a=64'b1011;b=64'b0100;
    #20 a=64'b1011;b=64'b1100;
    #20 a=-64'b1011;b=64'b1100;
    #20 a=64'b1001;b=64'b1001;
    #20 a=-64'd2;b=64'd13;
    #20 a=-64'd2;b=-64'd13;
    #20 a=64'b1001;b=64'b1001;
	end
	
  initial 
		$monitor("a=%b b=%b ans=%b\n",a,b,ans);
endmodule