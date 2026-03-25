#include<iostream>
#include<stack>
using namespace std;

int main(){
stack<int>stk;
    stk.push(5); cout<<stk.top()<<endl;
    stk.push(4); cout<<stk.top()<<endl;
    stk.push(3); cout<<stk.top()<<endl;
    stk.push(2); cout<<stk.top()<<endl;
    stk.push(1); cout<<stk.top()<<endl;
    stk.push(0); cout<<stk.top()<<endl;

    
    return 0;
}