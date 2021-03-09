`timescale 1ns / 1ps

module e_reg(
  clk,
  d_stat,d_icode,d_ifun,d_rA,d_rB,d_valC,d_valP,d_valA,d_valB,
  e_stat,e_icode,e_ifun,e_rA,e_rB,e_valC,e_valP,e_valA,e_valB
);  
  input clk;
  input [2:0]  d_stat;
  input [3:0]  d_icode;
  input [3:0]  d_ifun;
  input [3:0]  d_rA;
  input [3:0]  d_rB;
  input [63:0] d_valC;
  input [63:0] d_valP;
  input [63:0] d_valA;
  input [63:0] d_valB;
  output reg [2:0]  e_stat;
  output reg [3:0]  e_icode;
  output reg [3:0]  e_ifun;
  output reg [3:0]  e_rA;
  output reg [3:0]  e_rB;
  output reg [63:0] e_valC;
  output reg [63:0] e_valP;
  output reg [63:0] e_valA;
  output reg [63:0] e_valB;

  always@(posedge clk)
  begin
    e_stat    <=  d_stat;    
    e_icode   <=  d_icode;     
    e_ifun    <=  d_ifun;    
    e_rA      <=  d_rA;  
    e_rB      <=  d_rB;  
    e_valC    <=  d_valC;    
    e_valP    <=  d_valP;    
    e_valA    <=  d_valA;    
    e_valB    <=  d_valB;    
  end
endmodule