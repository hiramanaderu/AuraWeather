#include<iostream>
#include<map>
using namespace std;

void printmap(const map<int,int>&m){
    for(map<int,int>::const_iterator it = m.begin();it!=m.end();it++){
        cout<<"key = "<<it -> first<<" "<<"value = "<<it -> second<<endl;
    }
    cout<<"--------------------"<<endl;
}


int main(){
    map<int,int>m ={
        pair<int,int>(1,10),
        pair<int,int>(4,24),
        pair<int,int>(3,43),
        pair<int,int>(2,15),
    };
    cout<<"m: = "<<endl;
    printmap(m);


    //1
    map<int,int>m1;
    m1 = m;
    cout<<"m1: = "<<endl;
    printmap(m1);

    //2
    map<int,int>m2=;
    m2 ={
        pair<int,int>(1,12),
        pair<int,int>(3,31),
        pair<int,int>(4,43),
        pair<int,int>(2,93),
    };
    cout<<"m2: = "<<endl;
    printmap(m2);

    

    
    return 0;
}