#include <iostream>
#include<vector>
using namespace std;

void printVector( vector<int>&v){
    for(vector<int>::iterator iter = v.begin(); iter != v.end(); iter++){
            cout<< *iter<<" ";

    } 
    cout<<endl;
}

void remove1(vector<int>&v , int index){
    v.erase(v.begin()+index);
}

void remove2(vector<int>&v , int index){
    swap(v[index],v.back());
    v.pop_back();
}


int main(){
    vector<int>v;
    for (int i=0;i<10;++i){
        
        v.push_back(i);
    }
    //remove1(v,4);
    remove2(v,4);
    printVector(v);

    return 0;
}