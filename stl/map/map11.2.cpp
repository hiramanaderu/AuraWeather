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
    //1
    map<int,int>m1;
    printmap(m1);

    //2
    map<int,int>m2_1 ={
        pair<int,int>(1,10),
        pair<int,int>(4,24),
        pair<int,int>(3,43),
        pair<int,int>(2,15),
    };
cout<<"m2_1: = "<<endl;
printmap(m2_1);

    
    map<int,int>m2_2 ({
        pair<int,int>(2,12),
        pair<int,int>(4,25),
        pair<int,int>(3,43),
        pair<int,int>(1,15),
    });
cout<<"m2_2: = "<<endl;
printmap(m2_2);

    //3
    map<int,int>m3(m2_1.begin(),m2_1.end());
    cout<<"m3: = "<<endl;
    printmap(m3);

    //4
    map<int,int>m4(m2_2);
    cout<<"m4: = "<<endl;
    printmap(m4);

    return 0;
}