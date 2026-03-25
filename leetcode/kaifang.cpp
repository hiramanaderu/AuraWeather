#include <iostream>
using namespace std;

class Solution {
public:
    int mySqrt(int x) {
        float t =1.5F,x2,y;
        long  i;
        x2=x*0.5F;
        y=x;
        i = * ( long * )&y;
        i=0x5f3759df - (i >> 1);
        y = * (float * )&i;
        y=y*(t-(x2*y*y));
        y=y*(t-(x2*y*y));
        return y;
    }
};
int main() {
    Solution sol;
    int x;
    cout << "请输入一个整数：";
    cin >> x;
    cout << x << "的平方根整数部分是：" << sol.mySqrt(x) << endl;
    return 0;
}