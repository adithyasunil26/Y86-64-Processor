module fetch(
  clk,
  icode,ifun,rA,rB,valC
)

  reg [7:0] instr_mem[1:1024];
  reg [63:0] reg_mem[14:0];

  reg [63:0] pipeline,stored,PC;
  pipeline=64'bz;
  stored=64'bz;

//Instruction memory
//halt
  instr_mem[0]=8'b00000000; // 0 0
  instr_mem[1]=8'b00000000;
  instr_mem[2]=8'b00000000;
  instr_mem[3]=8'b00000000;
  instr_mem[4]=8'b00000000;
  instr_mem[5]=8'b00000000;
  instr_mem[6]=8'b00000000;
  instr_mem[7]=8'b00000000;
  instr_mem[8]=8'b00000000;
  instr_mem[9]=8'b00000000;

//nop
  instr_mem[10]=8'b00010000; //1 0
  instr_mem[11]=8'b00000000;
  instr_mem[12]=8'b00000000;
  instr_mem[13]=8'b00000000;
  instr_mem[14]=8'b00000000;
  instr_mem[15]=8'b00000000;
  instr_mem[16]=8'b00000000;
  instr_mem[17]=8'b00000000;
  instr_mem[18]=8'b00000000;
  instr_mem[19]=8'b00000000;

//cmovxx
  instr_mem[20]=8'b00100000; //2 fn
  instr_mem[21]=8'b00000000; //rA rB
  instr_mem[22]=8'b00000000;
  instr_mem[23]=8'b00000000;
  instr_mem[24]=8'b00000000;
  instr_mem[25]=8'b00000000;
  instr_mem[26]=8'b00000000;
  instr_mem[27]=8'b00000000;
  instr_mem[28]=8'b00000000;
  instr_mem[29]=8'b00000000;

//irmovq
  instr_mem[30]=8'b00110000; //3 0
  instr_mem[31]=8'b00000000; //F rB
  instr_mem[32]=8'b00000000; //V
  instr_mem[33]=8'b00000000; //V
  instr_mem[34]=8'b00000000; //V
  instr_mem[35]=8'b00000000; //V
  instr_mem[36]=8'b00000000; //V
  instr_mem[37]=8'b00000000; //V
  instr_mem[38]=8'b00000000; //V
  instr_mem[39]=8'b00000000; //V

//rmmovq
  instr_mem[40]=8'b01000000; //4 0
  instr_mem[41]=8'b00000000; //rA rB
  instr_mem[42]=8'b00000000; //D
  instr_mem[43]=8'b00000000; //D
  instr_mem[44]=8'b00000000; //D
  instr_mem[45]=8'b00000000; //D
  instr_mem[46]=8'b00000000; //D
  instr_mem[47]=8'b00000000; //D
  instr_mem[48]=8'b00000000; //D
  instr_mem[49]=8'b00000000; //D

//mrmovq
  instr_mem[40]=8'b01010000; //5 0
  instr_mem[41]=8'b00000000; //rA rB
  instr_mem[42]=8'b00000000; //D
  instr_mem[43]=8'b00000000; //D
  instr_mem[44]=8'b00000000; //D
  instr_mem[45]=8'b00000000; //D
  instr_mem[46]=8'b00000000; //D
  instr_mem[47]=8'b00000000; //D
  instr_mem[48]=8'b00000000; //D
  instr_mem[49]=8'b00000000; //D
endmodule