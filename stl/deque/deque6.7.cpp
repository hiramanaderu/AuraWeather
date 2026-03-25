#include <iostream>
#include <deque>
using namespace std;

void printDeque(deque<int>&d){
    for(deque<int>::iterator iter = d.begin();iter != d.end();iter++){
        cout << *iter <<" ";
    }
    cout<<endl;
}

int main(){
    deque<long long>d;
    for (int i = 0 ;i<9,++i){
        d.push_back();
    }
    for (int i = 9 ;i<18,++i){
        d.push_front();
    }


    return 0;
}