# RUN INSTRUCTIONS

## MODULES

### XOR
```bash
cd Xor
iverilog -o xor xor_test.v xor1x1.v xor32x1.v
vvp xor
```

### AND
```bash
cd And
iverilog -o and and_test.v and1x1.v and32x1.v
vvp and
```

### ADD
```bash
cd Add
iverilog -o add add_test.v add1x1.v add32x1.v
vvp add
```

### SUB
```bash
cd Sub
iverilog -o sub sub_test.v ../Add/add1x1.v ../Add/add32x1.v sub32x1.v not/not1x1.v not/not32x1.v
vvp sub 
```

## ALU
```bash
cd ALU
iverilog -o alu alu_test.v alu.v
vvp alu
```