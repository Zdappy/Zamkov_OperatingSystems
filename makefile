CC = gcc
CFLAGS = -Wall -Wextra -I./include
TARGET = output/factorial

all: directories $(TARGET) asm

directories:
	@mkdir -p output asm

$(TARGET): src/main.c src/factorial.c include/factorial.h
	$(CC) $(CFLAGS) src/main.c src/factorial.c -o $(TARGET)

asm: directories
	$(CC) -S -O0 $(CFLAGS) -o asm/factorial_O0.s src/factorial.c
	$(CC) -S -O1 $(CFLAGS) -o asm/factorial_O1.s src/factorial.c
	$(CC) -S -O2 $(CFLAGS) -o asm/factorial_O2.s src/factorial.c
	$(CC) -S -O3 $(CFLAGS) -o asm/factorial_O3.s src/factorial.c

run: $(TARGET)
	./$(TARGET)

clean:
	rm -rf output asm

.PHONY: all directories asm run clean
