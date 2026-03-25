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
    vector<int>v ={9,8,7,6,5};
    cout<<v[2]<<endl;
    cout<<v.at(2)<<endl;
    /*
    cout<<v[12]<<endl;
    cout<<v.at(12)<<endl;
    */
    cout<<"front:"<<v.front()<<endl;
    cout<<"back:"<<v.back()<<endl;

    return 0;
}