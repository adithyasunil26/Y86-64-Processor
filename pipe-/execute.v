`timescale 1ns / 1ps

`include "./ALU/alu.v"

module execute(
  clk,icode,ifun,valA,valB,valC,
  valE,cnd,zf,sf,of
);

  input clk;
  input [3:0] icode;
  input [3:0] ifun;
  input [63:0] valA;
  input [63:0] valB;
  input [63:0] valC;

  output reg [63:0] valE; 
  output reg cnd;

  output reg zf;
  output reg sf;
  output reg of;

  always@(*)
  begin
    if(icode==4'b0110 && clk==1)
    begin
      zf=(ans==1'b0);
      sf=(ans<1'b0);
      of=(a<1'b0==b<1'b0)&&(ans<1'b0!=a<1'b0);
    end
  end

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


  reg xin1;
  reg xin2;
  reg oin1;
  reg oin2;
  reg ain1;
  reg ain2;
  reg nin1;
  wire xout;
  wire oout;
  wire aout;
  wire nout;

  xor g1(xout,xin1,xin2);
  or g2(oout,oin1,oin2);
  and g3(aout,ain1,ain2);
  not g4(nout,nin1);

  initial
  begin
    control=2'b00;
		a = 64'b0;
		b = 64'b0;
  end
  
  always@(*)
  begin
    if(clk==1)
    begin
      if(icode==4'b0010) //cmovxx
      begin
        if(ifun==4'b0000)//rrmovq
        begin
          cnd=1;
        end
        else if(ifun==4'b0001)//cmovle
        begin
        // (sf^of)||zf
          xin1=sf;
          xin2=of;
          if(xout)
          begin
            cnd=1;
          end
          else if(zf)
          begin
            cnd=1;
          end
        end
        else if(ifun==4'b0010)//cmovl
        begin
        // sf^of
          xin1=sf;
          xin2=of;
          if(xout)
          begin
            cnd=1;
          end
        end
        else if(ifun==4'b0011)//cmove
        begin
        // zf
          if(zf)
          begin
            cnd=1;
          end
        end
        else if(ifun==4'b0100)//cmovne
        begin
        // !zf
          nin1=zf;
          if(nout)
          begin
            cnd=1;
          end
        end
        else if(ifun==4'b0101)//cmovge
        begin
        // !(sf^of)
          xin1=sf;
          xin2=of;
          nin1=xout;
          if(nout)
          begin
            cnd=1;
          end
        end
        else if(ifun==4'b0110)//cmovg
        begin
        //!(sf^of)) && (!zf)
          xin1=sf;
          xin2=of;
          nin1=xout;
          if(nout)
          begin
            nin1=zf;
            if(nout)
            begin
              cnd=1;
            end
          end
        end
        valE=64'd0+valA;
      end
      else if(icode==4'b0011) //irmovq
      begin
        valE=64'd0+valC;
      end
      else if(icode==4'b0100) //rmmovq
      begin
        valE=valB+valC;
      end
      else if(icode==4'b0101) //mrmovq
      begin
        valE=valB+valC;
      end
      else if(icode==4'b0110) //OPq
      begin
        if(ifun==4'b0000) //add
        begin
          //valE=valA+valB;
          control=2'b00;
          a = valA;
          b = valB;
        end
        else if(ifun==4'b0001) //sub
        begin
          //valE=valA-valB;
          control=2'b01;
          a = valA;
          b = valB;
        end
        else if(ifun==4'b0010) //and
        begin
          //valE=valA.valB;
          control=2'b10;
          a = valA;
          b = valB;
        end
        else if(ifun==4'b0011) //xor
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
        if(ifun==4'b0000)//jmp
        begin
          cnd=1;
        end
        else if(ifun==4'b0001)//jle
        begin
        // (sf^of)||zf
          xin1=sf;
          xin2=of;
          if(xout)
          begin
            cnd=1;
          end
          else if(zf)
          begin
            cnd=1;
          end
        end
        else if(ifun==4'b0010)//jl
        begin
        // sf^of
          xin1=sf;
          xin2=of;
          if(xout)
          begin
            cnd=1;
          end
        end
        else if(ifun==4'b0011)//je
        begin
        // zf
          if(zf)
          begin
            cnd=1;
          end
        end
        else if(ifun==4'b0100)//jne
        begin
        // !zf
          nin1=zf;
          if(nout)
          begin
            cnd=1;
          end
        end
        else if(ifun==4'b0101)//jge
        begin
        // !(sf^of)
          xin1=sf;
          xin2=of;
          nin1=xout;
          if(nout)
          begin
            cnd=1;
          end
        end
        else if(ifun==4'b0110)//jg
        begin
        //!(sf^of)) && (!zf)
          xin1=sf;
          xin2=of;
          nin1=xout;
          if(nout)
          begin
            nin1=zf;
            if(nout)
            begin
              cnd=1;
            end
          end
        end  
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
  end

endmodule
