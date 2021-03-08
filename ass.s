	.section	__TEXT,__text,regular,pure_instructions
	.build_version macos, 11, 0	sdk_version 11, 1
	.globl	_gcd                    ## -- Begin function gcd
	.p2align	4, 0x90


_gcd:                                   ## @gcd
	.cfi_startproc
	
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$16, %rsp
	movl	%edi, -8(%rbp)
	movl	%esi, -12(%rbp)
	cmpl	$0, -8(%rbp)
	jne	LBB0_2
## %bb.1:
	movl	-12(%rbp), %eax
	movl	%eax, -4(%rbp)
	jmp	LBB0_9
LBB0_2:
	cmpl	$0, -12(%rbp)
	jne	LBB0_4
## %bb.3:
	movl	-8(%rbp), %eax
	movl	%eax, -4(%rbp)
	jmp	LBB0_9
LBB0_4:
	movl	-8(%rbp), %eax
	cmpl	-12(%rbp), %eax
	jne	LBB0_6
## %bb.5:
	movl	-8(%rbp), %eax
	movl	%eax, -4(%rbp)
	jmp	LBB0_9
LBB0_6:
	movl	-8(%rbp), %eax
	cmpl	-12(%rbp), %eax
	jle	LBB0_8
## %bb.7:
	movl	-8(%rbp), %eax
	subl	-12(%rbp), %eax
	movl	-12(%rbp), %esi
	movl	%eax, %edi
	callq	_gcd
	movl	%eax, -4(%rbp)
	jmp	LBB0_9
LBB0_8:
	movl	-8(%rbp), %edi
	movl	-12(%rbp), %eax
	subl	-8(%rbp), %eax
	movl	%eax, %esi
	callq	_gcd
	movl	%eax, -4(%rbp)
LBB0_9:
	movl	-4(%rbp), %eax
	addq	$16, %rsp
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.globl	_main                   ## -- Begin function main
	.p2align	4, 0x90

_main:                                  ## @main
	.cfi_startproc
## %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	subq	$32, %rsp
	movl	$0, -4(%rbp)
	movl	$98, -8(%rbp)
	movl	$56, -12(%rbp)
	movl	-8(%rbp), %esi
	movl	-12(%rbp), %edx
	movl	-8(%rbp), %edi
	movl	-12(%rbp), %eax
	movl	%esi, -16(%rbp)         ## 4-byte Spill
	movl	%eax, %esi
	movl	%edx, -20(%rbp)         ## 4-byte Spill
	callq	_gcd
	leaq	L_.str(%rip), %rdi
	movl	-16(%rbp), %esi         ## 4-byte Reload
	movl	-20(%rbp), %edx         ## 4-byte Reload
	movl	%eax, %ecx
	movb	$0, %al
	callq	_printf
	xorl	%ecx, %ecx
	movl	%eax, -24(%rbp)         ## 4-byte Spill
	movl	%ecx, %eax
	addq	$32, %rsp
	popq	%rbp
	retq
	.cfi_endproc
                                        ## -- End function
	.section	__TEXT,__cstring,cstring_literals
L_.str:                                 ## @.str
	.asciz	"GCD of %d and %d is %d "

.subsections_via_symbols
