`timescale 1ns / 1ps

module decode_wb(
  clk,icode,rA,rB,cnd,
  valA,valB,
  valE,valM,
  reg_mem0,reg_mem1,reg_mem2,reg_mem3,reg_mem4,reg_mem5,
  reg_mem6,reg_mem7,reg_mem8,reg_mem9,reg_mem10,reg_mem11,
  reg_mem12,reg_mem13,reg_mem14
);

  input clk;
  input cnd;
  input [3:0] icode;
  input [3:0] rA;
  input [3:0] rB;
  output reg [63:0] valA;
  output reg [63:0] valB;
  input [63:0] valE;
  input [63:0] valM;

  output reg [63:0] reg_mem0;
  output reg [63:0] reg_mem1;
  output reg [63:0] reg_mem2;
  output reg [63:0] reg_mem3;
  output reg [63:0] reg_mem4;
  output reg [63:0] reg_mem5;
  output reg [63:0] reg_mem6;
  output reg [63:0] reg_mem7;
  output reg [63:0] reg_mem8;
  output reg [63:0] reg_mem9;
  output reg [63:0] reg_mem10;
  output reg [63:0] reg_mem11;
  output reg [63:0] reg_mem12;
  output reg [63:0] reg_mem13;
  output reg [63:0] reg_mem14;

  reg [63:0] reg_mem[0:14];

  initial begin
    reg_mem[0]=64'd0;
    reg_mem[1]=64'd1;
    reg_mem[2]=64'd2;
    reg_mem[3]=64'd3;
    reg_mem[4]=64'd4;
    reg_mem[5]=64'd5;
    reg_mem[6]=64'd6;
    reg_mem[7]=64'd7;
    reg_mem[8]=64'd8;
    reg_mem[9]=64'd9;
    reg_mem[10]=64'd10;
    reg_mem[11]=64'd11;
    reg_mem[12]=64'd12;
    reg_mem[13]=64'd13;
    reg_mem[14]=64'd14;
  end

  //decode
  always@(*)
  begin
    if(icode==4'b0010) //cmovxx
    begin
      valA=reg_mem[rA];
    end
    else if(icode==4'b0100) //rmmovq
    begin
      valA=reg_mem[rA];
      valB=reg_mem[rB];
    end
    else if(icode==4'b0101) //mrmovq
    begin
      valB=reg_mem[rB];
    end
    else if(icode==4'b0110) //OPq
    begin
      valA=reg_mem[rA];
      valB=reg_mem[rB];
    end
    else if(icode==4'b1000) //call
    begin
      valB=reg_mem[4]; //rsp
    end
    else if(icode==4'b1001) //ret
    begin
      valA=reg_mem[4]; //rsp
      valB=reg_mem[4]; //rsp
    end
    else if(icode==4'b1010) //pushq
    begin
      valA=reg_mem[rA];
      valB=reg_mem[4]; //rsp
    end
    else if(icode==4'b1011) //popq
    begin
      valA=reg_mem[4]; //rsp
      valB=reg_mem[4]; //rsp
    end
    reg_mem0=reg_mem[0];
    reg_mem1=reg_mem[1];
    reg_mem2=reg_mem[2];
    reg_mem3=reg_mem[3];
    reg_mem4=reg_mem[4];
    reg_mem5=reg_mem[5];
    reg_mem6=reg_mem[6];
    reg_mem7=reg_mem[7];
    reg_mem8=reg_mem[8];
    reg_mem9=reg_mem[9];
    reg_mem10=reg_mem[10];
    reg_mem11=reg_mem[11];
    reg_mem12=reg_mem[12];
    reg_mem13=reg_mem[13];
    reg_mem14=reg_mem[14];
  end

  //write_back
  always@(negedge clk)
  begin
    if(icode==4'b0010) //cmovxx
    begin
      if(cnd==1'b1)
      begin
        reg_mem[rB]=valE;
      end
    end
    else if(icode==4'b0011) //irmovq
    begin
      reg_mem[rB]=valE;
    end
    else if(icode==4'b0101) //mrmovq
    begin
      reg_mem[rA]=valM;
    end
    else if(icode==4'b0110) //OPq
    begin
      reg_mem[rB]=valE;
    end
    else if(icode==4'b1000) //call
    begin
      reg_mem[4]=valE;
    end
    else if(icode==4'b1001) //ret
    begin
      reg_mem[4]=valE;
    end
    else if(icode==4'b1010) //pushq
    begin
      reg_mem[4]=valE;
    end
    else if(icode==4'b1011) //popq
    begin
      reg_mem[4]=valE;
      reg_mem[rA]=valM;
    end
    reg_mem0=reg_mem[0];
    reg_mem1=reg_mem[1];
    reg_mem2=reg_mem[2];
    reg_mem3=reg_mem[3];
    reg_mem4=reg_mem[4];
    reg_mem5=reg_mem[5];
    reg_mem6=reg_mem[6];
    reg_mem7=reg_mem[7];
    reg_mem8=reg_mem[8];
    reg_mem9=reg_mem[9];
    reg_mem10=reg_mem[10];
    reg_mem11=reg_mem[11];
    reg_mem12=reg_mem[12];
    reg_mem13=reg_mem[13];
    reg_mem14=reg_mem[14];
  end

endmodule
