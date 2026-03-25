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


    
    return 0;
}