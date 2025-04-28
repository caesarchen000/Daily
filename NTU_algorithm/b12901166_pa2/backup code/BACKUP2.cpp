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
#include <map>
#include "../lib/tm_usage.h"

using namespace std;

void help_message() {
    cout << "usage: mps <input_file> <output_file>" << endl;

}

int *chord;                                   //saves the given chords on planar
int total_num;                                //total number of nodes on planar
//int **calculated;                             //max num of chords in [i,j]
set<pair<int,int>> max_chord_pair;            //what chords can made msp

map<pair<int,int>,int>calculated;             //max num of chords in [i,j]
bool opt;                                     //desides whether we should record the chord                     

int MAX_CHORD(int i, int j,bool opt){         //the recursion to solve the problem
    if(i<0 or j<=i){
        return 0;
    }
    auto it = calculated.find(make_pair(i, j));
    if(it !=calculated.end() and !opt){
        return calculated[make_pair(i,j)];
    }
    if(chord[j]==i){
        if(opt){
            max_chord_pair.insert(make_pair(chord[j],j));
        }
        calculated[make_pair(i,j)]=MAX_CHORD(i+1,j-1,opt)+1;
        return calculated[make_pair(i,j)];
    }else if(chord[j]>j or chord[j]<i){
        calculated[make_pair(i,j)]=MAX_CHORD(i,j-1,opt);
        return calculated[make_pair(i,j)];
    }else{
        int prev=1+MAX_CHORD(i,chord[j]-1,false)+MAX_CHORD(chord[j]+1,j-1,false);
        int latter=MAX_CHORD(i,j-1,false);
        if(prev>=latter){
            if(opt){
                max_chord_pair.insert(make_pair(chord[j],j));
                prev=1+MAX_CHORD(i,chord[j]-1,opt)+MAX_CHORD(chord[j]+1,j-1,opt);
            }
            calculated[make_pair(i,j)]=prev;
        }else{
            calculated[make_pair(i,j)]=latter;
            if(opt){
                latter=MAX_CHORD(i,j-1,opt);
            }
        }
    }
    return calculated[make_pair(i,j)];
}

int main(int argc, char* argv[])
{
    if(argc != 3) {
       help_message();
       return 0;
    }
    CommonNs::TmUsage tmusg;
    CommonNs::TmStat stat;

    //////////// read the input file /////////////
    
    fstream fin(argv[1]);
    fstream fout;
    fout.open(argv[2],ios::out);


    
    int first_node,second_node;
    fin>>total_num; 
    chord=new int[total_num](); 
    for(int i=0;i<total_num;i+=2){
        fin >> first_node >> second_node;
        chord[first_node]=second_node;
        chord[second_node]=first_node;
    }

    int trash; //0
    fin>>trash;



    //////////// the counting part ////////////////
    tmusg.periodStart();

    int msp_num=MAX_CHORD(0,total_num-1,true);

    
    tmusg.getPeriodUsage(stat);
    cout <<"The total CPU time: " << (stat.uTime + stat.sTime) / 1000.0 << "ms" << '\n';
    cout <<"memory: " << stat.vmPeak << "KB" << '\n'; // print peak memory

    //////////// write the output file ///////////
    fout << msp_num <<'\n';

    for(const auto& p:max_chord_pair){
        fout<<p.first<<' '<<p.second<<'\n';
    }

    delete[] chord;

    fin.close();
    fout.close();
    return 0;
}
