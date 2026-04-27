#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <fcntl.h>
#include "factorial.h"

// Вычисление факториала с использованием fork и pipe
void factorial_with_pipe(int n) {
    int pipefd[2];
    pid_t pid;
    
    if (pipe(pipefd) == -1) {
        perror("pipe");
        exit(1);
    }
    
    pid = fork();
    
    if (pid == -1) {
        perror("fork");
        exit(1);
    }
    
    if (pid == 0) {
        // Дочерний процесс
        close(pipefd[0]);  // Закрываем чтение
        
        unsigned long long result = factorial(n);
        
        // Отправляем результат через pipe
        write(pipefd[1], &result, sizeof(result));
        close(pipefd[1]);
        
        printf("[Child %d] Вычислен factorial(%d) = %llu\n", 
               getpid(), n, result);
        exit(0);
    } else {
        // Родительский процесс
        close(pipefd[1]);  // Закрываем запись
        
        unsigned long long result;
        read(pipefd[0], &result, sizeof(result));
        close(pipefd[0]);
        
        wait(NULL);  // Ждем завершения дочернего процесса
        
        printf("[Parent %d] Получен результат: %llu\n", 
               getpid(), result);
    }
}

// Вычисление с использованием разделяемой памяти
void factorial_with_shm(int n) {
    key_t key = ftok("/tmp", 'A');
    int shmid;
    unsigned long long *shm_ptr;
    pid_t pid;
    
    // Создаем разделяемую память
    shmid = shmget(key, sizeof(unsigned long long), IPC_CREAT | 0666);
    if (shmid == -1) {
        perror("shmget");
        exit(1);
    }
    
    // Присоединяем разделяемую память
    shm_ptr = (unsigned long long *)shmat(shmid, NULL, 0);
    if (shm_ptr == (unsigned long long *)-1) {
        perror("shmat");
        exit(1);
    }
    
    pid = fork();
    
    if (pid == -1) {
        perror("fork");
        exit(1);
    }
    
    if (pid == 0) {
        // Дочерний процесс
        *shm_ptr = factorial(n);
        printf("[Child %d] Записал в shared memory: %llu\n", 
               getpid(), *shm_ptr);
        shmdt(shm_ptr);
        exit(0);
    } else {
        // Родительский процесс
        wait(NULL);
        printf("[Parent %d] Прочитал из shared memory: %llu\n", 
               getpid(), *shm_ptr);
        
        // Освобождаем ресурсы
        shmdt(shm_ptr);
        shmctl(shmid, IPC_RMID, NULL);
    }
}

int main() {
    int numbers[] = {5, 8, 10};
    int count = sizeof(numbers) / sizeof(numbers[0]);
    
    printf("1. Использование pipe:\n");
    for (int i = 0; i < count; i++) {
        factorial_with_pipe(numbers[i]);
        printf("\n");
    }
    
    printf("\n2. Использование разделяемой памяти:\n");
    for (int i = 0; i < count; i++) {
        factorial_with_shm(numbers[i]);
        printf("\n");
    }
    
    return 0;
}
