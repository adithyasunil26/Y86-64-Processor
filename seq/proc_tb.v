`timescale 1ns / 1ps

module fetchdecodetb;
  reg clk;
  reg [63:0] PC;
  reg [63:0] reg_mem[0:14];
  reg [63:0] data_mem[0:255];

  wire [3:0] icode;
  wire [3:0] ifun;
  wire [3:0] rA;
  wire [3:0] rB; 
  wire [63:0] valC;
  wire [63:0] valP;
  wire [63:0] valA;
  wire [63:0] valB;
  wire [63:0] valE;
  reg [63:0] valM;
  wire cnd;


  fetch fetch(
    .clk(clk),
    .PC(PC),
    .icode(icode),
    .ifun(ifun),
    .rA(rA),
    .rB(rB),
    .valC(valC),
    .valP(valP)
  );

  decode decode(
    .clk(clk),
    .icode(icode),
    .rA(rA),
    .rB(rB),
    .reg_memrA(reg_mem[rA]),
    .reg_memrB(reg_mem[rB]),
    .reg_memr4(reg_mem[4]),
    .valA(valA),
    .valB(valB)
  );

  execute execute(
    .clk(clk),
    .icode(icode),
    .ifun(ifun),
    .valA(valA),
    .valB(valB),
    .valC(valC),
    .valE(valE),
    .cnd(cnd)
  );

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

    clk=0;
    PC=64'd0;

    #10 clk=~clk;PC=64'd0;
    #10 clk=~clk;
    #10 clk=~clk;PC=valP;
    #10 clk=~clk;
    #10 clk=~clk;PC=valP;
    #10 clk=~clk;
    #10 clk=~clk;PC=valP;
    #10 clk=~clk;
    #10 clk=~clk;PC=valP;
    #10 clk=~clk;
    #10 clk=~clk;PC=valP;
    #10 clk=~clk;
    #10 clk=~clk;PC=valP;
    #10 clk=~clk;
    #10 clk=~clk;PC=valP;
    #10 clk=~clk;
    #10 clk=~clk;PC=valP;
    #10 clk=~clk;
    #10 clk=~clk;PC=valP;
    #10 clk=~clk;
    #10 clk=~clk;PC=valP;
    #10 clk=~clk;
    #10 clk=~clk;PC=valP;
    #10 clk=~clk;
    #10 clk=~clk;PC=valP;
    #10 clk=~clk;
    #10 clk=~clk;
  end 
  
  always@(posedge clk)
  begin
    if(icode==4'b0010) //cmovxx
    begin
      reg_mem[rB]=valE;
    end
    if(icode==4'b0011) //irmovq
    begin
      reg_mem[rB]=valE;
    end
    if(icode==4'b0100) //rmmovq
    begin
      data_mem[valE]=valA;
    end
    if(icode==4'b0101) //mrmovq
    begin
      valM=data_mem[valE];
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
      data_mem[valE]=valP;
      reg_mem[4]=valE;
    end
    if(icode==4'b1001) //ret
    begin
      valM=data_mem[valA];
      reg_mem[4]=valE;
    end

    if(icode==4'b1010) //pushq
    begin
      data_mem[valE]=valA;
      reg_mem[4]=valE;
    end
    if(icode==4'b1011) //popq
    begin
      valM=data_mem[valE];
      reg_mem[4]=valE;
      reg_mem[rA]=valM;
    end

    if(icode==4'b1000) //call
    begin
      PC=valC;
    end
    if(icode==4'b0111 && cnd) //jxx
    begin
      PC=valC;
    end
    if(icode==4'b1001) //ret
    begin
      PC=valM;
    end
    else
    begin
      PC=valP;
    end
  end

  initial 
		$monitor("clk=%d icode=%b ifun=%b rA=%b rB=%b valA=%d valB=%d valE=%d valM=%d\n",clk,icode,ifun,rA,rB,valA,valB,valE,valM);
endmodule
