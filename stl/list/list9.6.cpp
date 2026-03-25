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
pop_front
pop_back
erase,clear
*/
int main(){
    list<int>l={-1,9,8,5,2,1,1,-1};
    printlist(l);

    l.pop_back();
    printlist(l);
    l.pop_front();
    printlist(l);

    list<int>::iterator it;
    it=l.erase(l.begin());
    printlist(l);
    cout<<*it<<endl;
    it=l.erase(it);
    printlist(l);
    cout<<*it<<endl;

    it++;
    it++;
    l.erase(it,l.end());
    printlist(l);
    
    l.clear();
    printlist(l);
    cout<<"l.size()="<<l.size()<<endl;

    return 0;
}