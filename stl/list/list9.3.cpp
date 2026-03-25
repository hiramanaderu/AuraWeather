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
    list<int>l={9,8,5,2,1,1};
    cout<<"l:";
    printlist(l);

    //1
    list<int>l1;
    l1 = l;
    cout<<"l1:";
    printlist(l1);

    //2
    list<int>l2;
    l2.assign(l1.begin(),l1.end());
    cout<<"l2:";
    printlist(l2);

    //3
    list<int>l3;
    l3.assign({1,2,3,4});
    cout<<"l3:";
    printlist(l3);

    //4
    list<int>l4;
    l4.assign( 8,6);
    cout<<"l4:";
    printlist(l4);

    
    return 0;
}