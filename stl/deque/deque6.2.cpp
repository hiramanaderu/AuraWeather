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
    //1
    deque<int>d1;
    printDeque(d1);
    //2
    deque<int>d2_1({9,8,8,6,5,});
    cout<<"d2_1:";
    printDeque(d2_1);
    deque<int>d2_2{2,8,8,6,1,};
    cout<<"d2_2:";
    printDeque(d2_2);
    //3
    deque<int>d3(d2_1.begin()+1,d2_1.end()-1);
    cout<<"d3:";
    printDeque(d3);
    //4
    deque<int>d4(10);
    cout<<"d4:";
    printDeque(d4);
    //5
    deque<int>d5(8,6);
    cout<<"d5:";
    printDeque(d5);
    //6
    deque<int>d6(d5);
    cout<<"d6:";
    printDeque(d6);
return 0;
}