`timescale 1ns / 1ps

module decode(
  
);


    if(icode==4'b0010) //cmovxx
  begin
    rA=instr[8:11];
    rB=instr[12:15];
  end
  if(icode==4'b0011) //irmovq
  begin
    rA=instr[8:11];
    rB=instr[12:15];
  end
  if(icode==4'b0100) //rmmovq
  begin
    rA=instr[8:11];
    rB=instr[12:15];
    valC=instr[16:79];
  end
  if(icode==4'b0101) //mrmovq
  begin
    rA=instr[8:11];
    rB=instr[12:15];
    valC=instr[16:79];
  end
  if(icode==4'b0110) //OPq
  begin
    valA=reg_mem[rA];
    valB=reg_mem[rB];
  end
  if(icode==4'b0111) //jxx
  begin
    valC=instr[8:71];
  end
  if(icode==4'b1000) //call
  begin
    valC=instr[8:71];
  end
  if(icode==4'b1010) //pushq
  begin
    rA=instr[8:11];
    rB=instr[12:15];
  end
  if(icode==4'b1011) //popq
  begin
    rA=instr[8:11];
    rB=instr[12:15];
  end

endmodule