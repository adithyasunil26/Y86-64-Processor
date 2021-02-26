module fetch(
  clk, pc, mem,
  icode, ifun, rA, rB, valC, valp,
);

  input reg clk;
  input reg [63:0] pc;
  input reg [7:0] mem [0:1024];

  output reg [3:0] icode;
  output reg [3:0] ifun;
  output reg [3:0] rA;
  output reg [3:0] rB;
  output reg [3:0] valC;
  output reg [3:0] valP;

  reg [63:0] handled;

  always @ (posedge clk) begin
    handled<= 0;
    if(handled<size) begin
      case(handled)
        0:begin
          read<=1;
          address <=pc/2;
          size<= (icode == 0 || icode == 1 || icode == 9) ? 1 :
                    ((icode == 2 || icode == 6 || icode == 'hA || icode == 'hB) ? 2 :
                    ((icode ==  7 || icode == 8) ? 9 : 10));
        end
        1:begin

        end  
      endcase
    end
    valP <= pc;
  end

endmodule