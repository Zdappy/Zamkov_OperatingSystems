	.file	"factorial.c"
	.text
	.globl	factorial
	.def	factorial;	.scl	2;	.type	32;	.endef
	.seh_proc	factorial              # Начало описания функции для SEH (обработка исключений Windows)
factorial:
	pushq	%rbp                     # Сохраняем базовый указатель стека вызывающей функции
	.seh_pushreg	%rbp
	pushq	%rbx                     # Сохраняем %rbx (регистр, который должна сохранять вызываемая функция)
	.seh_pushreg	%rbx
	subq	$40, %rsp                # Выделяем 40 байт на стеке под локальные данные и выравнивание
	.seh_stackalloc	40
	leaq	32(%rsp), %rbp           # Устанавливаем %rbp как указатель на базу текущего стекового кадра
	.seh_setframe	%rbp, 32
	.seh_endprologue               # Пролог завершён. Теперь безопасно обрабатывать исключения
	movl	%ecx, 32(%rbp)           # Сохраняем аргумент n (в Windows x64 первый int-аргумент передаётся в %ecx)
	cmpl	$1, 32(%rbp)             # Сравниваем n с 1
	jg	.L2                        # Если n > 1, переходим к рекурсивному случаю
	movl	$1, %eax                 # Базовый случай: factorial(0) = 1, factorial(1) = 1
	jmp	.L3                        # Переходим к завершению функции
.L2:
	movl	32(%rbp), %eax           # Загружаем n
	movslq	%eax, %rbx             # Расширяем n до 64 бит и сохраняем в %rbx (будет использоваться как множитель)
	movl	32(%rbp), %eax           # Снова загружаем n
	subl	$1, %eax                 # Вычисляем n - 1
	movl	%eax, %ecx               # Передаём (n-1) в %ecx для рекурсивного вызова
	call	factorial                # Рекурсивный вызов factorial(n-1)
	imulq	%rbx, %rax               # Умножаем возвращённый результат (в %rax) на сохранённое n (в %rbx)
.L3:
	addq	$40, %rsp                # Освобождаем выделенную локальную память
	popq	%rbx                     # Восстанавливаем исходное значение %rbx
	popq	%rbp                     # Восстанавливаем исходное значение %rbp
	ret                              # Возврат в вызывающую функцию (результат всегда возвращается в %rax)
	.seh_endproc                     # Конец SEH-описания функции

	.globl	factorial_iterative
	.def	factorial_iterative;	.scl	2;	.type	32;	.endef
	.seh_proc	factorial_iterative
factorial_iterative:
	pushq	%rbp
	.seh_pushreg	%rbp
	movq	%rsp, %rbp               # Настраиваем указатель кадра
	.seh_setframe	%rbp, 0
	subq	$16, %rsp                # Выделяем 16 байт под локальные переменные
	.seh_stackalloc	16
	.seh_endprologue
	movl	%ecx, 16(%rbp)           # Сохраняем аргумент n
	movq	$1, -8(%rbp)             # Инициализируем accumulator (result) = 1
	movl	$2, -12(%rbp)            # Инициализируем счётчик цикла i = 2
	jmp	.L5                        # Переходим сразу к проверке условия цикла (структура while)
.L6:                               # Тело цикла
	movl	-12(%rbp), %eax          # Загружаем i
	cltq                             # Знаковое расширение i из 32 в 64 бит (результат в %rax)
	movq	-8(%rbp), %rdx           # Загружаем текущий result
	imulq	%rdx, %rax               # result = result * i
	movq	%rax, -8(%rbp)           # Сохраняем обновлённый result обратно в память
	addl	$1, -12(%rbp)            # i++
.L5:                               # Проверка условия продолжения цикла
	movl	-12(%rbp), %eax          # Загружаем i
	cmpl	16(%rbp), %eax           # Сравниваем i с n
	jle	.L6                        # Если i <= n, повторяем цикл
	movq	-8(%rbp), %rax           # Помещаем итоговый результат в %rax для возврата
	addq	$16, %rsp                # Восстанавливаем указатель стека
	popq	%rbp                     # Восстанавливаем %rbp
	ret                              # Возврат
	.seh_endproc
