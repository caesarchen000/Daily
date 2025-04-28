#include <cstring>
#include <iostream>
#include <vector>
#include <set>

using namespace std;


int **max_chord;
int *chord;                                   //saves the given chords on planar
int total_num;                                //total number of nodes on planar
int **calculated;                             //max num of chords in [i,j]
set<pair<int,int>> max_chord_pair;            //what chords can made msp

bool opt;

int MAX_CHORD(int i, int j,bool opt){
    if(i<0 or j<=i){
        return 0;
    }
    if(calculated[i][j]!=-1 and !opt){
        return calculated[i][j];
    }
    if(chord[j]==i){
        if(opt){
            max_chord_pair.insert(make_pair(chord[j],j));
        }
        calculated[i][j]=MAX_CHORD(i+1,j-1,opt)+1;
        return calculated[i][j];
    }else if(chord[j]>j or chord[j]<i){
        calculated[i][j]=MAX_CHORD(i,j-1,opt);
        return calculated[i][j];
    }else{
        int prev=1+MAX_CHORD(i,chord[j]-1,false)+MAX_CHORD(chord[j]+1,j-1,false);
        int latter=MAX_CHORD(i,j-1,false);
        if(prev>latter){
            if(opt){
                max_chord_pair.insert(make_pair(chord[j],j));
                prev=1+MAX_CHORD(i,chord[j]-1,opt)+MAX_CHORD(chord[j]+1,j-1,opt);
            }
            calculated[i][j]=prev;
        }else{
            calculated[i][j]=latter;
            if(opt){
                latter=MAX_CHORD(i,j-1,opt);
            }
        }
    }
    if(opt){
        max_chord_pair.insert(make_pair(chord[j],j));
    }
    return calculated[i][j];
}

int main(){

    //////////// read the input file /////////////

    int first_node,second_node;
    cin>>total_num; 
    chord=new int[total_num]; 
    for(int i=0;i<total_num;i+=2){
        cin >> first_node >> second_node;
        chord[first_node]=second_node;
        chord[second_node]=first_node;
    }

    int trash; //0
    cin>>trash;

    /*
    max_chord=new int*[total_num];
    for(int i=0;i<total_num;i++){
        max_chord[i]=new int[total_num]();
    }
    */

    calculated=new int*[total_num];
    for(int i=0;i<total_num;i++){
        calculated[i]=new int[total_num];
        for(int j=0;j<total_num;j++){
            calculated[i][j]=-1;
        }
    }


    int msp_num=MAX_CHORD(0,total_num,true);
    /*

    for(int i=0;i<total_num;i++){
        for(int j=0;j<total_num;j++){
            if(chord[j]>j or chord[j]<i){
                max_chord[i][j]=max_chord[i][j-1];
            }
            else if(chord[j]==i){
                max_chord[i][j]=max_chord[i][j-1]+1;
            }
            else{   
                if(1+max_chord[i][chord[j]-1]+max_chord[chord[j]+1][j-1]>max_chord[i][j-1]){
                    max_chord[i][j]=1+max_chord[i][chord[j]-1]+max_chord[chord[j]+1][j-1];
                }else{
                    max_chord[i][j]=max_chord[i][j-1];
                }
            }
        }
    }

    */
   cout<<msp_num<<'\n';
   for(const auto& p:max_chord_pair){
        cout<<p.first<<' '<<p.second<<'\n';
   }
}
