`timescale 1ns / 1ps

module proc()
  
  reg clk;

  wire [63:0] pc;

  wire [3:0] fetch_icode; 
	wire [3:0] fetch_ifun; 
	wire [3:0] fetch_rA; 
	wire [3:0] fetch_rB;
	wire [31:0] fetch_valC; 
	wire [31:0] fetch_valP; 

  fetch();
  decode();
  execute();
  memory();
  write_back();

endmodule