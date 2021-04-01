`timescale 1ns / 1ps

module pc_update(
  clk,PC,cnd,icode,valC,valM,valP,
  updated_pc
);
  input clk;
  input cnd;
  input [3:0] icode;
  input [63:0] valC;
  input [63:0] valP;
  input [63:0] valM;
  input [63:0] PC;
  output reg [63:0] updated_pc;

  always@(*)
  begin
    if(icode==4'b0111) //jxx
    begin
      if(cnd==1'b1)
      begin
        updated_pc=valC;
      end
      else
      begin
        updated_pc=valP;
      end
    end
    else if(icode==4'b1000) //call
    begin
      updated_pc=valC;
    end
    else if(icode==4'b1001) //ret
    begin
      updated_pc=valM;
    end
    else
    begin
      updated_pc=valP;
    end
  end

endmodule
