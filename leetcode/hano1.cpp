#include <stdio.h>

// 汉诺塔递归函数：将n个盘子从F柱经A柱移到T柱
void hanoi(int n, char F, char A, char T) {
    if (n == 1) {
        // 只有1个盘子时，直接从F移到T
        printf("将第%d个盘子从%c移到%c\n", n, F, T);
        return;
    }
    // 步骤1：将n-1个盘子从F经T移到A
    hanoi(n - 1, F, T, A);
    // 步骤2：将第n个盘子从F移到T
    printf("将第%d个盘子从%c移到%c\n", n, F, T);
    // 步骤3：将n-1个盘子从A经F移到T
    hanoi(n - 1, A, F, T);
}

int main() {
    int n = 3;  // 3个盘子为例
    hanoi(n, 'A', 'B', 'C');  // 从A柱经B柱移到C柱
    return 0;
}