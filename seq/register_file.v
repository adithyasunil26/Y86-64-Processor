`timescale 1ns / 1ps

module register_file(
  clk,icode,rA,rB,cnd,
  valA,valB,val4,
  valE,valM
);

  input clk;
  input cnd;
  input [3:0] icode;
  input [3:0] rA;
  input [3:0] rB;
  output reg [63:0] valA;
  output reg [63:0] valB;
  output reg [63:0] val4;
  input [63:0] valE;
  input [63:0] valM;

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
  end

  //write_back
  always@(posedge clk)
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
  end

endmodule
