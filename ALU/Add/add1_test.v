`timescale 1ns / 1ps

module add_test;
  reg a;
  reg b;
  reg cin;
  wire signed sum;
  wire carryout;

  add1 uut(
    .a(a),
    .b(b),
    .cin(cin),
    .sum(sum),
    .co(co)
  );

  initial begin
		$dumpfile("add_test.vcd");
    $dumpvars(0,add_test);
		a = 1'b0;
		b = 1'b0;

		#100;

		#20 a=1'd1;b=1'd0;cin=1'd0;
    #20 a=1'd1;b=1'd1;cin=1'd0;
    #20 a=1'd1;b=1'd0;cin=1'd1;
    #20 a=1'd0;b=1'd0;cin=1'd0;
	end
	
  initial begin 
		$monitor("a=%b b=%b sum=%b carryout=%d\n",a,b,sum,co);
	end
endmodule