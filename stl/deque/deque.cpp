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



    return 0;
}