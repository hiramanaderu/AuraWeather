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
    list<int>l={1,2,3};
    printlist(l);
    l.reverse();
    printlist(l);
    
    return 0;
}