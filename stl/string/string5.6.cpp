#include <iostream>

using namespace std;

int main(){
    string s =" i love you 1314";
    cout << s<<endl;
    for(unsigned i =0; i<s.size() ;++i){
        cout<<s[i]<<" ";
    }
    cout<<endl;

      cout << s<<endl;
    for(int i =0;i <s.size() ;++i){
        cout<<s.at(i)<<" ";
    }
    cout<<endl;

    //s.at(100);
    //s[100];  //debug版本报错

    //2.修改
    s[11] = '5';
    s[12] = '2';
    s.at(13) = '0';
    s.at(14) = ' ';
    cout <<s<<endl;


return 0;
}