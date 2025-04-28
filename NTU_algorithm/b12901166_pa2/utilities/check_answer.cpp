// **************************************************************************
//  File       [main.cpp]
//  Author     [Yu-Hao Ho]
//  Synopsis   [The main program of 2024 fall Algorithm PA2]
//  Modify     [2024/10/31 Yin-Liang Chen]
// **************************************************************************

#include <cstring>
#include <iostream>
#include <fstream>
#include <set>
#include <vector>
#include "../lib/tm_usage.h"

using namespace std;

int main(int argc, char* argv[])
{
    
    fstream fin(argv[1]);
    fstream fout;

    int n;
    fin>>n;
    vector<int> check_list1;
    vector<int> check_list2;
    for(int i=0;i<n;i++){
        int n1,n2;
        fin>>n1>>n2;
        check_list1.push_back(n1);
        check_list2.push_back(n2);
    }
    bool check=true;
    for(int i=0;i<n-1 and check;i++){
        for(int j=0;i+j<n;j++){
            int n1,n2,n3,n4;
            n1=check_list1[i];
            n2=check_list1[i+j];       
            n3=check_list2[i]; 
            n4=check_list2[i+j];
            if(n1<n2 and n2<n3 and n3<n4){
                cout<<"error"<<'\n';
                cout<<n1<<' '<<n2<<' '<<n3<<' '<<n4;
                check=false;
                break;
            }
        }
    }

    if(check){
        cout<<"correct";
    }

    fin.close();
    return 0;
}