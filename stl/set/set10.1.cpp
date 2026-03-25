#include<iostream>
#include<set>
using namespace std;

void printset(const set<int>&s){
    for(set<int>::const_iterator it = s.begin();it!=s.end();it++){
        cout<<*it<<" ";
    }
    cout<<endl;
}

int main(){


    return 0;
}