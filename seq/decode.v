`timescale 1ns / 1ps

module decode(
  
)

  if(icode==4'b0110)
  begin
    rA=instr[8:11];
    rB=instr[12:15];
    if(ifun==4'b0000)
    begin
      
    end
    if(ifun==4'b0001)
    begin
    
    end
    if(ifun==4'b0010)
    begin
    
    end
    if(ifun==4'b0011)
    begin
    
    end
  end

endmodule