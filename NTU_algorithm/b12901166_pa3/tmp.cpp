// ************************************************************************
//  File       [main.cpp]
//  Author     [Yu-Hao Ho]
//  Synopsis   [The main program of 2024 fall Algorithm PA3]
//  Modify     [2024/12/21 Yin-Liang Chen]
// ************************************************************************

#include <cstring>
#include <iostream>
#include <fstream>
#include <vector>
#include <deque>
#include <unordered_set>
#include "../lib/tm_usage.h"

using namespace std;

struct Edge{
    int u;
    int v;
    int w;
    bool in_set=false;
 };

void counting_sort(vector<Edge> &edges,int num_edges){
    int min=-100;
    int max=100;
    int range=203;

    vector<int> num(range,0);
    for(int i=0;i<num_edges;i++){
        num[edges[i].w-min+1]++;
    }

    for(int i=range-2;i>0;i--){
        num[i]+=num[i+1];
    }

    vector<Edge> sorted_edges(edges.size());

    for(int i=0;i<num_edges;i++){
        sorted_edges[num[edges[i].w-min+1]-1]=edges[i];
        num[edges[i].w-min+1]--;
    }
    edges=sorted_edges;
}

void make_set(int* &target, int* &rank,int n){
    for(int i=0;i<n;i++){
        target[i]=i;
        rank[i]=0;
    }
}

int find_set(int x, int* &leader){
    if(leader[x]!=x){
        leader[x]=find_set(leader[x],leader);
    }
    return leader[x];
}

void Union(int x, int y, int* &leader,int* &rank){
    int x_root=find_set(x, leader);
    int y_root=find_set(y,leader);
    if(rank[x_root]<rank[y_root]){
        leader[x_root]=y_root;
    }else if(rank[x_root]>rank[y_root]){
        leader[y_root]=x_root;
    }else{
        leader[x_root]=y_root;
        rank[y_root]++;
    }
}


bool cycle_detect(vector<Edge> tree,int acyclic_total_num,int end, int start){
    deque<int> chain;
    unordered_set<int> visited;
    chain.push_back(start);
    while(!chain.empty()){
        int current=chain.back();
        chain.pop_back();
        if(current==end){
            return true;
        }
        if(visited.find(current)==visited.end()){   //current not visited
            visited.insert(current);        //current visited
            for(int i=0;i<acyclic_total_num;i++){        //find adjacent vertices
                if(tree[i].u==current){      //find u=current first
                    if(visited.find(tree[i].v)==visited.end()){      //if adjacent vertex not visited, add it
                        chain.push_back(tree[i].v);
                    }
                }
            }
        }
    }
    return false;
}

void help_message() {
    cout << "usage: cb <input_file> <output_file>" << endl;
}

int main(int argc, char* argv[]){
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

    char mode;
    int total_num_vertices;
    int total_num_edges;
    int removed_total_num=0;
    int new_removed_total_num=0;
    int final_weight=0;
    int new_final_weight=0;
    int acyclic_total_num=0;
    bool add;

    fin>>mode; 
    fin>>total_num_vertices;
    fin>>total_num_edges;

    int *leader_of_vertices=new int[total_num_vertices]; //saves the leader of [i]
    int *rank_of_vertices=new int[total_num_vertices];
    vector<Edge> edges;
    vector<Edge> final_edges;
    vector<Edge> new_final_edges;
    vector<Edge> acyclic_graph;
    make_set(leader_of_vertices,rank_of_vertices,total_num_vertices);

    for(int i=0;i<total_num_edges;i++){
        Edge current_edge;
        int a,b,c;
        fin>>a>>b>>c;
        current_edge.u=a;
        current_edge.v=b;
        current_edge.w=c;
        edges.push_back(current_edge);
    }
    int trash;
    fin>>trash;


    //////////// the counting part ////////////////
    tmusg.periodStart();

    counting_sort(edges,total_num_edges); // sort by decreasing order

    //-------------------MST-----------------//
    for(int i=0;i<total_num_edges;i++){
        if(find_set(edges[i].u,leader_of_vertices)!=find_set(edges[i].v,leader_of_vertices)){
            Union(edges[i].u,edges[i].v,leader_of_vertices,rank_of_vertices);
            acyclic_graph.push_back(edges[i]);
            acyclic_total_num++;
        }else{
            removed_total_num++;
            edges[i].in_set=1;
            final_weight+=edges[i].w;
            final_edges.push_back(edges[i]);
        }
    }
    //--------undirected alg----------//
    if(mode=='u'){

    }

    //------------directed alg-------------//
    if(mode=='d'){
        for(int i=0;i<removed_total_num;i++){
            add=cycle_detect(acyclic_graph,acyclic_total_num,final_edges[i].u,final_edges[i].v);  //form a cycle -->return true
            if(add){
                new_final_edges.push_back(final_edges[i]);
                new_removed_total_num++;
                new_final_weight+=final_edges[i].w;
            }
            else{
                acyclic_graph.push_back(final_edges[i]);
                acyclic_total_num++;
            }
        }
    }
    
    if(mode=='u'){
        fout<<final_weight<<'\n';
        for(int i=0;i<removed_total_num;i++){
            fout<<final_edges[i].u<<' '<<final_edges[i].v<<' '<<final_edges[i].w<<'\n';
        };
    }

    if(mode=='d'){
        fout<<new_final_weight<<'\n';
        for(int i=0;i<new_removed_total_num;i++){
            fout<<new_final_edges[i].u<<' '<<new_final_edges[i].v<<' '<<new_final_edges[i].w<<'\n';
        };
    }

    delete []leader_of_vertices;
    delete []rank_of_vertices;
    
    tmusg.getPeriodUsage(stat);
    cout <<"The total CPU time: " << (stat.uTime + stat.sTime) / 1000.0 << "ms" << '\n';
    cout <<"memory: " << stat.vmPeak << "KB" << '\n'; // print peak memory

    //////////// write the output file ///////////



    fin.close();
    fout.close();

    return 0;
}
