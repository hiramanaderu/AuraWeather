#include<iostream>
#include<list>
using namespace std;

void printlist(const list<int>& l){
    for(list<int>::const_iterator it = l.begin(); it != l.end();it++){
        cout<<*it<<" ";

    }
    cout<<endl;
}

int main(){
    //1
    list<int>l1;
    cout<<"l1:";
    printlist(l1);
    //2
    list<int>l2_1 = {9,8,7,6};
    cout<<"l2_1:";
    printlist(l2_1);

    list<int>l2_2({91,123,122});
    cout<<"l2_2:";
    printlist(l2_2);

    //3
    list<int>l3(l2_1.begin(),l2_1.end());
    cout<<"l3:";
    printlist(l3);

    //4
    list<int>l4(8);
    cout<<"l4:";
    printlist(l4);
    
    //5
    list<int>l5(8,6);
    cout<<"l5:";
    printlist(l5);

    //6
    list<int>l6(l2_2);
    cout<<"l6:";
    printlist(l6);

    return 0;
}