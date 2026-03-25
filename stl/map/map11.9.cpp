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
    multimap<int,int>m = {
        pair<int,int>(1,12),pair<int,int>(1,12),pair<int,int>(1,12),pair<int,int>(1,12),
        pair<int,int>(3,31),pair<int,int>(3,31),pair<int,int>(3,31),
        pair<int,int>(4,43),pair<int,int>(4,43),pair<int,int>(4,43),
        pair<int,int>(2,93),pair<int,int>(2,93),pair<int,int>(2,93)
    };

    for(int i =-1 ; i<3;i++){
        cout<<i<<"的出现次数"<<m.count(i)<<endl;
    }


    
    return 0;
}