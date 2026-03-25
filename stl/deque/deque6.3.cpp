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
    deque<int> d ={9,8,5,2,1,1};
    cout<<"d:";
    printDeque(d);

    //1
    deque<int>d1;
    d1 =d;
    cout<<"d1:";
    printDeque(d1);

    //2
    deque<int>d2;
    d2.assign(d1.begin()+1,d1.end());
    cout<<"d2:";
    printDeque(d2);

    //3
    deque<int>d3;
    d3.assign({1,2,3,4,5,6,7});
    cout<<"d3:";
    printDeque(d3);

    //4
    deque<int>d4;
    d4.assign(8,6);
    cout<<"d4:";
    printDeque(d4);




    return 0;
}