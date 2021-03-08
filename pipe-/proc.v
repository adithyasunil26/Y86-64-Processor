`timescale 1ns / 1ps

`include "d_reg.v"
`include "e_reg.v"
`include "f_reg.v"
`include "m_reg.v"
`include "w_reg.v"
`include "fetch.v"
`include "execute.v"
`include "decode_wb.v"
`include "memory.v"
`include "pc_update.v"

module proctb;
  reg clk;
  
  reg [63:0] PC;

  reg stat[0:2]; // |AOK|INS|HLT|
  
  wire [63:0] updated_pc;
  wire [63:0] f_pred_pc;

  wire [2:0]  f_stat;
  wire [3:0]  f_icode;
  wire [3:0]  f_ifun; 
  wire [3:0]  f_rA;
  wire [3:0]  f_rB;
  wire [63:0] f_valC;
  wire [63:0] f_valP;
  wire        imem_error;
  wire        hltins;
  
  wire [2:0]  d_stat;
  wire [3:0]  d_icode;
  wire [3:0]  d_ifun;
  wire [3:0]  d_rA;
  wire [3:0]  d_rB;
  wire [63:0] d_valC;
  wire [63:0] d_valP;
  wire [63:0] d_valA;
  wire [63:0] d_valB;
  wire [63:0] d_val4;

  wire [2:0]  e_stat;
  wire [3:0]  e_icode;
  wire [3:0]  e_ifun;
  wire [63:0] e_valC;
  wire [63:0] e_valA;
  wire [63:0] e_valB;
  wire [63:0] e_valE;
  wire [63:0] e_valP;

  wire [2:0]  m_stat;
  wire [3:0]  m_icode;
  wire        m_cnd;
  wire [63:0] m_valE;
  wire [63:0] m_valA;
  wire [63:0] m_valB;
  wire [63:0] m_valM;
  wire [63:0] m_valP;
  
  wire [2:0]  w_stat ;
  wire [3:0]  w_icode;
  wire        w_cnd;
  wire [3:0]  w_rA;
  wire [3:0]  w_rB;
  wire [63:0] w_valE ;
  wire [63:0] w_valM ;
  wire [63:0] w_valP;
  wire [63:0] w_valC;

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
  wire [63:0] datamem;

  f_reg freg(
    .clk(clk),
    .pred_pc(f_valP),
    .f_pred_pc(f_pred_pc)
  );  

  d_reg dreg(
    .clk(clk),
    .f_stat(f_stat),
    .f_icode(f_icode),
    .f_ifun(f_ifun),
    .f_rA(f_rA),
    .f_rB(f_rB),
    .f_valC(f_valC),
    .f_valP(f_valP),
    .d_stat(d_stat),
    .d_icode(d_icode),
    .d_ifun(d_ifun),
    .d_rA(d_rA),
    .d_rB(d_rB),
    .d_valC(d_valC),
    .d_valP(d_valP)
  );

  e_reg ereg( 
    .clk(clk),
    .d_stat(d_stat),
    .d_icode(d_icode),
    .d_ifun(d_ifun),
    .d_valC(d_valC),
    .d_valA(d_valA),
    .d_valB(d_valB),
    .e_stat(e_stat),
    .e_icode(e_icode),
    .e_ifun(e_ifun),
    .e_valC(e_valC),
    .e_valA(e_valA),
    .e_valB(e_valB)
  );

  m_reg mreg(
    .clk(clk),
    .e_stat(e_stat),
    .e_icode(e_icode),
    .e_cnd(e_cnd),
    .e_valE(e_valE),
    .e_valA(e_valA),
    .m_stat(m_stat),
    .m_icode(m_icode),
    .m_cnd(m_cnd),
    .m_valE(m_valE),
    .m_valA(m_valA)
  );

  w_reg wreg(
    .clk(clk),
    .m_stat(m_stat),
    .m_icode(m_icode),
    .m_valE(m_valE),
    .m_valM(m_valM),
    .w_stat(w_stat),
    .w_icode(w_icode),
    .w_valE(w_valE),
    .w_valM(w_valM)
  );

  pc_update pcup(
    .clk(clk),
    .PC(PC),
    .icode(w_icode),
    .cnd(w_cnd),
    .valC(w_valC),
    .valM(w_valM),
    .valP(f_pred_pc),
    .updated_pc(updated_pc)
  ); 

  fetch fetch(
    .clk(clk),
    .PC(PC),
    .icode(f_icode),
    .ifun(f_ifun),
    .rA(f_rA),
    .rB(f_rB),
    .valC(f_valC),
    .valP(f_valP),
    .instr_valid(instr_valid),
    .imem_error(imem_error),
    .hlt(hltins)
  );

  execute execute(
    .clk(clk),
    .icode(e_icode),
    .ifun(e_ifun),
    .valA(e_valA),
    .valB(e_valB),
    .valC(e_valC),
    .valE(e_valE),
    .sf(sf),
    .zf(zf),
    .of(of),
    .cnd(cnd)
  );

  decode_wb decode_wb(
    .clk(clk),
    .d_icode(d_icode),
    .d_rA(d_rA),
    .d_rB(d_rB),
    .d_cnd(d_cnd),
    .d_valA(d_valA),
    .d_valB(d_valB),
    .w_icode(w_icode),
    .w_rA(w_rA),
    .w_rB(w_rB),
    .w_cnd(w_cnd),
    .w_valE(w_valE),
    .w_valM(w_valM),
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
    .icode(m_icode),
    .valA(m_valA),
    .valB(m_valB),
    .valE(m_valE),
    .valP(m_valP),
    .valM(m_valM),
    .datamem(datamem)
  );

  always #5 clk=~clk;

  initial begin
    stat[0]=1;
    stat[1]=0;
    stat[2]=0;
    clk=0;
    PC=64'd32;

    // #5 clk=~clk;
    // #5 clk=~clk;
    // #5 clk=~clk;
    // #5 clk=~clk;
    // #5 clk=~clk;
    // #5 clk=~clk;
    // #5 clk=~clk;
    // #5 clk=~clk;
    #100 $finish;
  end 

  always@(*)
  begin
    PC=updated_pc;
  end

  always@(*)
  begin
    if(hltins)
    begin
      stat[2]=hltins;
      stat[1]=1'b0;
      stat[0]=1'b0;
    end
    else if(instr_valid==1'b0)
    begin
      stat[1]=instr_valid;
      stat[2]=1'b0;
      stat[0]=1'b0;
    end
    else
    begin
      stat[0]=1'b1;
      stat[1]=1'b0;
      stat[2]=1'b0;
    end
  end
  
  always@(*)
  begin
    if(stat[2]==1'b1)
    begin
      $finish;
    end
  end

  initial 
    //$monitor("clk=%d 0=%d 1=%d 2=%d 3=%d 4=%d zf=%d sf=%d of=%d",clk,reg_mem0,reg_mem1,reg_mem2,reg_mem3,reg_mem4,zf,sf,of);
    $monitor("clk=%d f_icode=%b f_ifun=%b f_rA=%b f_rB=%b d_valA=%d d_valB=%d d_valC=%d e_valE=%d m_valM=%d insval=%d memerr=%d cnd=%d halt=%d 0=%d 1=%d 2=%d 3=%d 4=%d",clk,f_icode,f_ifun,f_rA,f_rB,d_valA,d_valB,d_valC,e_valE,m_valM,instr_valid,imem_error,cnd,stat[2],reg_mem0,reg_mem1,reg_mem2,reg_mem3,reg_mem4);
		// $monitor("clk=%d icode=%b ifun=%b rA=%b rB=%b valA=%d valB=%d valC=%d valE=%d valM=%d insval=%d memerr=%d cnd=%d halt=%d 0=%d 1=%d 2=%d 3=%d 4=%d 5=%d 6=%d 7=%d 8=%d 9=%d 10=%d 11=%d 12=%d 13=%d 14=%d datamem=%d\n",clk,icode,ifun,rA,rB,valA,valB,valC,valE,valM,instr_valid,imem_error,cnd,stat[2],reg_mem0,reg_mem1,reg_mem2,reg_mem3,reg_mem4,reg_mem5,reg_mem6,reg_mem7,reg_mem8,reg_mem9,reg_mem10,reg_mem11,reg_mem12,reg_mem13,reg_mem14,datamem);
		
endmodule
