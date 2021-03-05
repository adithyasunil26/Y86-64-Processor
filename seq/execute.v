`timescale 1ns / 1ps

`include "./ALU/alu.v"

module execute(
  clk,icode,ifun,valA,valB,valC,
  valE,cnd
);

  input clk;
  input [3:0] icode;
  input [3:0] ifun;
  input [63:0] valA;
  input [63:0] valB;
  input [63:0] valC;

  output reg [63:0] valE; 
  output reg cnd;

  reg signed [63:0]anss;
  reg [1:0]control;
  reg signed [63:0]a;
  reg signed [63:0]b;

  wire signed [63:0]ans;
  wire overflow;

  alu alu1(
    .control(control),
    .a(a),
    .b(b),
    .ans(ans),
    .overflow(overflow)
  );

  initial
  begin
    control=2'b00;
		a = 64'b0;
		b = 64'b0;
  end
  
  always@(*)
  begin
    if(icode==4'b0010) //cmovxx
    begin
      valE=64'd0+valA;
    end
    if(icode==4'b0011) //irmovq
    begin
      valE=64'd0+valC;
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
      if(ifun==4'b0000) //add
      begin
        //valE=valA+valB;
        control=2'b00;
		    a = valA;
		    b = valB;
      end
      if(ifun==4'b0001) //sub
      begin
        //valE=valA-valB;
        control=2'b01;
		    a = valA;
		    b = valB;
      end
      if(ifun==4'b0010) //and
      begin
        //valE=valA.valB;
        control=2'b10;
		    a = valA;
		    b = valB;
      end
      if(ifun==4'b0011) //xor
      begin
        //valE=valA^valB;
        control=2'b11;
		    a = valA;
		    b = valB;
      end
      assign anss=ans;
      valE=anss;
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
  end

endmodule
