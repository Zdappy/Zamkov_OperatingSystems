	.file	"factorial.c"
	.text
	.p2align 4
	.globl	factorial
	.def	factorial;	.scl	2;	.type	32;	.endef
	.seh_proc	factorial
factorial:
	.seh_endprologue
	movl	$1, %edx
	movslq	%ecx, %rax
	cmpl	$1, %ecx
	jle	.L1
	testb	$1, %al
	jne	.L4
	movq	%rax, %rdx
	subq	$1, %rax
	cmpq	$1, %rax
	je	.L1
	.p2align 5
	.p2align 4
	.p2align 3
.L4:
	imulq	%rax, %rdx
	leaq	-1(%rax), %rcx
	subq	$2, %rax
	imulq	%rcx, %rdx
	cmpq	$1, %rax
	jne	.L4
.L1:
	movq	%rdx, %rax
	ret
	.seh_endproc
	.p2align 4
	.globl	factorial_iterative
	.def	factorial_iterative;	.scl	2;	.type	32;	.endef
	.seh_proc	factorial_iterative
factorial_iterative:
	.seh_endprologue
	cmpl	$1, %ecx
	jle	.L20
	leal	1(%rcx), %r8d
	movl	$2, %eax
	movl	$1, %edx
	testb	$1, %r8b
	je	.L19
	movl	$3, %eax
	movl	$2, %edx
	cmpq	%r8, %rax
	je	.L17
	.p2align 5
	.p2align 4
	.p2align 3
.L19:
	imulq	%rax, %rdx
	leaq	1(%rax), %rcx
	addq	$2, %rax
	imulq	%rcx, %rdx
	cmpq	%r8, %rax
	jne	.L19
.L17:
	movq	%rdx, %rax
	ret
	.p2align 4,,10
	.p2align 3
.L20:
	movl	$1, %edx
	movq	%rdx, %rax
	ret
	.seh_endproc
	.ident	"GCC: (Rev14, Built by MSYS2 project) 15.2.0"
