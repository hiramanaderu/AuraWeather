#include<iostream>
#include<queue>
using namespace std;

int main(){
    queue<int>q;

    for(int i =0 ;i<5;i++){
        q.push(i);
        cout<<"push "<<i<<", back = "<<q.back()<<endl;
    }
    
    return 0;
}