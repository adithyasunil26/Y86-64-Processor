`timescale 1ns / 1ps

module d_reg(
  clk,
  f_stat,f_icode,f_ifun,f_rA,f_rB,f_valC,f_valP,
  d_stat,d_icode,d_ifun,d_rA,d_rB,d_valC,d_valP
);  
  input clk;
  input [2:0] f_stat;
  input [3:0] f_icode;
  input [3:0] f_ifun;
  input [3:0] f_rA;
  input [3:0] f_rB;
  input [63:0] f_valC;
  input [63:0] f_valP;
  output reg [2:0] d_stat;
  output reg [3:0] d_icode;
  output reg [3:0] d_ifun;
  output reg [3:0] d_rA;
  output reg [3:0] d_rB;
  output reg [63:0] d_valC;
  output reg [63:0] d_valP;

  always@(posedge clk)
  begin
    d_stat  <= f_stat;
    d_icode <= f_icode;
    d_ifun  <= f_ifun;
    d_rA    <= f_rA;
    d_rB    <= f_rB;
    d_valC  <= f_valC;
    d_valP  <= f_valP;
  end
endmodule