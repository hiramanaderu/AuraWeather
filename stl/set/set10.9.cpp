#include<iostream>
#include<set>
using namespace std;

void printset(const set<int>&s){
    for(set<int>::const_iterator it = s.begin();it!=s.end();it++){
        cout<<*it<<" ";
    }
    cout<<endl;
}


class CGaGa{
public:
    CGaGa(){
        _name = " ";
        _priority = -1;
    }
    CGaGa(string name,int pri):_name(name),_priority(pri){}

    bool operator<(const CGaGa& other)const{
        return _priority < other._priority;
    }

    void print() const {
    cout<<"("<<_priority<<")"<<_name<<endl;
}

private:
    string _name;
    int _priority;
};




int main(){
    set<CGaGa>s;
    s.insert(CGaGa("C++算法", 5));
    s.insert(CGaGa("C++算", 2));
    s.insert(CGaGa("C++法", 1));
    s.insert(CGaGa("C++算法", 3));
    s.insert(CGaGa("C++stl", 4));

    for(set<CGaGa>::iterator it = s.begin(); it!= s.end();it++){
        (*it).print();
    }
    

    return 0;
}