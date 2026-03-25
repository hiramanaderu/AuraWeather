#include <iostream>
#include<vector>
using namespace std;

void printVector( vector<int>&v){
    for(vector<int>::iterator iter = v.begin(); iter != v.end(); iter++){
            cout<< *iter<<" ";

    } 
    cout<<endl;
}


/*
1.pop_back
2.erase
3.clear
*/


int main(){
    vector<int>v={9,8,5,2,1,1};
    printVector(v);
    //pop_back
    v.pop_back();
    cout<<"v:";
    printVector(v);

    //erase
    vector<int>::iterator it=v.erase(v.begin()+1);
    printVector(v);
    cout<<*it<<endl;


    //clear
    v.clear();
    printVector(v);



    return 0;
}