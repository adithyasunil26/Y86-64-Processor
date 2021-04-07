# Y86-64

A Y86-64 processor implemented using Verilog that is capable of running Y86-64 instructions.

This repository contains both a sequential model as well as a 5 stage pipelined model.

## Features:
- Procesor frequency of 1GHz
- Harvard style memeory design with seperate data and instruction memeory.
  - Data memory of 1kB
  - Instruction memory of 1kB 


## Instructions:
```
halt 
nop
rrmovq
vmovle
cmovl
cmove
cmovne
cmovge
cmovg
irmovq
rmmovq
mrmovq
addq
subq
andq
xorq
jmp
jle
jl
je
jne
jge
jg
call 
ret
pushq
popq
```

Please refer to the [project report](https://github.com/adithyasunil26/Y86-64-Processor/blob/main/Project_Report.pdf) for more details.

The contents of this repository are as follows
```bash
.
├── ALU
│   ├── ALU
│   │   ├── Alu_test.vcd
│   │   ├── alu
│   │   ├── alu.v
│   │   └── alu_test.v
│   ├── Add
│   │   ├── add
│   │   ├── add1x1.v
│   │   ├── add1x1_test.v
│   │   ├── add32x1.v
│   │   ├── add_test.v
│   │   └── add_test.vcd
│   ├── And
│   │   ├── And_test.vcd
│   │   ├── and
│   │   ├── and1x1.v
│   │   ├── and32x1.v
│   │   └── and_test.v
│   ├── README.md
│   ├── RUN_INSTRUCTIONS.md
│   ├── Report.pdf
│   ├── Sub
│   │   ├── not
│   │   │   ├── not
│   │   │   ├── not1x1.v
│   │   │   ├── not32x1.v
│   │   │   ├── not_test.v
│   │   │   └── not_test.vcd
│   │   ├── sub
│   │   ├── sub32x1.v
│   │   ├── sub_test.v
│   │   └── sub_test.vcd
│   └── Xor
│       ├── Xor_test.vcd
│       ├── xor
│       ├── xor1x1.v
│       ├── xor32x1.v
│       └── xor_test.v
├── LICENSE
├── Project_Report.pdf
├── README.md
├── pipe
│   ├── ALU
│   │   ├── Add
│   │   │   ├── add1x1.v
│   │   │   ├── add1x1_test.v
│   │   │   ├── add64x1.v
│   │   │   └── add_test.v
│   │   ├── And
│   │   │   ├── and1x1.v
│   │   │   ├── and64x1.v
│   │   │   └── and_test.v
│   │   ├── Sub
│   │   │   ├── not
│   │   │   │   ├── not1x1.v
│   │   │   │   ├── not64x1.v
│   │   │   │   └── not_test.v
│   │   │   ├── sub64x1.v
│   │   │   └── sub_test.v
│   │   ├── Xor
│   │   │   ├── xor1x1.v
│   │   │   ├── xor64x1.v
│   │   │   └── xor_test.v
│   │   ├── alu.v
│   │   └── alu_test.v
│   ├── d_reg.v
│   ├── decode_wb.v
│   ├── e_reg.v
│   ├── execute.v
│   ├── f_reg.v
│   ├── fetch.v
│   ├── m_reg.v
│   ├── memory.v
│   ├── pc_update.v
│   ├── proc.v
│   └── w_reg.v
├── seq
│   ├── ALU
│   │   ├── Add
│   │   │   ├── add1x1.v
│   │   │   ├── add1x1_test.v
│   │   │   ├── add64x1.v
│   │   │   └── add_test.v
│   │   ├── And
│   │   │   ├── and1x1.v
│   │   │   ├── and64x1.v
│   │   │   └── and_test.v
│   │   ├── Sub
│   │   │   ├── not
│   │   │   │   ├── not1x1.v
│   │   │   │   ├── not64x1.v
│   │   │   │   └── not_test.v
│   │   │   ├── sub64x1.v
│   │   │   └── sub_test.v
│   │   ├── Xor
│   │   │   ├── xor1x1.v
│   │   │   ├── xor64x1.v
│   │   │   └── xor_test.v
│   │   ├── alu.v
│   │   └── alu_test.v
│   ├── decode_wb\ before\ combining(old\ version\ only\ used\ for\ testing)
│   │   ├── decode.v
│   │   ├── decode_tb.v
│   │   └── write_back.v
│   ├── decode_wb.v
│   ├── execute.v
│   ├── execute_tb.v
│   ├── fetch.v
│   ├── fetch_tb.v
│   ├── memory.v
│   ├── pc_update.v
│   └── proc.v
└── testing
    ├── gcd.s
    └── gcdbin.v
```