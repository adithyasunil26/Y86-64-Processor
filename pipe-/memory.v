`timescale 1ns / 1ps

module memory(
  clk,icode,valA,valB,valE,valP,valM,datamem
);

  input clk;
  
  input [3:0] icode;
  input [63:0] valA;
  input [63:0] valB;
  input [63:0] valE;
  input [63:0] valP;
  
  output reg [63:0] valM;
  output reg [63:0] datamem;

  reg [63:0] data_mem[0:255];

  always@(negedge clk)
  begin
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
    // if(icode==4'b0111) //jxx
    // begin
    // end
    if(icode==4'b1000) //call
    begin
      data_mem[valE]=valP;
    end
    if(icode==4'b1001) //ret
    begin
      valM=data_mem[valA];
    end
    if(icode==4'b1010) //pushq
    begin
      data_mem[valE]=valA;
    end
    if(icode==4'b1011) //popq
    begin
      valM=data_mem[valE];
    end
    datamem=data_mem[valE];
  end
  
endmodule
