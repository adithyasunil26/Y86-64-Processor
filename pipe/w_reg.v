`timescale 1ns / 1ps

module w_reg(
  clk,
  m_stat,m_icode,m_rA,m_rB,m_valC,m_valP,m_valA,m_valB,m_cnd,m_valE,m_valM,
  w_stat,w_icode,w_rA,w_rB,w_valC,w_valP,w_valA,w_valB,w_cnd,w_valE,w_valM
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
    w_stat    <=   m_stat;
    w_icode   <=   m_icode;
    w_rA      <=   m_rA;
    w_rB      <=   m_rB;
    w_valC    <=   m_valC;
    w_valP    <=   m_valP;
    w_valA    <=   m_valA;
    w_valB    <=   m_valB;
    w_cnd     <=   m_cnd;
    w_valE    <=   m_valE;
    w_valM    <=   m_valM;
  end
endmodule