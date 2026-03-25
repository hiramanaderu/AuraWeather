#include <iostream>

using namespace std;

int main(){
    string s1 = "heworld";
    s1.insert(2,2,'l');
    cout<< s1<<endl;
    s1.insert(4,"o ");
    cout<<s1<<endl;
    
    s1.insert(s1.size(),"嘿嘿嘿");
    cout<<s1<<endl;

    s1.insert(s1.begin(),':');
    cout<<s1<<endl;
return 0;
}