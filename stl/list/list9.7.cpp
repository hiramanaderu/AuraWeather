#include<iostream>
#include<list>
using namespace std;

void printlist(const list<int>& l){
    for(list<int>::const_iterator it = l.begin(); it != l.end();it++){
        cout<<*it<<" ";

    }
    cout<<endl;
}

int getlistitembyindex(list<int>& l,int index){
    list<int>::iterator it = l.begin();
    while (index)
    {
        it++;
        index--;
    }
    return *it;
    
}


int main(){
    list<int>l={9,8,5,2,1,1,-1};
    
    //无法进行随机访问

    cout<<getlistitembyindex(l,4)<<endl;
    
    cout<<l.front()<<endl;
    cout<<l.back()<<endl;
    
    return 0;
}