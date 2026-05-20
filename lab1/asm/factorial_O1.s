	.file	"factorial.c"
	.text
	.globl	factorial
	.def	factorial;	.scl	2;	.type	32;	.endef
	.seh_proc	factorial
factorial:
	pushq	%rbx                     # Сохраняем %rbx (callee-saved регистр по Win x64 ABI)
	.seh_pushreg	%rbx
	subq	$32, %rsp                # Выделяем 32 байта (требование Windows x64: shadow space для 4 регистров-аргументов)
	.seh_stackalloc	32
	.seh_endprologue               # Пролог завершён
	movl	%ecx, %ebx               # Сохраняем аргумент n в %ebx (понадобится после рекурсивного вызова)
	movl	$1, %eax                 # Подготовка: по умолчанию результат = 1 (базовый случай)
	cmpl	$1, %ecx                 # Сравниваем n с 1
	jle	.L1                        # Если n <= 1, пропускаем рекурсию (возвращаем 1)
	leal	-1(%rcx), %ecx           # Вычисляем n-1 через LEA (быстрее, чем sub, не меняет флаги)
	call	factorial                # Рекурсивный вызов factorial(n-1)
	movq	%rax, %rdx               # Сохраняем возвращённый результат factorial(n-1) в %rdx
	movslq	%ebx, %rax               # Расширяем исходное n (%ebx) до 64 бит в %rax
	imulq	%rdx, %rax               # Умножаем: %rax = n * factorial(n-1)  (AT&T: dest = dest * src)
.L1:
	addq	$32, %rsp                # Освобождаем выделенное место на стеке
	popq	%rbx                     # Восстанавливаем %rbx
	ret                              # Возврат (результат уже в %rax)
	.seh_endproc

	.globl	factorial_iterative
	.def	factorial_iterative;	.scl	2;	.type	32;	.endef
	.seh_proc	factorial_iterative
factorial_iterative:
	.seh_endprologue               # Функция-лист: не меняет %rsp/%rbp, пролог пустой
	cmpl	$1, %ecx                 # Сравниваем n с 1
	jle	.L7                        # Если n <= 1, переходим к возврату 1
	leal	1(%rcx), %ecx            # Вычисляем n+1 и сохраняем в %ecx (будет верхней границей цикла)
	movl	$2, %eax                 # Счётчик цикла i = 2
	movl	$1, %edx                 # Аккумулятор result = 1
	.p2align 4                     # Выравнивание цикла по 16 байт (оптимизация предвыборки/кэша CPU)
.L6:
	imulq	%rax, %rdx               # result *= i  (%rdx = %rdx * %rax)
	addq	$1, %rax                 # i++
	cmpq	%rcx, %rax               # Сравниваем текущий i с (n+1)
	jne	.L6                        # Если i != n+1, продолжаем цикл (эквивалент i <= n)
.L4:
	movq	%rdx, %rax               # Копируем итоговый result в %rax для возврата
	ret                              # Возврат
.L7:
	movl	$1, %edx                 # Базовый случай: result = 1
	jmp	.L4                        # Переход к возврату результата
	.seh_endproc
