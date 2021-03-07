`timescale 1ns / 1ps

module w_reg(
  clk,
  m_stat,m_icode,m_valE,m_valM,
  w_stat,w_icode,w_valE,w_valM
);  
  input clk;
  input [2:0]  m_stat ;
  input [3:0]  m_icode;
  input [63:0] m_valE ;
  input [63:0] m_valM ;
  output reg [2:0]   w_stat ;
  output reg [3:0]   w_icode;
  output reg [63:0]  w_valE ;
  output reg [63:0]  w_valM ;

  always@(posedge clk)
  begin
    w_stat = m_stat ;
    w_icode= m_icode;
    w_valE = m_valE ;
    w_valA = m_valM ;
  end
endmodule