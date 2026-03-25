#include <iostream>

using namespace std;

int main(){
    string s1;
    cout<< s1 << endl;


    string s2({'h','e','l','l','o'});
    cout << s2<< endl;

    string s3 ("测试");
    cout << s3 <<endl;

    string s4 ("测试测试测试",6);
    cout << s4 <<endl;

    string s41 ("测试测试测试",5);
    cout << s41 <<endl;
    cout << (int)s41[4]<< endl;
    cout << s41.size()<<endl;

    string s5 (s4);
    cout<<s5<<endl;

    string s6 (8,'o');
    cout<<s6<<endl;
    return 0;
}