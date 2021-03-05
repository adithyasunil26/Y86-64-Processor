`timescale 1ns / 1ps

module fetch(
  clk,PC,
  icode,ifun,rA,rB,valC,valP
);

  input clk;
  input [63:0] PC;
  output reg [3:0] icode;
  output reg [3:0] ifun;
  output reg [3:0] rA;
  output reg [3:0] rB; 
  output reg [63:0] valC;
  output reg [63:0] valP;

  reg [7:0] instr_mem[0:1023];

  reg [0:79] instr;

  initial begin
  //Instruction memory

  //cmovxx
    instr_mem[0]=8'b00100000; //2 fn
    instr_mem[1]=8'b00010011; //rA rB

  //irmovq
    instr_mem[2]=8'b00110000; //3 0
    instr_mem[3]=8'b00000000; //F rB
    instr_mem[4]=8'b00000000; //V
    instr_mem[5]=8'b00000000; //V
    instr_mem[6]=8'b00000000; //V
    instr_mem[7]=8'b00000000; //V
    instr_mem[8]=8'b00000000; //V
    instr_mem[9]=8'b00000000; //V
    instr_mem[10]=8'b00000000; //V
    instr_mem[11]=8'b00000000; //V

  //rmmovq
    instr_mem[12]=8'b01000000; //4 0
    instr_mem[13]=8'b00000000; //rA rB
    instr_mem[14]=8'b00000000; //D
    instr_mem[15]=8'b00000000; //D
    instr_mem[16]=8'b00000000; //D
    instr_mem[17]=8'b00000000; //D
    instr_mem[18]=8'b00000000; //D
    instr_mem[19]=8'b00000000; //D
    instr_mem[20]=8'b00000000; //D
    instr_mem[21]=8'b00000000; //D

  //mrmovq
    instr_mem[22]=8'b01010000; //5 0
    instr_mem[23]=8'b00000000; //rA rB
    instr_mem[24]=8'b00000000; //D
    instr_mem[25]=8'b00000000; //D
    instr_mem[26]=8'b00000000; //D
    instr_mem[27]=8'b00000000; //D
    instr_mem[28]=8'b00000000; //D
    instr_mem[29]=8'b00000000; //D
    instr_mem[30]=8'b00000000; //D
    instr_mem[31]=8'b00000000; //D

  //OPq
    instr_mem[32]=8'b01100000; //5 fn
    instr_mem[33]=8'b00100100; //rA rB


  //jxx
    instr_mem[34]=8'b01110000; //7 fn
    instr_mem[35]=8'b00000000; //Dest
    instr_mem[36]=8'b00000000; //Dest
    instr_mem[37]=8'b00000000; //Dest
    instr_mem[38]=8'b00000000; //Dest
    instr_mem[39]=8'b00000000; //Dest
    instr_mem[40]=8'b00000000; //Dest
    instr_mem[41]=8'b00000000; //Dest
    instr_mem[42]=8'b00000000; //Dest

  //call
    instr_mem[43]=8'b10000000; //8 0
    instr_mem[44]=8'b00000000; //Dest
    instr_mem[45]=8'b00000000; //Dest
    instr_mem[46]=8'b00000000; //Dest
    instr_mem[47]=8'b00000000; //Dest
    instr_mem[48]=8'b00000000; //Dest
    instr_mem[49]=8'b00000000; //Dest
    instr_mem[50]=8'b00000000; //Dest
    instr_mem[51]=8'b00000000; //Dest

  //ret
    instr_mem[52]=8'b10010000; // 9 0
    
  //pushq
    instr_mem[53]=8'b10100000; //A 0
    instr_mem[54]=8'b00000000; //rA F

  //popq
    instr_mem[55]=8'b10110000; //B 0
    instr_mem[56]=8'b00000000; //rA F

  //nop
    instr_mem[57]=8'b00010000; //1 0

  //halt
    instr_mem[58]=8'b00000000; // 0 0

  end  

  always@(posedge clk) 
  begin 
    instr={
      instr_mem[PC],
      instr_mem[PC+1],
      instr_mem[PC+2],
      instr_mem[PC+3],
      instr_mem[PC+4],
      instr_mem[PC+5],
      instr_mem[PC+6],
      instr_mem[PC+7],
      instr_mem[PC+8],
      instr_mem[PC+9]
    };
    icode= instr[0:3];
    ifun= instr[4:7];

    if(icode==4'b0000) //halt
    begin
      valP=PC+64'd1;
    end
    if(icode==4'b0001) //nop
    begin
      valP=PC+64'd1;
    end
    if(icode==4'b0010) //cmovxx
    begin
      rA=instr[8:11];
      rB=instr[12:15];
      valP=PC+64'd2;
    end
    if(icode==4'b0011) //irmovq
    begin
      rA=instr[8:11];
      rB=instr[12:15];
      valC=instr[16:79];
      valP=PC+64'd10;
    end
    if(icode==4'b0100) //rmmovq
    begin
      rA=instr[8:11];
      rB=instr[12:15];
      valC=instr[16:79];
      valP=PC+64'd10;
    end
    if(icode==4'b0101) //mrmovq
    begin
      rA=instr[8:11];
      rB=instr[12:15];
      valC=instr[16:79];
      valP=PC+64'd10;
    end
    if(icode==4'b0110) //OPq
    begin
      rA=instr[8:11];
      rB=instr[12:15];
      valP=PC+64'd2;
    end
    if(icode==4'b0111) //jxx
    begin
      valC=instr[8:71];
      valP=PC+64'd9;
    end
    if(icode==4'b1000) //call
    begin
      valC=instr[8:71];
      valP=PC+64'd9;
    end
    if(icode==4'b1001) //ret
    begin
      valC=instr[8:71];
      valP=PC+64'd1;
    end
    if(icode==4'b1010) //pushq
    begin
      rA=instr[8:11];
      rB=instr[12:15];
      valP=PC+64'd2;
    end
    if(icode==4'b1011) //popq
    begin
      rA=instr[8:11];
      rB=instr[12:15];
      valP=PC+64'd2;
    end
  end

endmodule
