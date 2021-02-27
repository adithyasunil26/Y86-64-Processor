`timescale 1ns / 1ps

module proc();
  
  reg clk;

  wire [63:0] pc;
  pipeline=64'bz;

  //fetch stage
  wire [3:0] icode; 
	wire [3:0] ifun; 
	wire [3:0] rA; 
	wire [3:0] rB;
	wire [63:0] valC;

  //decode stage
  wire [63:0] valA;
  wire [63:0] valB;

  //execute stage
  wire [63:0] valE;
  wire CC;

	wire [63:0] valP; 

  fetch(PC,icode,ifun,rA,rB,valC);
  decode(icode,rA,rB,valA,valB);
  execute(icode,ifun,valA,valB,valC,valE,CC);
  memory(icode,valA,valB,valE,valP,valM);
  write_back();

endmodule