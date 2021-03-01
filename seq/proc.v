`timescale 1ns / 1ps

module proc();
  
  reg clk;

  reg [63:0] PC;
  
  initial
  begin
    PC=64'd0;
    clk=1'b0;
  end

  reg [63:0] reg_mem[0:14];
  reg [63:0] data_mem[0:255];

  //fetch stage
  wire [3:0] icode; 
	wire [3:0] ifun; 
	wire [3:0] rA; 
	wire [3:0] rB;
	wire [63:0] valC;

  //decode stage
  wire [63:0] valA;
  wire [63:0] valB;

  //execute stage
  wire [63:0] valE;
  wire CC;

	wire [63:0] valP; 
  reg [63:0] valM; 

  always #5 clk = ~clk;

  fetch fetch(clk,PC,icode,ifun,rA,rB,valC,valP);
  decode decode(clk,icode,rA,rB,reg_mem[rA],reg_mem[rB],reg_mem[4],valA,valB);
  execute execute(clk,icode,ifun,valA,valB,valC,valE,CC);
  //memory memory(icode,valA,valB,valE,valP,valM);
  //write_back wb(icode,rA,rB,valA,valB,valE,valM);

  wire a;
  assign a=1'b1;

  always@(a)
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
  end

  assign a=1'b0;

  initial 
		$monitor("icode=%b ifun=%b \n",icode,ifun);
  //pc_update pcup(PC,icode,updated_pc);
endmodule