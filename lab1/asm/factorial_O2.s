	.file	"factorial.c"
	.text
	.p2align 4                       # Выравнивание функции по границе 16 байт
	.globl	factorial
	.def	factorial;	.scl	2;	.type	32;	.endef
	.seh_proc	factorial
factorial:
	.seh_endprologue               # Пролог пуст: функция не сохраняет %rbp/%rsp
	movl	$1, %edx               # %rdx = 1 (аккумулятор результата)
	movslq	%ecx, %rax             # %rax = n (знаковое расширение до 64 бит)
	cmpl	$1, %ecx               # Сравниваем n с 1
	jle	.L1                      # Если n <= 1, пропускаем цикл (результат уже 1)
	testb	$1, %al                # Проверяем младший бит n (определяем чётность)
	jne	.L4                      # Если n нечётное, сразу переходим к циклу
	# === Обработка чётного n ===
	movq	%rax, %rdx             # %rdx = n  (начинаем результат с самого n)
	subq	$1, %rax               # %rax = n - 1 (следующий множитель)
	cmpq	$1, %rax               # Проверяем, не стало ли n-1 == 1
	je	.L1                      # Если да, цикл не нужен, выходим
	.p2align 5
	.p2align 4
	.p2align 3                   # Выравнивание метки цикла (кэшевая оптимизация)
.L4:                               # === Оптимизированный цикл (раскрутка на 2) ===
	imulq	%rax, %rdx             # %rdx *= %rax   (result *= текущее n)
	leaq	-1(%rax), %rcx         # %rcx = n - 1
	subq	$2, %rax               # %rax = n - 2   (шаг цикла -2)
	imulq	%rcx, %rdx             # %rdx *= %rcx  (result *= (n-1))
	cmpq	$1, %rax               # Сравниваем новое n с 1
	jne	.L4                      # Если n > 1, повторяем
.L1:
	movq	%rdx, %rax             # Возвращаем итоговый результат в %rax
	ret                            # Возврат
	.seh_endproc

	.p2align 4
	.globl	factorial_iterative
	.def	factorial_iterative;	.scl	2;	.type	32;	.endef
	.seh_proc	factorial_iterative
factorial_iterative:
	.seh_endprologue
	cmpl	$1, %ecx               # Сравниваем n с 1
	jle	.L20                     # Если n <= 1, переходим к возврату 1
	leal	1(%rcx), %r8d          # %r8d = n + 1 (верхняя граница цикла)
	movl	$2, %eax               # %rax = 2 (счётчик i)
	movl	$1, %edx               # %rdx = 1 (результат)
	testb	$1, %r8b               # Проверяем чётность (n+1)
	je	.L19                     # Если (n+1) чётное (т.е. n нечётное), прыгаем в цикл
	# === Обработка нечётного (n+1) => чётного n ===
	movl	$3, %eax               # i = 3
	movl	$2, %edx               # result = 2
	cmpq	%r8, %rax              # Сравниваем i с n+1
	je	.L17                     # Если i == n+1, цикл завершён сразу
	.p2align 5
	.p2align 4
	.p2align 3
.L19:                              # === Тело цикла с раскруткой на 2 ===
	imulq	%rax, %rdx             # result *= i
	leaq	1(%rax), %rcx          # %rcx = i + 1
	addq	$2, %rax               # i += 2
	imulq	%rcx, %rdx             # result *= (i+1)
	cmpq	%r8, %rax              # Сравниваем i с n+1
	jne	.L19                     # Если i != n+1, продолжаем
.L17:
	movq	%rdx, %rax             # Результат в %rax для возврата
	ret                            # Возврат
	.p2align 4,,10
	.p2align 3
.L20:
	movl	$1, %edx               # result = 1
	movq	%rdx, %rax
	ret
	.seh_endproc
