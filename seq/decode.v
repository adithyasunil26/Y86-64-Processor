`timescale 1ns / 1ps

module decode(
  icode,rA,rB,
  valA,valB
);

  input reg [3:0] icode;
  input reg [3:0] rA;
  input reg [3:0] rB; 

  output reg [63:0] valA;
  output reg [63:0] valB; 

  if(icode==4'b0010) //cmovxx
  begin
    valA=reg_mem[rA];
  end
  // if(icode==4'b0011) //irmovq
  // begin
  // end
  if(icode==4'b0100) //rmmovq
  begin
    valA=reg_mem[rA];
    valB=reg_mem[rB];
  end
  if(icode==4'b0101) //mrmovq
  begin
    valB=reg_mem[rB];
  end
  if(icode==4'b0110) //OPq
  begin
    valA=reg_mem[rA];
    valB=reg_mem[rB];
  end
  // if(icode==4'b0111) //jxx
  // begin
  // end
  if(icode==4'b1000) //call
  begin
    valB=reg_mem[4]; //rsp
  end
  if(icode==4'b1001) //ret
  begin
    valA=reg_mem[4]; //rsp
    valB=reg_mem[4]; //rsp
  end
  if(icode==4'b1010) //pushq
  begin
    valA=reg_mem[rA];
    valB=reg_mem[4]; //rsp
  end
  if(icode==4'b1011) //popq
  begin
    rA=reg_mem[4]; //rsp
    rB=reg_mem[4]; //rsp
  end

endmodule