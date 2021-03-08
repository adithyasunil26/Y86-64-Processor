`timescale 1ns / 1ps

module m_reg(
  clk,
  e_stat,e_icode,e_rA,e_rB,e_valC,e_valP,e_valA,e_valB,e_cnd,e_valE,
  m_stat,m_icode,m_rA,m_rB,m_valC,m_valP,m_valA,m_valB,m_cnd,m_valE
);  
  input clk;
  
  input [2:0]  e_stat;
  input [3:0]  e_icode;
  input [3:0]  e_rA;
  input [3:0]  e_rB;
  input [63:0] e_valC;
  input [63:0] e_valP;
  input [63:0] e_valA;
  input [63:0] e_valB;
  input        e_cnd;
  input [63:0] e_valE;

  output reg [2:0]  m_stat;
  output reg [3:0]  m_icode;
  output reg [3:0]  m_rA;
  output reg [3:0]  m_rB;
  output reg [63:0] m_valC;
  output reg [63:0] m_valP;
  output reg [63:0] m_valA;
  output reg [63:0] m_valB;
  output reg        m_cnd;
  output reg [63:0] m_valE;

  always@(posedge clk)
  begin
    m_stat   =   e_stat;
    m_icode  =   e_icode;
    m_rA     =   e_rA;
    m_rB     =   e_rB;
    m_valC   =   e_valC;
    m_valP   =   e_valP;
    m_valA   =   e_valA;
    m_valB   =   e_valB;
    m_cnd    =   e_cnd;
    m_valE   =   e_valE;
  end
endmodule