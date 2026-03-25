#include<iostream>
#include<list>
using namespace std;

void printlist(const list<int>& l){
    for(list<int>::const_iterator it = l.begin(); it != l.end();it++){
        cout<<*it<<" ";

    }
    cout<<endl;
}

bool cmp(int a,int b){
    return a>b;
}

int main(){
    list<int>l={4,2,6,5,3,1};
    l.sort(cmp);
    printlist(l);


    
    return 0;
}