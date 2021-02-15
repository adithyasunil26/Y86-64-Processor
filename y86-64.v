`include "Fetch/fetch.v"
`include "Decode/decode.v"
`include "Execute/execute.v"
`include "Memory/memory.v"
`include "Write_back/write_back.v"

module y86();

  wire [63:0] pc;

  wire [3:0] fetch_icode; 
	wire [3:0] fetch_ifun; 
	wire [3:0] fetch_rA; 
	wire [3:0] fetch_rB;
	wire [31:0] fetch_valC; 
	wire [31:0] fetch_valP; 

  wire [3:0] decode_icode; 
	wire [3:0] decode_ifun; 
	wire [3:0] decode_rA; 
	wire [3:0] decode_rB; 
	wire [31:0] decode_valA; 
	wire [31:0] decode_valB; 
	wire [63:0] decode_valC; 
	wire [63:0] decode_valP; 


//instantiating each module
  fetch f();
  decode d();
  execute e();
  memory m();
  write_back wb();
  


endmodule