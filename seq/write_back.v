`timescale 1ns / 1ps

module write_back(
  icode,rA,rB,valA,valB,valE,valM
);

  input reg [3:0] icode;
  input reg [3:0] rA;
  input reg [3:0] rB;
  input reg [63:0] valA;
  input reg [63:0] valB;
  input reg [63:0] valE;
  input reg [63:0] valM;


  if(icode==4'b0010) //cmovxx
  begin
    reg_mem[rB]=valE;
  end
  if(icode==4'b0011) //irmovq
  begin
    reg_mem[rB]=valE;
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
    reg_mem[rB]=valE;
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

endmodule