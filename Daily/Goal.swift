//
//  Goal.swift
//  Daily
//
//  Created by 陳胤亮 on 2025/7/7.
//

import Foundation
import FirebaseFirestoreSwift

struct Goal: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    var text: String
    var isDone: Bool
    var createdAt: Date

    static var todayKey: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd"
        return fmt.string(from: Date())
    }
}
