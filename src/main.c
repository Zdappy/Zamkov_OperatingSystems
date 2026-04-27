#include <stdio.h>
#include "factorial.h"

int main() {
    int numbers[] = {5, 7, 10};
    int count = sizeof(numbers) / sizeof(numbers[0]);
    
    printf("=== Вычисление факториала ===\n\n");
    
    // Рекурсивная версия
    printf("Рекурсивная версия:\n");
    for (int i = 0; i < count; i++) {
        int n = numbers[i];
        unsigned long long result = factorial(n);
        printf("Factorial(%d) = %llu\n", n, result);
    }
    
    printf("\n");
    
    // Итеративная версия
    printf("Итеративная версия:\n");
    for (int i = 0; i < count; i++) {
        int n = numbers[i];
        unsigned long long result = factorial_iterative(n);
        printf("Factorial(%d) = %llu\n", n, result);
    }
    
    printf("\n");
    
    return 0;
}
