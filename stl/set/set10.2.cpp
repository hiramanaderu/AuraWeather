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
    set<int>s1;
    multiset<int>ms;

    //1
    cout<<"s1:";
    printset(s1);

    //2
    set<int>s2_1{9,8,7,6,5};
    cout<<"s2_1:";
    printset(s2_1);

    set<int>s2_2({9,8,7,7,6,5});
    cout<<"s2_2:";
    printset(s2_2);

    //3
    set<int>s3(s2_1.begin(),s2_1.end());
    cout<<"s3:";
    printset(s3);

    //4
    set<int>s4(s2_2);
    cout<<"s4:";
    printset(s4);

    return 0;
}