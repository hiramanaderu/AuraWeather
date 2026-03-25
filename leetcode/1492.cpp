#include<iostream>
#include<vector>
using namespace std;



class Solution {
public:
    int kthFactor(int n, int k) {
        int s=0;
        vector<int>a;
      for(int i = 1 ; i<n;i++){
        if(n%i == 0){
            a.insert(a.begin()+s,i);
            s+=1;
        }
      }  
      if(s==0){
        return -1;
      }
      else{
      return a.at(k);
      }
    }
};