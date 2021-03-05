`timescale 1ns / 1ps

module proctb;
  reg clk;
  
  reg [63:0] PC;
  
  reg stat;
  // reg [63:0] reg_mem[0:14];

  wire nop;
  wire halt;
  wire [3:0] icode;
  wire [3:0] ifun;
  wire [3:0] rA;
  wire [3:0] rB; 
  wire [63:0] valC;
  wire [63:0] valP;
  wire instr_valid;
  wire imem_error;
  wire [63:0] valA;
  wire [63:0] valB;
  wire [63:0] valE;
  wire [63:0] val4;
  wire [63:0] valM;
  wire cnd;
  wire [63:0] updated_pc;

  wire [63:0] reg_mem0;
  wire [63:0] reg_mem1;
  wire [63:0] reg_mem2;
  wire [63:0] reg_mem3;
  wire [63:0] reg_mem4;
  wire [63:0] reg_mem5;
  wire [63:0] reg_mem6;
  wire [63:0] reg_mem7;
  wire [63:0] reg_mem8;
  wire [63:0] reg_mem9;
  wire [63:0] reg_mem10;
  wire [63:0] reg_mem11;
  wire [63:0] reg_mem12;
  wire [63:0] reg_mem13;
  wire [63:0] reg_mem14;

  fetch fetch(
    .clk(clk),
    .PC(PC),
    .icode(icode),
    .ifun(ifun),
    .rA(rA),
    .rB(rB),
    .valC(valC),
    .valP(valP),
    .instr_valid(instr_valid),
    .imem_error(imem_error)
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

  register_file reg_file(
    .clk(clk),
    .icode(icode),
    .rA(rA),
    .rB(rB),
    .cnd(cnd),
    .valA(valA),
    .valB(valB),
    .val4(val4),
    .valE(valE),
    .valM(valM),
    .reg_mem0(reg_mem0),
    .reg_mem1(reg_mem1),
    .reg_mem2(reg_mem2),
    .reg_mem3(reg_mem3),
    .reg_mem4(reg_mem4),
    .reg_mem5(reg_mem5),
    .reg_mem6(reg_mem6),
    .reg_mem7(reg_mem7),
    .reg_mem8(reg_mem8),
    .reg_mem9(reg_mem9),
    .reg_mem10(reg_mem10),
    .reg_mem11(reg_mem11),
    .reg_mem12(reg_mem12),
    .reg_mem13(reg_mem13),
    .reg_mem14(reg_mem14)
  );

  memory mem(
    .clk(clk),
    .icode(icode),
    .valA(valA),
    .valB(valB),
    .valE(valE),
    .valP(valP),
    .valM(valM)
  );

  pc_update pcup(
    .clk(clk),
    .PC(PC),
    .icode(icode),
    .cnd(cnd),
    .valC(valC),
    .valM(valM),
    .valP(valP),
    .updated_pc(updated_pc)
  ); 

  // always #5 clk=~clk;

  initial begin
    clk=0;
    PC=64'd32;

    #5 clk=~clk;
    #5 clk=~clk;
    #5 clk=~clk;
  end 

  always@(*)
  begin
    PC=updated_pc;
  end

  always@(*)
  begin
    if(instr_valid==1'b0)
      PC=updated_pc;
  end

  initial 
		$monitor("clk=%d icode=%b ifun=%b rA=%b rB=%b valA=%d valB=%d valC=%d valE=%d valM=%d insval=%d memerr=%d cnd=%d 0=%d 1=%d 2=%d 3=%d 4=%d 5=%d 6=%d 7=%d 8=%d 9=%d 10=%d 11=%d 12=%d 13=%d 14=%d\n",clk,icode,ifun,rA,rB,valA,valB,valC,valE,valM,instr_valid,imem_error,cnd,reg_mem0,reg_mem1,reg_mem2,reg_mem3,reg_mem4,reg_mem5,reg_mem6,reg_mem7,reg_mem8,reg_mem9,reg_mem10,reg_mem11,reg_mem12,reg_mem13,reg_mem14);
		
endmodule
