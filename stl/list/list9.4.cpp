#include<iostream>
#include<list>
using namespace std;

void printlist(const list<int>& l){
    for(list<int>::const_iterator it = l.begin(); it != l.end();it++){
        cout<<*it<<" ";

    }
    cout<<endl;
}
/*
empty
size
resize
*/


int main(){
    list<int>l;
    cout<<"l.empty()="<<l.empty()<<endl;
    cout<<"l.size()="<<l.size()<<endl;
    
    l.assign({1,2,3});
    cout<<"l.empty()="<<l.empty()<<endl;
    cout<<"l.size()="<<l.size()<<endl;

    l.resize(18);
    cout<<"l.empty()="<<l.empty()<<endl;
    cout<<"l.size()="<<l.size()<<endl;
    printlist(l);

    l.resize(20,6);
    cout<<"l.empty()="<<l.empty()<<endl;
    cout<<"l.size()="<<l.size()<<endl;
    printlist(l);

    l.resize(10000);
    l.resize(5);
    cout<<"l.empty()="<<l.empty()<<endl;
    cout<<"l.size()="<<l.size()<<endl;
    printlist(l);
    
    return 0;
}