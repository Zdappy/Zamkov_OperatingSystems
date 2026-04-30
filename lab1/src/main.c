#include <stdio.h>
#include "factorial.h"

int main() {
    int numbers[] = {5, 7, 10};
    int count = sizeof(numbers) / sizeof(numbers[0]);
    
    printf("=== Вычисление факториала ===\n\n");
    printf("Рекурсивная версия:\n");
    
    for (int i = 0; i < count; i++) {
        int n = numbers[i];
        unsigned long long result = factorial(n);
        printf("Factorial(%d) = %llu\n", n, result);
    }
    
    printf("\nИтеративная версия:\n");
    
    for (int i = 0; i < count; i++) {
        int n = numbers[i];
        unsigned long long result = factorial_iterative(n);
        printf("Factorial(%d) = %llu\n", n, result);
    }
    
    return 0;
}
