#include <iostream>

using namespace std;

int main(){
    string s1 = "英雄";
    string t1 = "出来";
    s1 = s1+"哪里";
    cout <<s1<<endl;
    s1 =s1 +t1;
    cout<<s1<<endl;
    s1 = s1 +":";
    cout<<s1<<endl;

    string s3 = "英雄";
    string t3 = "联盟";
    s3.append("算法");
    s3.append(t3);
    s3.append("5201314",3);    // 3 代表个数
    cout<<s3<<endl;
    s3.append("5201314",3,4);  // 3 代表位数
    cout<<s3<<endl;

    //push_back
    string s4 = "英雄编程";
    s4.push_back('6');
    s4.push_back('6');
    s4.push_back('6');
    s4.push_back(';');
    cout<<s4<<endl;

return 0;
}