`timescale 1ns / 1ps

module proctb;
  reg clk;
  
  reg [63:0] PC;

  reg stat[0:2]; // |AOK|INS|HLT|

  // wire [3:0] icode;
  // wire [3:0] ifun;
  // wire [3:0] rA;
  // wire [3:0] rB; 
  // wire [63:0] valC;
  // wire [63:0] valP;
  // wire instr_valid;
  // wire imem_error;
  // wire [63:0] valA;
  // wire [63:0] valB;
  // wire [63:0] valE;
  // wire [63:0] val4;
  // wire [63:0] valM;
  // wire cnd;
  // wire hltins;
  
  wire [63:0] updated_pc;
  wire [63:0] f_pred_pc;

  wire [2:0] f_stat;
  wire [3:0] f_icode;
  wire [3:0] f_ifun;
  wire [63:0] f_rA;
  wire [63:0] f_rB;
  wire [63:0] f_valC;
  wire [63:0] f_valP;
  
  wire reg [2:0] d_stat;
  wire reg [3:0] d_icode;
  wire reg [3:0] d_ifun;
  wire reg [63:0] d_rA;
  wire reg [63:0] d_rB;
  wire reg [63:0] d_valC;
  wire reg [63:0] d_valP;

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



  f_reg(
    .clk(clk),
    .pred_pc(updated_pc),
    .f_pred_pc(f_pred_pc)
  );  

  m_reg(
    
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
    .valM(valM),
    .datamem(datamem)
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
    #50 $finish;
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
    else if(instr_valid)
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
    $monitor("clk=%d icode=%b ifun=%b rA=%b rB=%b valA=%d valB=%d valC=%d valE=%d valM=%d insval=%d memerr=%d cnd=%d halt=%d 0=%d 1=%d 2=%d 3=%d 4=%d zf=%d sf=%d of=%d",clk,icode,ifun,rA,rB,valA,valB,valC,valE,valM,instr_valid,imem_error,cnd,stat[2],reg_mem0,reg_mem1,reg_mem2,reg_mem3,reg_mem4,zf,sf,of);
		// $monitor("clk=%d icode=%b ifun=%b rA=%b rB=%b valA=%d valB=%d valC=%d valE=%d valM=%d insval=%d memerr=%d cnd=%d halt=%d 0=%d 1=%d 2=%d 3=%d 4=%d 5=%d 6=%d 7=%d 8=%d 9=%d 10=%d 11=%d 12=%d 13=%d 14=%d datamem=%d\n",clk,icode,ifun,rA,rB,valA,valB,valC,valE,valM,instr_valid,imem_error,cnd,stat[2],reg_mem0,reg_mem1,reg_mem2,reg_mem3,reg_mem4,reg_mem5,reg_mem6,reg_mem7,reg_mem8,reg_mem9,reg_mem10,reg_mem11,reg_mem12,reg_mem13,reg_mem14,datamem);
		
endmodule
