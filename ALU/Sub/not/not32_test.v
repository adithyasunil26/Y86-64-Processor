`timescale 1ns / 1ps

module not_test;
  reg signed [31:0]a;
  reg signed [31:0]b;

  wire signed [31:0]ans;

  not32 uut(
    .a(a),
    .ans(ans)
  );

  initial begin
		$dumpfile("not_test.vcd");
    $dumpvars(0,not_test);
		a = 32'b0;

		#100;

		#20 a=32'b1011;
    #20 a=32'b1011;
    #20 a=-32'b1011;
    #20 a=32'b1001;
    #20 a=-32'd2;
    #20 a=-32'd2;
    #20 a=32'b1001;
	end
	
  initial begin 
		$monitor("a=%b b=%b ans=%b\n",a,b,ans);
	end
endmodule