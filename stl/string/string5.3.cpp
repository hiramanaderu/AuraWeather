#include <iostream>

using namespace std;

int main(){

string s1;
s1="test";
cout<<s1<<endl;

string s2;
s2 = s1;
cout<<s2<<endl;

string s3;
s3='x';
cout<<s3<<endl;

string s4;
s4.assign("测试用例");
cout<<s4<<endl;

string s5;
s5.assign("测试用例",5);
cout<<s5<<endl;

string s6;
s6.assign(s5);
cout<<s6<<endl;

string s7;
s7.assign(8,'6');
cout<<s7<<endl;

    return 0;
}