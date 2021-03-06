`timescale 1ns / 1ps

module register_file(
  clk,
  d_icode,d_rA,d_rB, 
  valA,valB,val4,
  valE,valM,
  reg_mem0,reg_mem1,reg_mem2,reg_mem3,reg_mem4,reg_mem5,
  reg_mem6,reg_mem7,reg_mem8,reg_mem9,reg_mem10,reg_mem11,
  reg_mem12,reg_mem13,reg_mem14
);

  input clk;
  input [3:0] d_icode;
  input [3:0] d_rA;
  input [3:0] d_rB;
  output reg [63:0] d_valA;
  output reg [63:0] d_valB;
  output reg [63:0] d_val4;
  input [63:0] d_valE;
  input [63:0] d_valM;

  output reg [63:0] d_reg_mem0;
  output reg [63:0] d_reg_mem1;
  output reg [63:0] d_reg_mem2;
  output reg [63:0] d_reg_mem3;
  output reg [63:0] d_reg_mem4;
  output reg [63:0] d_reg_mem5;
  output reg [63:0] d_reg_mem6;
  output reg [63:0] d_reg_mem7;
  output reg [63:0] d_reg_mem8;
  output reg [63:0] d_reg_mem9;
  output reg [63:0] d_reg_mem10;
  output reg [63:0] d_reg_mem11;
  output reg [63:0] d_reg_mem12;
  output reg [63:0] d_reg_mem13;
  output reg [63:0] d_reg_mem14;

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
    if(d_icode==4'b0010) //cmovxx
    begin
      d_valA=reg_mem[rA];
    end
    else if(d_icode==4'b0100) //rmmovq
    begin
      d_valA=reg_mem[rA];
      d_valB=reg_mem[rB];
    end
    else if(d_icode==4'b0101) //mrmovq
    begin
      d_valB=reg_mem[rB];
    end
    else if(d_icode==4'b0110) //OPq
    begin
      d_valA=reg_mem[rA];
      d_valB=reg_mem[rB];
    end
    else if(d_icode==4'b1000) //call
    begin
      d_valB=reg_mem[4]; //rsp
    end
    else if(d_icode==4'b1001) //ret
    begin
      d_valA=reg_mem[4]; //rsp
      d_valB=reg_mem[4]; //rsp
    end
    else if(d_icode==4'b1010) //pushq
    begin
      d_valA=reg_mem[rA];
      d_valB=reg_mem[4]; //rsp
    end
    else if(d_icode==4'b1011) //popq
    begin
      d_valA=reg_mem[4]; //rsp
      d_valB=reg_mem[4]; //rsp
    end
    d_reg_mem0=reg_mem[0];
    d_reg_mem1=reg_mem[1];
    d_reg_mem2=reg_mem[2];
    d_reg_mem3=reg_mem[3];
    d_reg_mem4=reg_mem[4];
    d_reg_mem5=reg_mem[5];
    d_reg_mem6=reg_mem[6];
    d_reg_mem7=reg_mem[7];
    d_reg_mem8=reg_mem[8];
    d_reg_mem9=reg_mem[9];
    d_reg_mem10=reg_mem[10];
    d_reg_mem11=reg_mem[11];
    d_reg_mem12=reg_mem[12];
    d_reg_mem13=reg_mem[13];
    d_reg_mem14=reg_mem[14];
  end

  //write_back
  always@(negedge clk)
  begin
    if(w_icode==4'b0010) //cmovxx
    begin
      if(cnd==1'b1)
      begin
        reg_mem[rB]=w_valE;
      end
    end
    else if(w_icode==4'b0011) //irmovq
    begin
      reg_mem[rB]=w_valE;
    end
    else if(w_icode==4'b0101) //mrmovq
    begin
      reg_mem[rA]=w_valM;
    end
    else if(w_icode==4'b0110) //OPq
    begin
      reg_mem[rB]=w_valE;
    end
    else if(w_icode==4'b1000) //call
    begin
      reg_mem[4]=w_valE;
    end
    else if(w_icode==4'b1001) //ret
    begin
      reg_mem[4]=w_valE;
    end
    else if(w_icode==4'b1010) //pushq
    begin
      reg_mem[4]=w_valE;
    end
    else if(w_icode==4'b1011) //popq
    begin
      reg_mem[4]=w_valE;
      reg_mem[rA]=w_valM;
    end
    w_reg_mem0=reg_mem[0];
    w_reg_mem1=reg_mem[1];
    w_reg_mem2=reg_mem[2];
    w_reg_mem3=reg_mem[3];
    w_reg_mem4=reg_mem[4];
    w_reg_mem5=reg_mem[5];
    w_reg_mem6=reg_mem[6];
    w_reg_mem7=reg_mem[7];
    w_reg_mem8=reg_mem[8];
    w_reg_mem9=reg_mem[9];
    w_reg_mem10=reg_mem[10];
    w_reg_mem11=reg_mem[11];
    w_reg_mem12=reg_mem[12];
    w_reg_mem13=reg_mem[13];
    w_reg_mem14=reg_mem[14];
  end

endmodule
