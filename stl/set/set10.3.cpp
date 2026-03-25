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
    set<int>s = {9,8,5,2,1,1};
    cout<<"s:";
    printset(s);
    //1
    set<int>s1;
    s1 =s;
    cout<<"s1:";
    printset(s1);

    //2
    set<int>s2;
    s2 ={3,4,5};
    cout<<"s2:";
    printset(s2);


    return 0;
}