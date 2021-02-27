`timescale 1ns / 1ps

module memory(
  icode,valA,valB,valE,valM
);

  input reg [3:0] icode;
  input reg [63:0] valA;
  input reg [63:0] valB;
  input reg [63:0] valE;
  
  output reg [63:0] valM;

  // if(icode==4'b0010) //cmovxx
  // begin
  // end
  // if(icode==4'b0011) //irmovq
  // begin
  // end
  if(icode==4'b0100) //rmmovq
  begin
    data_mem[valE]=valA;
  end
  if(icode==4'b0101) //mrmovq
  begin
    valM=data_mem[valE];
  end
  // if(icode==4'b0110) //OPq
  // begin
  //   if(ifun==4'b0000) //add
  //   begin
  //   end
  //   if(ifun==4'b0001) //sub
  //   begin
  //   end
  //   if(ifun==4'b0010) //and
  //   begin
  //   end
  //   if(ifun==4'b0011) //xor
  //   begin
  //   end
  // end
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
    data_mem[valE]=valA;
  end
  if(icode==4'b1011) //popq
  begin
    valE=64'd8+valB;
  end

endmodule