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

  always@(icode)
  begin
    if(icode==4'b0010) //cmovxx
    begin
      reg_mem[rB]=valE;
    end
    if(icode==4'b0011) //irmovq
    begin
      reg_mem[rB]=valE;
    end
    // if(icode==4'b0100) //rmmovq
    // begin
    // end
    if(icode==4'b0101) //mrmovq
    begin
      reg_mem[rA]=valM;
    end
    if(icode==4'b0110) //OPq
    begin
      reg_mem[rB]=valE;
    end
    // if(icode==4'b0111) //jxx
    // begin
    // end
    if(icode==4'b1000) //call
    begin
      reg_mem[4]=valE;
    end
    if(icode==4'b1001) //ret
    begin
      reg_mem[4]=valE;
    end

    if(icode==4'b1010) //pushq
    begin
      reg_mem[4]=valE;
    end
    if(icode==4'b1011) //popq
    begin
      reg_mem[4]=valE;
      reg_mem[rA]=valM;
    end
  end

endmodule