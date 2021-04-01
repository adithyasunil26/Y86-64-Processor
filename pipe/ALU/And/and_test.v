`timescale 1ns / 1ps

module And_test;
  reg signed [31:0]a;
  reg signed [31:0]b;

  wire signed [31:0]ans;

  and32x1 uut(
    .a(a),
    .b(b),
    .ans(ans)
  );

  initial begin
		$dumpfile("And_test.vcd");
    $dumpvars(0,And_test);
		a = 32'b0;
		b = 32'b0;

		#100;

		#20 a=32'b1011;b=32'b0100;
    #20 a=32'b1011;b=32'b1100;
    #20 a=-32'b1011;b=32'b1100;
    #20 a=32'b1001;b=32'b1001;
    #20 a=-32'd2;b=32'd13;
    #20 a=-32'd2;b=-32'd13;
    #20 a=32'b1001;b=32'b1001;
	end
	
  initial 
		$monitor("a=%b b=%b ans=%b\n",a,b,ans);
endmodule