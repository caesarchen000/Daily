//
//  GoalListView.swift
//  Daily
//
//  Created by 陳胤亮 on 2025/7/7.
//

import Foundation
import SwiftUI

struct GoalListView: View {
    @StateObject private var svc = GoalsService()
    @State private var newText = ""
    @State private var isLoading = false

    var body: some View {
        VStack {
            if svc.goals.isEmpty && !isLoading {
                VStack(spacing: 20) {
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.yellow)
                    Text("No goals yet!")
                        .font(.title2)
                        .fontWeight(.medium)
                    Text("Add your first goal to get started")
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List {
                    ForEach(svc.goals) { goal in
                        GoalRow(goal: goal) { 
                            Task { await svc.toggle(goal) } 
                        }
                    }
                    .onDelete(perform: deleteGoals)
                    .animation(.default, value: svc.goals)

                    Section {
                        HStack {
                            TextField("Add a new goal", text: $newText)
                                .textFieldStyle(.roundedBorder)
                            
                            Button {
                                addGoal()
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                            }
                            .disabled(newText.trimmingCharacters(in: .whitespaces).isEmpty)
                        }
                        .padding(.vertical, 8)
                    }
                }
                .listStyle(.insetGrouped)
            }
            
            if isLoading {
                ProgressView("Loading goals...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationTitle("Today's Goals")
        .navigationBarTitleDisplayMode(.large)
    }
    
    private func addGoal() {
        let text = newText.trimmingCharacters(in: .whitespaces)
        guard !text.isEmpty else { return }
        
        isLoading = true
        Task {
            try? await svc.add(text: text)
            newText = ""
            isLoading = false
        }
    }
    
    private func deleteGoals(offsets: IndexSet) {
        Task {
            for index in offsets {
                let goal = svc.goals[index]
                await svc.delete(goal)
            }
        }
    }
}
