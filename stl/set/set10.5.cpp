#include<iostream>
#include<set>
#include<vector>
using namespace std;

void printset(const set<int>&s){
    for(set<int>::const_iterator it = s.begin();it!=s.end();it++){
        cout<<*it<<" ";
    }
    cout<<endl;
}

int main(){
    set<int>s;


    //O(logn)
    s.insert(1);printset(s);
    s.insert(2);printset(s);
    s.insert(5);printset(s);
    s.insert(4);printset(s);
    s.insert(3);printset(s);

    vector<int>v = {0,5,6,9,8};
    s.insert(v.begin(),v.end());
    printset(s);

    s.insert()

    return 0;
}