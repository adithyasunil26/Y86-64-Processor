`timescale 1ns / 1ps

module execute(
  clk,icode,ifun,valA,valB,valC,
  valE,cnd
);

  input clk;
  input [3:0] icode;
  input [3:0] ifun;
  input [63:0] valA;
  input [63:0] valB;
  input [63:0] valC;

  output reg [63:0] valE; 
  output reg cnd;

  always@(posedge clk)
  begin
    if(icode==4'b0010) //cmovxx
    begin
      valE=64'd0+valA;
    end
    if(icode==4'b0011) //irmovq
    begin
      valE=64'd0+valC;
    end
    if(icode==4'b0100) //rmmovq
    begin
      valE=valB+valC;
    end
    if(icode==4'b0101) //mrmovq
    begin
      valE=valB+valC;
    end
    if(icode==4'b0110) //OPq
    begin
      if(ifun==4'b0000) //add
      begin
        //valE=valA+valB;
      end
      if(ifun==4'b0001) //sub
      begin
        //valE=valA-valB;
      end
      if(ifun==4'b0010) //and
      begin
        //valE=valA.valB;
      end
      if(ifun==4'b0011) //xor
      begin
        //valE=valA^valB;
      end
    end
    if(icode==4'b0111) //jxx
    begin
      //cnd=cond(cc,ifun)
    end
    if(icode==4'b1000) //call
    begin
      valE=-64'd8+valB;
    end
    if(icode==4'b1001) //ret
    begin
      valE=64'd8+valB;
    end
    if(icode==4'b1010) //pushq
    begin
      valE=-64'd8+valB;
    end
    if(icode==4'b1011) //popq
    begin
      valE=64'd8+valB;
    end
  end

endmodule
