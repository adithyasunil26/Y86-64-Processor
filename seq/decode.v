`timescale 1ns / 1ps

module decode(
  PC,icode,ifun,rA,rB,
  valA,valB
);

  

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