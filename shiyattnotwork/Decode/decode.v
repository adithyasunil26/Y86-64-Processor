module decode(
  clk,
  //instruction fields
  icode, ifun, rA, rB, valC, valp,

  reg1, reg2, val1, val2,
  
  icodeo, ifuno, rAo, rBo, valA, valB, valCo,valPo 

);

  input reg clk;

  input reg [3:0] icode;
  input reg [3:0] ifun;
  input reg [3:0] rA;
  input reg [3:0] rB;
  input reg [3:0] valC;
  input reg [3:0] valP;

  output reg [3:0] icodeo; 
	output reg [3:0] ifuno; 
	output reg [3:0] rAo; 
	output reg [3:0] rBo; 
	output reg [31:0] valA; 
	output reg [31:0] valB; 
	output reg [31:0] valCo; 
	output reg [31:0] valPo; 

  output reg [3:0] reg1;
	output reg [3:0] reg2;
	input [31:0] val1;
	input [31:0] val2;

  always @ (posedge clock) 
  begin
    if (icode == 'hA || icode == 8 || icode == 9) begin
			reg1 <= rA;
			reg2 <= 6;
		end
		else if (icode == 'hB) begin
			reg1 <= 6;
			reg2 <= 6;
		end
		else begin
			reg1 <= rA;
			reg2 <= rB;
		end
		
		valA <= value1;
		valB <= value2;
		
		icodeo <= icode;
		ifuno <= ifun; 
		rAo <= rA; 
		rBo <= rB;
		valCo <= valC;
		valPo <= valP; 
		predo <= pred;
  end

endmodule