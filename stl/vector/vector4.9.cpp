#include <iostream>
#include<vector>
using namespace std;

void printVector( vector<int>&v){
    for(vector<int>::iterator iter = v.begin(); iter != v.end(); iter++){
            cout<< *iter<<" ";

    } 
    cout<<endl;
}


int main(){
    vector<int> v;

    v.reserve(100);
    
    for (int i=0;i<100;++i){
        cout<<"size = "<<v.size()<<","<<"capacity = "<<v.capacity()<<endl;
        v.push_back(i);
    }

    
    return 0;
}