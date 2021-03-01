`timescale 1ns / 1ps
module fetchtb;
  reg clk;
  reg [63:0] PC;
  
  wire [3:0] icode;
  wire [3:0] ifun;
  wire [3:0] rA;
  wire [3:0] rB; 
  wire [63:0] valC;
  wire [63:0] valP;

  fetch uut(
    .clk(clk),
    .PC(PC),
    .icode(icode),
    .ifun(ifun),
    .rA(rA),
    .rB(rB),
    .valC(valC),
    .valP(valP)
  );
  
  initial begin 
    clk=0;
    PC=64'd0;

    #10 clk=~clk;PC=64'd0;
    #10 clk=~clk;
    #10 clk=~clk;PC=64'd10;
    #10 clk=~clk;
    #10 clk=~clk;PC=64'd20;
    #10 clk=~clk;
    #10 clk=~clk;PC=64'd30;
    #10 clk=~clk;
    #10 clk=~clk;PC=64'd40;
    #10 clk=~clk;
    #10 clk=~clk;PC=64'd50;
    #10 clk=~clk;
    #10 clk=~clk;PC=64'd60;
    #10 clk=~clk;
    #10 clk=~clk;PC=64'd70;
    #10 clk=~clk;
    #10 clk=~clk;PC=64'd80;
    #10 clk=~clk;
    #10 clk=~clk;PC=64'd90;
    #10 clk=~clk;
    #10 clk=~clk;PC=64'd100;
    #10 clk=~clk;
    #10 clk=~clk;PC=64'd110;
    #10 clk=~clk;
  end 
  
  initial 
		$monitor("clk=%d PC=%d icode=%b ifun=%b rA=%b rB=%b,valC=%d,valP=%d\n",clk,PC,icode,ifun,rA,rB,valC,valP);
endmodule
