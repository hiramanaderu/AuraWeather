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
    map<int,int>m;
    m.insert(
         pair<int,int>(1,12)
    );

    printmap(m);

    //2
    m.insert(make_pair(3,20));
    printmap(m);

    //3
    m.insert(map<int,int>::value_type(2,11));
    printmap(m);

    //4
    m[4] = 6;

    //5
    pair<map<int,int>::iterator,bool> ret=m.insert(make_pair(3,21));
    cout<<"insert(3,21) = "<<ret.second<<endl;

    printmap(m);

    //6
    m[3]=22;
    printmap(m);

    //7
    m[0];
    printmap(m);


    
    return 0;
}