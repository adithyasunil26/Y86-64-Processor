`timescale 1ns / 1ps

module pc_update(
  pc,icode,updated_pc
);

  input reg [3:0] icode;
  input reg [63:0] pc;
  output reg [63:0] updated_pc;

  updated_pc=pc+63'd10;

  // if(icode==4'b0010) //cmovxx
  // begin
  //   reg_mem[rB]=valE;
  // end
  // if(icode==4'b0011) //irmovq
  // begin
  //   reg_mem[rB]=valE;
  // end
  // // if(icode==4'b0100) //rmmovq
  // // begin
  // // end
  // if(icode==4'b0101) //mrmovq
  // begin
  //   reg_mem[rA]=valM;
  // end
  // if(icode==4'b0110) //OPq
  // begin
  //   reg_mem[rB]=valE;
  // end
  // // if(icode==4'b0111) //jxx
  // // begin
  // // end
  // if(icode==4'b1000) //call
  // begin
  //   reg_mem[4]=valE;
  // end
  // if(icode==4'b1001) //ret
  // begin
  //   reg_mem[4]=valE;
  // end

  // if(icode==4'b1010) //pushq
  // begin
  //   reg_mem[4]=valE;
  // end
  // if(icode==4'b1011) //popq
  // begin
  //   reg_mem[4]=valE;
  //   reg_mem[rA]=valM;
  // end

endmodule