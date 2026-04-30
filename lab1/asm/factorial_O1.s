	.file	"factorial.c"
	.text
	.globl	factorial
	.def	factorial;	.scl	2;	.type	32;	.endef
	.seh_proc	factorial
factorial:
	pushq	%rbx
	.seh_pushreg	%rbx
	subq	$32, %rsp
	.seh_stackalloc	32
	.seh_endprologue
	movl	%ecx, %ebx
	movl	$1, %eax
	cmpl	$1, %ecx
	jle	.L1
	leal	-1(%rcx), %ecx
	call	factorial
	movq	%rax, %rdx
	movslq	%ebx, %rax
	imulq	%rdx, %rax
.L1:
	addq	$32, %rsp
	popq	%rbx
	ret
	.seh_endproc
	.globl	factorial_iterative
	.def	factorial_iterative;	.scl	2;	.type	32;	.endef
	.seh_proc	factorial_iterative
factorial_iterative:
	.seh_endprologue
	cmpl	$1, %ecx
	jle	.L7
	leal	1(%rcx), %ecx
	movl	$2, %eax
	movl	$1, %edx
	.p2align 4
.L6:
	imulq	%rax, %rdx
	addq	$1, %rax
	cmpq	%rcx, %rax
	jne	.L6
.L4:
	movq	%rdx, %rax
	ret
.L7:
	movl	$1, %edx
	jmp	.L4
	.seh_endproc
	.ident	"GCC: (Rev14, Built by MSYS2 project) 15.2.0"
