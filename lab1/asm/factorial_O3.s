	.file	"factorial.c"
	.text
	.p2align 4                       # Выравнивание начала функции по 16 байт (кэш/предвыборка)
	.globl	factorial
	.def	factorial;	.scl	2;	.type	32;	.endef
	.seh_proc	factorial
factorial:
	.seh_endprologue               # Листовая функция: пролог пустой, %rbp/%rsp не меняются
	movl	$1, %edx               # %rdx = 1 (аккумулятор результата)
	movslq	%ecx, %rax             # %rax = n (аргумент из %ecx, расширенный до 64 бит)
	cmpl	$1, %ecx               # if (n <= 1)
	jle	.L1                      #   goto return 1
	testb	$1, %al                # Проверяем чётность n (младший бит)
	jne	.L4                      # Если n нечётное → сразу в цикл
	# === Препроцесс для чётного n ===
	movq	%rax, %rdx             # %rdx = n  (стартуем аккумулятор с n)
	subq	$1, %rax               # %rax = n-1 (следующий множитель)
	cmpq	$1, %rax               # if (n-1 == 1)
	je	.L1                      #   goto return 1 (цикл не нужен)
	.p2align 5
	.p2align 4
	.p2align 3                   # Агрессивное выравнивание тела цикла под микроархитектуру CPU
.L4:                               # === Цикл с раскруткой на 2 итерации ===
	imulq	%rax, %rdx             # result *= n
	leaq	-1(%rax), %rcx         # temp = n-1
	subq	$2, %rax               # n -= 2
	imulq	%rcx, %rdx             # result *= temp  (итого: result *= n*(n-1))
	cmpq	$1, %rax               # if (n > 1)
	jne	.L4                      #   repeat
.L1:
	movq	%rdx, %rax             # Возврат результата в %rax
	ret
	.seh_endproc

	.p2align 4
	.globl	factorial_iterative
	.def	factorial_iterative;	.scl	2;	.type	32;	.endef
	.seh_proc	factorial_iterative
factorial_iterative:
	.seh_endprologue
	cmpl	$1, %ecx               # if (n <= 1)
	jle	.L20                     #   return 1
	leal	1(%rcx), %r8d          # limit = n + 1
	movl	$2, %eax               # i = 2
	movl	$1, %edx               # result = 1
	testb	$1, %r8b               # Проверяем чётность (n+1)
	je	.L19                     # Если (n+1) чётное (т.е. n нечётное) → в цикл
	# === Препроцесс для чётного n ===
	movl	$3, %eax               # i = 3
	movl	$2, %edx               # result = 2
	cmpq	%r8, %rax              # if (i == limit)
	je	.L17                     #   goto return (цикл уже выполнен)
	.p2align 5
	.p2align 4
	.p2align 3
.L19:                              # === Цикл с раскруткой на 2 (счётчик растёт) ===
	imulq	%rax, %rdx             # result *= i
	leaq	1(%rax), %rcx          # temp = i+1
	addq	$2, %rax               # i += 2
	imulq	%rcx, %rdx             # result *= temp  (итого: result *= i*(i+1))
	cmpq	%r8, %rax              # if (i != limit)
	jne	.L19                     #   repeat
.L17:
	movq	%rdx, %rax             # Возврат
	ret
	.p2align 4,,10
	.p2align 3
.L20:
	movl	$1, %edx               # result = 1
	movq	%rdx, %rax
	ret
	.seh_endproc
