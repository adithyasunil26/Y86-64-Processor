`include "Fetch/fetch.v"
`include "Decode/decode.v"
`include "Execute/execute.v"
`include "Memory/memory.v"
`include "Write_back/write_back.v"

module y86();
  fetch f();
  decode d();
  execute e();
  memory m();
  write_back wb();
endmodule