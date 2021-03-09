`timescale 1ns / 1ps

module f_reg(
  clk,pred_pc,
  f_pred_pc
);  
  input clk;
  input [63:0] pred_pc;
  output reg [63:0] f_pred_pc;

  always@(posedge clk)
  begin
    f_pred_pc=pred_pc;
  end
endmodule