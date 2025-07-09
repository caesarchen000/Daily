import Foundation
import FirebaseFirestoreSwift

struct DailySummary: Identifiable, Codable {
    @DocumentID var id: String?      // YYYY-MM-DD
    var completedCount: Int
    var totalCount: Int
    var completionRate: Double
    var generatedAt: Date
}