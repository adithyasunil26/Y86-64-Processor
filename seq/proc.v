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

  always #5 clk = ~clk;

  always@(posedge clk)
  begin 
    fetch(PC,icode,ifun,rA,rB,valC);
    decode(icode,rA,rB,valA,valB);
    execute(icode,ifun,valA,valB,valC,valE,CC);
    memory(icode,valA,valB,valE,valP,valM);
    write_back(icode,rA,rB,valA,valB,valE,valM);
    pc_update(pc,icode,updated_pc)
  end

endmodule