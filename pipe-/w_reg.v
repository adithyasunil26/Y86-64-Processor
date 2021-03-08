`timescale 1ns / 1ps

module w_reg(
  clk,
  m_stat,m_icode,m_valE,m_valM,
  w_stat,w_icode,w_valE,w_valM
);  
  input clk;
  
  input [2:0]  m_stat;
  input [3:0]  m_icode;
  input [3:0]  m_rA;
  input [3:0]  m_rB;
  input [63:0] m_valC;
  input [63:0] m_valP;
  input [63:0] m_valA;
  input [63:0] m_valB;
  input        m_cnd;
  input [63:0] m_valE;
  input [63:0] m_valM;

  output reg [2:0]  w_stat;
  output reg [3:0]  w_icode;
  output reg [3:0]  w_rA;
  output reg [3:0]  w_rB;
  output reg [63:0] w_valC;
  output reg [63:0] w_valP;
  output reg [63:0] w_valA;
  output reg [63:0] w_valB;
  output reg        w_cnd;
  output reg [63:0] w_valE;
  output reg [63:0] w_valM;

  always@(posedge clk)
  begin
    w_stat    =   m_stat;
    w_icode   =   m_icode;
    w_rA      =   m_cnd;
    w_rB      =   m_rA;
    w_valC    =   m_rB;
    w_valP    =   m_valC;
    w_valA    =   m_valP;
    w_valB    =   m_valA;
    w_cnd     =   m_valB;
    w_valE    =   m_valE;
    w_valM    =   m_valM;
  end
endmodule