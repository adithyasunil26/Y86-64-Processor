//rax=0
//rcx=1
//rdx=2
//rbx=3
//rsi=6
//rdi=7

main:
  irmovq $0x0, %rax
  irmovq $0x10, %rdx
  irmovq $0xc, %rbx
  jmp check
  
check:
  addq %rax, %rbx 
  je rbxres  
  addq %rax, %rdx
  je rdxres 
  jmp loop2 

loop2:
  rrmovq %rdx, %rsi 
  rrmovq %rbx, %rdi
  
  subq %rbx, %rsi
  jge ab1  
  subq %rdx, %rdi 
  jge ab2

ab1:
  rrmovq %rbx, %rdx
  rrmovq %rsi, %rbx
  jmp check

ab2:
  rrmovq %rbx, %rdx
  rrmovq %rdi, %rbx
  jmp check

rbxres:
  rrmovq %rdx, %rcx
  halt

rdxres:
  rrmovq %rbx, %rcx
  halt
