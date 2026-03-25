#include<iostream>
#include<queue>
using namespace std;

int main(){
    queue<int>q;
    for (int i =0;i<5;i++){
        q.push(i);
    }
    for (int i =0;i<5;i++){
        cout<<"front = "<<q.front()<<", back = "<<q.back()<<endl;
        q.pop();
    }
    
    return 0;
}