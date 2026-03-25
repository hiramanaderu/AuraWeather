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
     map<int,int>m = {
        pair<int,int>(1,12),
        pair<int,int>(3,31),
        pair<int,int>(4,43),
        pair<int,int>(2,93)
    };

    m[3]=88;

    printmap(m);

    m[2]++;
    printmap(m);

    m[1]-=21;
    printmap(m);
    
    return 0;
}
