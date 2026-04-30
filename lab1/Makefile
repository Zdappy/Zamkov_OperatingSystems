# Компилятор и флаги
CC = gcc
CFLAGS = -Wall -Wextra -I./include
LDFLAGS = 

# Папки
SRC_DIR = src
ASM_DIR = asm
OBJ_DIR = obj
BIN_DIR = bin

# Файлы
SOURCES = $(SRC_DIR)/main.c $(SRC_DIR)/factorial.c
OBJECTS = $(OBJ_DIR)/main.o $(OBJ_DIR)/factorial.o
TARGET = $(BIN_DIR)/factorial
PARALLEL_TARGET = $(BIN_DIR)/parallel

# Цели по умолчанию
all: directories $(TARGET)

# Создание папок
directories:
	@mkdir -p $(OBJ_DIR) $(BIN_DIR) $(ASM_DIR)

# Компиляция в исполняемый файл
$(TARGET): $(OBJECTS)
	$(CC) $(CFLAGS) $(OBJECTS) -o $(TARGET) $(LDFLAGS)

# Компиляция объектных файлов
$(OBJ_DIR)/main.o: $(SRC_DIR)/main.c include/factorial.h
	$(CC) $(CFLAGS) -c $(SRC_DIR)/main.c -o $(OBJ_DIR)/main.o

$(OBJ_DIR)/factorial.o: $(SRC_DIR)/factorial.c include/factorial.h
	$(CC) $(CFLAGS) -c $(SRC_DIR)/factorial.c -o $(OBJ_DIR)/factorial.o

# Генерация ассемблерных файлов с разными оптимизациями
asm: directories
	@echo "Генерация ассемблерных файлов..."
	$(CC) -S -O0 $(CFLAGS) -o $(ASM_DIR)/factorial_O0.s $(SRC_DIR)/factorial.c
	$(CC) -S -O1 $(CFLAGS) -o $(ASM_DIR)/factorial_O1.s $(SRC_DIR)/factorial.c
	$(CC) -S -O2 $(CFLAGS) -o $(ASM_DIR)/factorial_O2.s $(SRC_DIR)/factorial.c
	$(CC) -S -O3 $(CFLAGS) -o $(ASM_DIR)/factorial_O3.s $(SRC_DIR)/factorial.c
	@echo "Ассемблерные файлы сгенерированы в папке $(ASM_DIR)"

# Параллельная версия
parallel: directories
	$(CC) $(CFLAGS) $(SRC_DIR)/parallel.c $(SRC_DIR)/factorial.c \
	-o $(PARALLEL_TARGET) $(LDFLAGS)
	@echo "Параллельная версия собрана: $(PARALLEL_TARGET)"

# Запуск основной программы
run: $(TARGET)
	./$(TARGET)

# Запуск параллельной версии
run-parallel: parallel
	./$(PARALLEL_TARGET)

# Очистка
clean:
	rm -rf $(OBJ_DIR) $(BIN_DIR)

# Удаление ассемблерных файлов
clean-asm:
	rm -f $(ASM_DIR)/*.s

# Полная очистка
distclean: clean clean-asm
	rm -rf output

# Пересборка
rebuild: clean all

# Информация
info:
	@echo "Компилятор: $(CC)"
	@echo "Флаги: $(CFLAGS)"
	@echo "Цель: $(TARGET)"

# Помощь
help:
	@echo "Доступные цели:"
	@echo "  all          - Сборка проекта (по умолчанию)"
	@echo "  asm          - Генерация ассемблерных файлов"
	@echo "  run          - Запуск основной программы"
	@echo "  parallel     - Сборка параллельной версии"
	@echo "  run-parallel - Запуск параллельной версии"
	@echo "  clean        - Очистка скомпилированных файлов"
	@echo "  rebuild      - Пересборка проекта"
	@echo "  help         - Показать эту справку"

.PHONY: all directories asm parallel run run-parallel clean clean-asm distclean rebuild info help