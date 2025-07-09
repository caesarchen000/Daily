//
//  GoalRow.swift
//  Daily
//
//  Created by 陳胤亮 on 2025/7/7.
//

import Foundation
import SwiftUI

struct GoalRow: View {
    let goal: Goal
    var onToggle: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onToggle) {
                Image(systemName: goal.isDone ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundColor(goal.isDone ? .green : .blue)
                    .animation(.easeInOut(duration: 0.2), value: goal.isDone)
            }
            .buttonStyle(PlainButtonStyle())
            
            Text(goal.text)
                .strikethrough(goal.isDone, color: .gray)
                .foregroundColor(goal.isDone ? .gray : .primary)
                .font(.body)
                .lineLimit(nil)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            if goal.isDone {
                Image(systemName: "star.fill")
                    .font(.caption)
                    .foregroundColor(.yellow)
                    .opacity(0.8)
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 4)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(goal.isDone ? Color.green.opacity(0.05) : Color.clear)
        )
        .animation(.easeInOut(duration: 0.3), value: goal.isDone)
    }
}
