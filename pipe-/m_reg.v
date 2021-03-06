`timescale 1ns / 1ps

module m_reg(
  clk,
  e_stat,e_icode,e_cnd,e_valE,e_valA,
  m_stat,m_icode,m_cnd,m_valE,m_valA
);  
  input clk;
  input [2:0]  e_stat ;
  input [3:0]  e_icode;
  input        e_cnd  ; 
  input [63:0] e_valE ;
  input [63:0] e_valA ;
  output reg [2:0]   m_stat ;
  output reg [3:0]   m_icode;
  input              m_cnd  ; 
  output reg [63:0]  m_valE ;
  output reg [63:0]  m_valA ;

  always@(posedge clk)
  begin
    m_stat = e_stat ;
    m_icode= e_icode;
    m_cnd  = e_cnd  ;
    m_valE = e_valE ;
    m_valA = e_valA ;
  end
endmodule










