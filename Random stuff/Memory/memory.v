module memory_model ()
  reg [7:0] mem [0:1024];
  initial begin
    mem[0]=8'b01001101;
    mem[4]=8'b00000000;
  end 
endmodule