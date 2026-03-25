#include<iostream>
#include<set>
using namespace std;

void printset(const set<int>&s){
    for(set<int>::const_iterator it = s.begin();it!=s.end();it++){
        cout<<*it<<" ";
    }
    cout<<endl;
}

void printmultiset(const multiset<int>&ms){
    for(multiset<int>::const_iterator it = ms.begin();it!=ms.end();it++){
        cout<<*it<<" ";
    }
    cout<<endl;
}

int main(){
    set<int>s={1,2,3,4,5};
    for(int i =0 ;i<8;i+=2){
        cout<<"元素；"<<i<<"的出现次数"<<s.count(i)<<endl;
    
    }
    multiset<int>ms = {1,1,1,1,1,2,2,2,2,2,4,4,4,4,4,4,4,5,5,5,5,5,1};
    for(int i =0 ;i<8;i+=2){
        cout<<"元素；"<<i<<"的出现次数"<<ms.count(i)<<endl;
    
    }
    printmultiset(ms);

    return 0;
}