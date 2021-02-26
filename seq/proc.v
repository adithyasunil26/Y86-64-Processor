`timescale 1ns / 1ps

module proc();
  
  reg clk;

  wire [63:0] pc;
  pipeline=64'bz;

  wire [3:0] fetch_icode; 
	wire [3:0] fetch_ifun; 
	wire [3:0] fetch_rA; 
	wire [3:0] fetch_rB;
	wire [63:0] fetch_valC;

	wire [63:0] fetch_valP; 

  fetch(PC,fetch_icode,fetch_ifun,fetch_rA,fetch_rB,fetch_valC);
  decode();
  execute();
  memory();
  write_back();

endmodule