module fetch(
  clk,
  //instruction fields
  icode, ifun, rA, rB, valC, valp,
  reg1, reg2, val1, val2,
  icodeo, ifuno, rAo, rBo, valA, valB, valCo,valPo 

);

  input clk;

  input reg [3:0] icode;
  input reg [3:0] ifun;
  input reg [3:0] rA;
  input reg [3:0] rB;
  input reg [3:0] valC;
  input reg [3:0] valP;

endmodule