`timescale 1ns / 1ps

module decode(
  icode,rA,rB,reg_memrA,reg_memrB,reg_memr4,
  valA,valB
);

  input [3:0] icode;
  input [3:0] rA;
  input [3:0] rB; 
  input [63:0] reg_memrA;
  input [63:0] reg_memrB;
  input [63:0] reg_memr4;

  output reg [63:0] valA;
  output reg [63:0] valB; 

  always@(icode)
  begin
    if(icode==4'b0010) //cmovxx
    begin
      valA=reg_memrA;
    end
    // if(icode==4'b0011) //irmovq
    // begin
    // end
    if(icode==4'b0100) //rmmovq
    begin
      valA=reg_memrA;
      valB=reg_memrB;
    end
    if(icode==4'b0101) //mrmovq
    begin
      valB=reg_memrB;
    end
    if(icode==4'b0110) //OPq
    begin
      valA=reg_memrA;
      valB=reg_memrB;
    end
    // if(icode==4'b0111) //jxx
    // begin
    // end
    if(icode==4'b1000) //call
    begin
      valB=reg_memr4; //rsp
    end
    if(icode==4'b1001) //ret
    begin
      valA=reg_memr4; //rsp
      valB=reg_memr4; //rsp
    end
    if(icode==4'b1010) //pushq
    begin
      valA=reg_memrA;
      valB=reg_memr4; //rsp
    end
    if(icode==4'b1011) //popq
    begin
      valA=reg_memr4; //rsp
      valB=reg_memr4; //rsp
    end
  end

endmodule