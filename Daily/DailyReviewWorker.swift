import Foundation
import FirebaseAuth
import FirebaseFirestore
import UserNotifications
import BackgroundTasks
import FirebaseFirestoreSwift

struct DailyReviewWorker {
    func run(task: BGAppRefreshTask) {
        Task {
            let ok = await generateSummary()
            task.setTaskCompleted(success: ok)
        }
    }

    @MainActor
    private func generateSummary() async -> Bool {
        guard let uid = Auth.auth().currentUser?.uid else { return false }

        let todayKey = Goal.todayKey
        let itemsPath = Firestore.firestore()
            .collection("users").document(uid)
            .collection("goals").document(todayKey)
            .collection("items")

        do {
            let snap = try await itemsPath.getDocuments()
            let goals = snap.documents.compactMap { try? $0.data(as: Goal.self) }
            let total = goals.count
            let done  = goals.filter { $0.isDone }.count

            let summary = DailySummary(id: todayKey,
                                       completedCount: done,
                                       totalCount: total,
                                       completionRate: total == 0 ? 0 : Double(done)/Double(total),
                                       generatedAt: Date())

            try Firestore.firestore()
                .collection("users").document(uid)
                .collection("summaries").document(todayKey)
                .setData(from: summary)

            let content = UNMutableNotificationContent()
            content.title = "Your day in review"
            content.body  = "You completed \(done)/\(total) goals (\(Int(summary.completionRate*100))%)."
            content.sound = .default

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            try await UNUserNotificationCenter.current().add(
                UNNotificationRequest(identifier: "summary-\(todayKey)", content: content, trigger: trigger))
            return true
        } catch {
            print("Daily summary error:", error)
            return false
        }
    }
}