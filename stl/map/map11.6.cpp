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
        pair<int,int>(1,12),
        pair<int,int>(3,31),
        pair<int,int>(4,43),
        pair<int,int>(2,93)
    };
    for(int i =4;i<=5;i++){
        map<int,int>::iterator it = m.find(i);
    if(it != m.end()){
        cout<<"找到键值对:("<<it->first<<","<<it->second<<")"<<endl;
    }
    else{
        cout<<"未找到健:"<<i<<endl;
    }
    }


    
    return 0;
}