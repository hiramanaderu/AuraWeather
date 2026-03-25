#include<iostream>
#include<list>
using namespace std;

void printlist(const list<int>& l){
    for(list<int>::const_iterator it = l.begin(); it != l.end();it++){
        cout<<*it<<" ";

    }
    cout<<endl;
}

/*
push_front
push_back
insert
*/

int main(){
    list<int>l;
    

    //1
    l.push_front(-1);
    l.push_front(-2);
    l.push_front(-3);
    printlist(l);

    //2
    l.push_back(1);
    l.push_back(2);
    l.push_back(3);
    printlist(l);

    //3
    //3.1
    list<int>::iterator it =l.begin();
    it++;
    it++;
    it++;
    //it =it+1;
    l.insert(it,0);
    printlist(l);

    //3.2
    it = l.end();
    --it;
    l.insert(it,5,8);
    printlist(l);

    //3.3
    it = l.begin();
    it++;
    l.insert(it,l.begin(),l.end());
    printlist(l);
    l.insert()


    
    return 0;
}